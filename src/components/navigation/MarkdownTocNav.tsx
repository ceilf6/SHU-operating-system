import clsx from "clsx";
import { MarkdownHeading } from "../../lib/content";

interface MarkdownTocGroup {
  id: string;
  title: string;
  items: MarkdownHeading[];
}

interface MarkdownTocNavProps {
  eyebrow?: string;
  title?: string;
  groups: MarkdownTocGroup[];
}

const depthClassNames: Record<number, string> = {
  1: "pl-3",
  2: "pl-3",
  3: "pl-6",
  4: "pl-9",
};

export function MarkdownTocNav({
  eyebrow = "页面目录",
  title = "标题跳转",
  groups,
}: MarkdownTocNavProps) {
  const visibleGroups = groups.filter((group) => group.items.length > 0);

  if (!visibleGroups.length) {
    return null;
  }

  return (
    <section className="glass-card sticky top-24 max-h-[calc(100vh-7rem)] overflow-auto rounded-[28px] p-5">
      <div className="eyebrow">{eyebrow}</div>
      <h3 className="page-title mt-4 text-xl text-[color:var(--ink-1)]">{title}</h3>
      <div className="mt-5 space-y-5">
        {visibleGroups.map((group) => (
          <div key={group.id}>
            <p className="text-xs uppercase tracking-[0.22em] text-[color:var(--signal-blue)]">{group.title}</p>
            <div className="mt-3 space-y-2">
              {group.items.map((item) => (
                <a
                  key={item.id}
                  href={`#${item.id}`}
                  className={clsx(
                    "block rounded-2xl border border-transparent bg-white/70 px-3 py-2 text-sm leading-6 text-[color:var(--ink-2)] transition hover:border-[rgba(52,106,144,0.28)] hover:bg-white hover:text-[color:var(--ink-1)]",
                    depthClassNames[item.depth] ?? depthClassNames[4],
                  )}
                >
                  {item.title}
                </a>
              ))}
            </div>
          </div>
        ))}
      </div>
    </section>
  );
}
