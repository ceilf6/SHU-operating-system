import { type ComponentPropsWithoutRef } from "react";
import clsx from "clsx";
import ReactMarkdown from "react-markdown";
import rehypeSlug from "rehype-slug";
import remarkGfm from "remark-gfm";

interface MarkdownArticleProps {
  content: string;
  idPrefix?: string;
}

function resolveAssetUrl(src?: string) {
  if (!src) {
    return "";
  }
  if (/^(https?:)?\/\//.test(src) || src.startsWith("data:")) {
    return src;
  }
  if (src.startsWith("/")) {
    return `${import.meta.env.BASE_URL}${src.replace(/^\/+/, "")}`;
  }
  return src;
}

type HeadingTag = "h1" | "h2" | "h3" | "h4";
type HeadingProps = ComponentPropsWithoutRef<HeadingTag>;

function createHeading(tag: HeadingTag) {
  return function Heading({ id, className, children, ...props }: HeadingProps) {
    const Tag = tag;

    return (
      <Tag id={id} className={clsx("markdown-heading", `markdown-heading-${tag}`, className)} {...props}>
        <span className="min-w-0">{children}</span>
        {id ? (
          <a href={`#${id}`} className="markdown-heading-anchor" aria-label="跳转到当前标题锚点">
            #
          </a>
        ) : null}
      </Tag>
    );
  };
}

export function MarkdownArticle({ content, idPrefix = "" }: MarkdownArticleProps) {
  return (
    <div className="markdown-block">
      <ReactMarkdown
        remarkPlugins={[remarkGfm]}
        rehypePlugins={[[rehypeSlug, { prefix: idPrefix }]]}
        components={{
          img: ({ src, alt }) => <img src={resolveAssetUrl(src)} alt={alt ?? ""} loading="lazy" />,
          h1: createHeading("h1"),
          h2: createHeading("h2"),
          h3: createHeading("h3"),
          h4: createHeading("h4"),
        }}
      >
        {content}
      </ReactMarkdown>
    </div>
  );
}
