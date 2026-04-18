import { spawn } from "node:child_process";
import { watch } from "node:fs";
import path from "node:path";
import process from "node:process";

const ROOT = process.cwd();
const NPM_COMMAND = process.platform === "win32" ? "npm.cmd" : "npm";
const VITE_ARGS = process.argv.slice(2);
const WATCH_SPECS = [
  { target: ".", recursive: false },
  { target: "notes", recursive: true },
  { target: "base-files", recursive: true },
  { target: "sandbox", recursive: true },
  { target: "scripts", recursive: true },
];
const DEBOUNCE_MS = 250;

let shuttingDown = false;
let generateProcess = null;
let viteProcess = null;
let debounceTimer = null;
let queuedReason = null;
let rerunRequested = false;
const watchers = [];

function log(message) {
  console.log(`[dev] ${message}`);
}

function normalizeChangedPath(target, filename = "") {
  const normalizedTarget = target.replaceAll("\\", "/");
  if (!filename) {
    return normalizedTarget;
  }

  const normalizedFilename = filename.replaceAll("\\", "/");
  if (path.posix.extname(normalizedTarget) && normalizedFilename === path.posix.basename(normalizedTarget)) {
    return normalizedTarget;
  }

  return path.posix.join(normalizedTarget, normalizedFilename);
}

function shouldIgnoreChange(changedPath) {
  return (
    (!changedPath.includes("/") && changedPath !== "README.md") ||
    changedPath.startsWith("sandbox/test-files/") ||
    changedPath.startsWith("scripts/__pycache__/") ||
    (changedPath.startsWith("scripts/") && !changedPath.endsWith(".py")) ||
    changedPath.includes("/.DS_Store") ||
    changedPath.endsWith("/.DS_Store") ||
    changedPath.endsWith(".pyc")
  );
}

function spawnNpm(args, options = {}) {
  return spawn(NPM_COMMAND, args, {
    cwd: ROOT,
    stdio: "inherit",
    ...options,
  });
}

function runGenerate(reason) {
  if (shuttingDown) {
    return;
  }

  if (generateProcess) {
    rerunRequested = true;
    queuedReason = reason;
    return;
  }

  log(`重新生成内容: ${reason}`);
  generateProcess = spawnNpm(["run", "generate"]);

  generateProcess.on("exit", (code, signal) => {
    generateProcess = null;

    if (signal) {
      log(`generate 被信号中断: ${signal}`);
    } else if (code === 0) {
      log("内容生成完成");
    } else {
      log(`generate 失败，退出码 ${code}`);
    }

    if (rerunRequested && !shuttingDown) {
      const nextReason = queuedReason ?? "排队中的改动";
      rerunRequested = false;
      queuedReason = null;
      runGenerate(nextReason);
    } else {
      rerunRequested = false;
      queuedReason = null;
    }
  });
}

function scheduleGenerate(reason) {
  if (shuttingDown) {
    return;
  }

  if (debounceTimer) {
    clearTimeout(debounceTimer);
  }

  debounceTimer = setTimeout(() => {
    debounceTimer = null;
    runGenerate(reason);
  }, DEBOUNCE_MS);
}

function startWatchers() {
  for (const spec of WATCH_SPECS) {
    const watcher = watch(
      path.join(ROOT, spec.target),
      { recursive: spec.recursive },
      (_eventType, filename) => {
        const changedPath = normalizeChangedPath(spec.target, filename ? String(filename) : "");
        if (shouldIgnoreChange(changedPath)) {
          return;
        }
        scheduleGenerate(changedPath);
      },
    );
    watchers.push(watcher);
  }

  log("已启用内容监听: README.md, notes/, base-files/, sandbox/, scripts/*.py");
}

function stopWatchers() {
  for (const watcher of watchers) {
    watcher.close();
  }
  watchers.length = 0;
}

function shutdown(exitCode = 0) {
  if (shuttingDown) {
    return;
  }

  shuttingDown = true;
  stopWatchers();

  if (debounceTimer) {
    clearTimeout(debounceTimer);
    debounceTimer = null;
  }

  if (generateProcess) {
    generateProcess.kill("SIGTERM");
  }

  if (viteProcess) {
    viteProcess.kill("SIGTERM");
  }

  process.exit(exitCode);
}

function startVite() {
  viteProcess = spawnNpm(["run", "dev:vite", "--", ...VITE_ARGS]);

  viteProcess.on("exit", (code, signal) => {
    if (shuttingDown) {
      return;
    }

    if (signal) {
      log(`vite 被信号中断: ${signal}`);
      shutdown(0);
      return;
    }

    shutdown(code ?? 0);
  });
}

function runInitialGenerate() {
  return new Promise((resolve, reject) => {
    log("启动前生成课程内容");
    const child = spawnNpm(["run", "generate"]);

    child.on("exit", (code, signal) => {
      if (signal) {
        reject(new Error(`初始 generate 被信号中断: ${signal}`));
        return;
      }
      if (code !== 0) {
        reject(new Error(`初始 generate 失败，退出码 ${code}`));
        return;
      }
      resolve();
    });
  });
}

process.on("SIGINT", () => shutdown(0));
process.on("SIGTERM", () => shutdown(0));

try {
  await runInitialGenerate();
  startWatchers();
  startVite();
} catch (error) {
  console.error(`[dev] ${error instanceof Error ? error.message : String(error)}`);
  process.exit(1);
}
