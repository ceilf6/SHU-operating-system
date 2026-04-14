#!/usr/bin/env bash

trash_dir="$(pwd -P)/.poubelle"

usage() {
    echo "用法: $0 fichier|dossier [...]" >&2
    exit 1
}

cleanup_trash() {
    [ -d "$trash_dir" ] || return 0

    find "$trash_dir" -mindepth 1 -maxdepth 1 -mtime +30 -exec rm -rf {} +
}

absolute_path() {
    local target="$1"

    if [ -d "$target" ] && [ ! -L "$target" ]; then
        (cd "$target" && pwd -P)
        return
    fi

    printf '%s/%s\n' "$(cd "$(dirname "$target")" && pwd -P)" "$(basename "$target")"
}

make_backup_name() {
    local target="$1"
    local timestamp sanitized candidate suffix

    timestamp="$(date '+%Y%m%d-%H%M%S')"
    sanitized="${target#./}"
    sanitized="${sanitized#/}"
    sanitized="${sanitized//\//__}"
    [ -n "$sanitized" ] || sanitized="item"

    candidate="${sanitized}_${timestamp}"
    suffix=0
    while [ -e "$trash_dir/$candidate" ]; do
        suffix=$((suffix + 1))
        candidate="${sanitized}_${timestamp}_$suffix"
    done

    printf '%s\n' "$candidate"
}

is_inside_trash() {
    local target="$1"
    local target_abs

    target_abs="$(absolute_path "$target")"

    case "$target_abs" in
        "$trash_dir"|"$trash_dir"/*)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

would_include_trash() {
    local target="$1"
    local target_abs

    target_abs="$(absolute_path "$target")"

    case "$trash_dir" in
        "$target_abs"|"$target_abs"/*)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

backup_and_remove() {
    local target="$1"
    local backup_name

    if [ ! -e "$target" ] && [ ! -L "$target" ]; then
        echo "目标不存在: $target" >&2
        return 1
    fi

    if is_inside_trash "$target"; then
        echo "拒绝操作 .poubelle 中的内容: $target" >&2
        return 1
    fi

    if would_include_trash "$target"; then
        echo "拒绝删除会包含 .poubelle 的目录: $target" >&2
        return 1
    fi

    backup_name="$(make_backup_name "$target")" || return 1

    cp -RP "$target" "$trash_dir/$backup_name" || return 1
    rm -rf "$target"
}

main() {
    local status=0

    [ "$#" -gt 0 ] || usage

    mkdir -p "$trash_dir" || exit 1
    cleanup_trash

    for target in "$@"; do
        if ! backup_and_remove "$target"; then
            status=1
        fi
    done

    exit "$status"
}

main "$@"
