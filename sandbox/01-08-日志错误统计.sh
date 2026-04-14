#!/usr/bin/env bash

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/test-files/mock-logs"

shopt -s nullglob
log_files=("$LOG_DIR"/*.log)

if [ ${#log_files[@]} -eq 0 ]; then
  echo "未找到日志文件: $LOG_DIR"
  exit 1
fi

total_error_count=0

echo "开始扫描日志目录: $LOG_DIR"

for log_file in "${log_files[@]}"; do
  file_error_count=0

  while IFS= read -r line; do
    case "$line" in
      *ERROR*)
        file_error_count=$((file_error_count + 1))
        total_error_count=$((total_error_count + 1))
        ;;
    esac
  done < "$log_file"

  echo "$(basename "$log_file"): ERROR 行数 = $file_error_count"
done

echo "总 ERROR 行数 = $total_error_count"
