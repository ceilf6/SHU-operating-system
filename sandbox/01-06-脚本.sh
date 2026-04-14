#!/bin/bash

echo "=== bash"
bash ./01-03-修改命令提示符.sh

echo "=== bash <"
bash <./01-03-修改命令提示符.sh

echo "=== chmod +x ; "
chmod +x ./01-03-修改命令提示符.sh ; ./01-03-修改命令提示符.sh

echo "=== path"
bash ./test-files/script.sh

echo "=== 默认执行脚本会开一个新进程
如果想要影响当前进程的话可以用 source 或 . 因为不会开子进程"
. ./01-03-修改命令提示符.sh
source ./01-03-修改命令提示符.sh
# 那么当前层也注意不要套 . ./01-06-脚本.sh