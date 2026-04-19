import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";

interface MarkdownArticleProps {
  content: string;
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

export function MarkdownArticle({ content }: MarkdownArticleProps) {
  return (
    <div className="markdown-block">
      <ReactMarkdown
        remarkPlugins={[remarkGfm]}
        components={{
          img: ({ src, alt }) => <img src={resolveAssetUrl(src)} alt={alt ?? ""} loading="lazy" />,
        }}
      >
        {content}
      </ReactMarkdown>
    </div>
  );
}
