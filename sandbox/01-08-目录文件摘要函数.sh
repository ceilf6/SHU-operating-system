#!/usr/bin/env bash

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SUMMARY_ROOT="$SCRIPT_DIR/test-files/mock-summary"

summarize_directory() {
  local target_dir="$1"
  local file_count=0
  local subdir_count=0
  local recursive_file_count=0
  local entry

  if [ ! -d "$target_dir" ]; then
    echo "目录不存在: $target_dir"
    return 1
  fi

  for entry in "$target_dir"/*; do
    [ -e "$entry" ] || continue

    if [ -f "$entry" ]; then
      file_count=$((file_count + 1))
    elif [ -d "$entry" ]; then
      subdir_count=$((subdir_count + 1))
    fi
  done

  recursive_file_count=$(find "$target_dir" -type f | wc -l | tr -d ' ')

  echo "目录摘要: $target_dir"
  echo "当前层级普通文件数: $file_count"
  echo "当前层级子目录数: $subdir_count"
  echo "递归普通文件总数: $recursive_file_count"
  echo
}

summarize_directory "$SUMMARY_ROOT/alpha"
summarize_directory "$SUMMARY_ROOT/beta"
summarize_directory "$SUMMARY_ROOT/empty"
