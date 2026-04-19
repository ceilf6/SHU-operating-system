import { readFile, writeFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

import GithubSlugger from "github-slugger";
import { toString } from "mdast-util-to-string";
import remarkGfm from "remark-gfm";
import remarkParse from "remark-parse";
import { unified } from "unified";
import { visit } from "unist-util-visit";

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const GENERATED_DIR = path.join(ROOT, "src", "content", "generated");
const NOTES_PATH = path.join(GENERATED_DIR, "notes.json");
const TD_PAGES_PATH = path.join(GENERATED_DIR, "td-pages.json");

function normalizeHeadingText(value) {
  return value.replace(/\s+/g, " ").trim();
}

function isGenericHeading(title) {
  return /^(page|slide)\s+\d+$/i.test(title) || /^第\s*\d+\s*页(?:[:：].*)?$/u.test(title);
}

function extractHeadings(content, { idPrefix = "" } = {}) {
  const tree = unified().use(remarkParse).use(remarkGfm).parse(content);
  const slugger = new GithubSlugger();
  const headings = [];

  visit(tree, "heading", (node) => {
    if (node.depth > 4) {
      return;
    }

    const title = normalizeHeadingText(toString(node));
    if (!title || isGenericHeading(title)) {
      return;
    }

    headings.push({
      depth: node.depth,
      title,
      id: `${idPrefix}${slugger.slug(title)}`,
    });
  });

  return headings;
}

async function loadJson(filePath) {
  return JSON.parse(await readFile(filePath, "utf8"));
}

async function writeJson(filePath, value) {
  await writeFile(filePath, `${JSON.stringify(value, null, 2)}\n`, "utf8");
}

async function main() {
  const notes = await loadJson(NOTES_PATH);
  const tdPages = await loadJson(TD_PAGES_PATH);

  const enrichedNotes = notes.map((note) => ({
    ...note,
    headings: extractHeadings(note.content),
  }));

  const enrichedTdPages = tdPages.map((tdPage) => ({
    ...tdPage,
    noteEntries: tdPage.noteEntries.map((noteEntry) => ({
      ...noteEntry,
      headings: extractHeadings(noteEntry.content, { idPrefix: `${noteEntry.slug}-` }),
    })),
  }));

  await writeJson(NOTES_PATH, enrichedNotes);
  await writeJson(TD_PAGES_PATH, enrichedTdPages);

  console.log(`Enriched ${enrichedNotes.length} notes and ${enrichedTdPages.length} TD pages with heading metadata.`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
