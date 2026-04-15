# echo $1 | grep '^\(.*\).?\1$' # 后面不是倒序、不行

str="$1"
revStr=$(printf "%s" "$str" | rev) # rev命令可以将字符串反转

if [ "$str" = "$revStr" ]; then
    echo "是回文字符串"
else
    echo "不是回文字符串"
fi