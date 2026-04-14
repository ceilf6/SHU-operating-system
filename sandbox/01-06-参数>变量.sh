echo "PS1 $PS1"

echo "PATH $PATH"

echo "REPLY $REPLY"

echo "IFS $IFS"


echo "TERM $TERM"


vFromUser=1 # 注意不要空格画蛇添足，有空格就变成了三个字段识别为命令了
echo "vFromUser $vFromUser"

# 读取
read vFromUser
echo "vFromUser $vFromUser"
# 当 read 出现在管道时，常常运行在子 shell 里，所以如果想保存的话不要写在管道里面

# 在不指定变量名时，默认保存到 REPLY 中
read
echo "REPLY $REPLY"

# 提示词
read -p "覆盖objFromUser: " vFromUser
echo "vFromUser $vFromUser"

echo "
=== set显示所有变量"
set
# 原来代理配置是在 set 设置了变量 并且是环境变量
# all_proxy=socks5://127.0.0.1:7891
# http_proxy=http://127.0.0.1:7890
# https_proxy=http://127.0.0.1:7890

# unset 删除变量
unset vFromUser
echo "vFromUser $vFromUser"

read v1 v2 # 1 2
echo "v1 $v1"
echo "v2 $v2"

# 字段分隔符
IFS=:
read v1 v2 # 2:3
echo "v1 $v1"
echo "v2 $v2"

# 常量
declare -r readOnlyV1=100 readOnlyV2=200 
# 尝试修改会报错 ./01-06-参数>变量.sh:48: read-only variable: readOnlyV1

echo "
=== 常量"
## 查看常量
declare -r

# 环境变量
export envV='env'

## env读取
echo "
=== env"
env
echo "envV $envV"

# 脚本输入参数依次传入 1, 2 ...
echo "0 $0" # ./01-06-参数>变量.sh
echo "1 $1" # 111
echo "2 $2" # 222
echo "3 $3" # 333
echo "4 $4" # 444

echo "\$# $#" # 4 个数
echo "\$* $*" # 111:222:333:444
echo "\$@ $@" # 111 222 333 444

echo "=== shift"
## 向左偏移1
shift 
echo "1 $1" # 222
echo "2 $2" # 333
echo "3 $3" # 444
echo "4 $4"

echo "=== shift 2 继续偏移2个"
shift 2
echo "1 $1" # 444
echo "2 $2"
echo "3 $3"
echo "4 $4"

# set重新设置参数
set 'set1' 'set2'
echo "1 $1" # set1
echo "2 $2" # set2

# 为消除歧义，引用变量时最好用 ${ } ，就像模版字符串一样
echo "1 ${1}"

# 命令替换
foo() {
  echo $((1 + 1))
}
fooRes=$(foo)
echo "foo res ${fooRes}"

pwdRes=$(pwd)
echo "pwd res ${pwdRes}"

## 命令替换结果中含有 - 被误当成了外层命令的选项配置
# set $(ls -l ./配置交互智能提示.sh)
### 解决方案: 用 -- 阻止选项解析
set -- $(ls -l ./配置交互智能提示.sh)
echo "1 ${1}"

## 命令替换的嵌套使用: 例如上面 foo 函数中的计算，还有如下面
set -- $(ls -l $(pwd)/配置交互智能提示.sh)
echo "1 ${1}"

## 命令替换捕获脚本输出
scriptRes=$(bash ./test-files/script.sh)
echo "scriptRes ${scriptRes}"

echo "who ${$(who)}" # a86198           console      Apr 10 21:36
who | grep 'a86198' # 要匹配的模式串
# 预定义变量 ? 存储返回码，即上一条命令的返回 
echo "? a86198登录了吗(0表示成功登录) $?" # 0

echo '成功echo'
echo "? $?" # 0