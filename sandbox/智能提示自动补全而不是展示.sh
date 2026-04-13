python3 - <<'PY'
from pathlib import Path
p = Path.home() / ".zshrc"
text = p.read_text() if p.exists() else ""

lines = text.splitlines()
filtered = []
for line in lines:
    s = line.strip()
    if s in {
        "zstyle ':completion:*' menu select",
        'zstyle ":completion:*" menu select',
        "setopt AUTO_MENU",
    }:
        continue
    filtered.append(line)

append = """
unsetopt AUTO_MENU
unsetopt LIST_AMBIGUOUS
unsetopt AUTO_LIST
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
""".strip()

new_text = "\n".join(filtered).rstrip() + "\n\n" + append + "\n"
p.write_text(new_text)
print("Updated ~/.zshrc")
PY

source ~/.zshrc