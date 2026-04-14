#!/usr/bin/env bash

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

important_dirs=(
  "$PROJECT_ROOT/base-files"
  "$PROJECT_ROOT/notes"
  "$PROJECT_ROOT/sandbox"
)

echo "检查重要目录磁盘使用情况"

for dir_path in "${important_dirs[@]}"; do
  if [ -d "$dir_path" ]; then
    usage=$(du -sh "$dir_path" 2>/dev/null | awk '{print $1}')
    echo "$(basename "$dir_path"): $usage ($dir_path)"
  else
    echo "目录不存在: $dir_path"
  fi
done
