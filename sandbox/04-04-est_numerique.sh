case "$1" in
    ''|*[!0-9]*)
    # 空字符串
    # 或者 *任意长度字符串 出现一个不是数字的字符 *任意长度字符串
        echo "不是数字"
        ;;
    *)
        echo "是数字"
        ;;
esac

# -eq 数字比较要求两端都是数字
if test "$1" -eq "$1" 2>/dev/null
then
    echo "是数字"
else
    echo "不是数字"
fi