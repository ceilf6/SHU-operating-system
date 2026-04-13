python3 - <<'PY'
from pathlib import Path
p = Path.home() / ".zshrc"
text = p.read_text() if p.exists() else ""

lines = text.splitlines()
filtered = []
for line in lines:
    s = line.strip()
    if s in {
        "bindkey '^I' autosuggest-accept",
        'bindkey "^I" autosuggest-accept',
    }:
        continue
    filtered.append(line)

append = """
# Tab 优先接受 zsh-autosuggestions 的灰色建议
bindkey '^I' autosuggest-accept
""".strip()

new_text = "\n".join(filtered).rstrip() + "\n\n" + append + "\n"
p.write_text(new_text)
print("Updated ~/.zshrc")
PY

source ~/.zshrc