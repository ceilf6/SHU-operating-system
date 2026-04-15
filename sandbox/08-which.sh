# 目标 - 两种用法
# 1. -a 输出所有找到的可执行文件路径 # bash ./08-which.sh -a git
# 2. -s 不输出内容，通过返回值表示是否找到 # bash ./08-which.sh -s git ; echo $?

oldIFS=$IFS # 用于后面恢复，答案中直接用的 unset 不如先缓存 oldIFS
IFS=:
# 为了后面分割 $PATH

flag=1
# 是否找到命令的标志位，延续 Shell 用 0 表示成功、1 表示失败

# 可以通过 $# 是否为 2 检测输入是否正常
if [ $# -ne 2 ]
then
    echo "需要且只需要 2 个参数"
    exit 1
    # 1 表示失败
fi

if [ "$1" != "-a" -a "$1" != "-s" ]
then
    echo "目前只支持 -a 或 -s 模式"
    exit 1
fi

for i in $PATH
# 因为前面修改了分割符，所以这里的 in 会把 $PATH 分割为多个目录依次遍历
do
    if [ -x "$i/$2" ]
    # 存在该程序且可执行
    then
        # 那么就根据不同的模式做对应的处理
        if [ "$1" = "-a" ]
        then
            echo "$i/$2"
        fi
        flag=0
    fi
done

if [ $1 == "-s" ]; then
    # echo $flag
    # 答案里面用的是 echo 但是最好是用 exit 返回码这样后续才能 $? 捕获
    exit "$flag"
fi

# unset IFS # 恢复分割符防止影响后面 Shell 行为
IFS=$oldIFS