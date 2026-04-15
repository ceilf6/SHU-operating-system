p=$(pwd)/test-files/09_2.txt

# 辅助工具，用于在每个小问操作后恢复现场
reset(){
    echo "asterix ;
20 tintin / haddock ;
20 tif / tondu ;
30 theodore poussin ;
40 spirit ;
30" > "$p"
}

# 1
# -i 直接修改原文件
# sed -i '/30/d' "$p"
# sed: 1: "/Users/a86198/Desktop/L ...": command a expects \ followed by text
# 是因为 macOS 要求 sed 声明一个备份地址
# 所以用 gsed 使用 Linux 的 GNU sed
gsed -i '/30/d' "$p"

reset

# 2
# awk '{
#     for (i=1;i<=NF;i++)
#         word=$i
#         for (chr in word) 这里不行！因为 awk 不像其他语言可以直接遍历字符串
#             if (chr ~ [a-z])
#                 toupper(chr)
# }' "$p"

awk '{
    for (i=1;i<=NF;i++){
        $i = toupper($i)
    }
    print
}' "$p" > tmp
# 别忘记 print 将内容传入管道化中，等下要传入中转文件tmp
mv tmp "$p"

# 或者一口气直接全转了，因为toupper支持
awk '{
    print toupper($0)
}' "$p" > tmp
mv tmp "$p"

reset

# 3
echo "=== 3"
awk '{
    for (i=1;i<=NF;i++){
        if ( $i ~ /^.s.*/)
            print $i
    }
}' "$p"

# 4
echo "
=== 4"
awk '{
    for (i=1;i<=NF;i++){
        if ( $i ~ /^[tsh].*/ )
            print $i
    }
}' "$p"

# 5
echo "
=== 5"
awk '{
    if ( !($0 ~ /[0-9]/) )
        print $0
}' "$p"

# 6
echo "
=== 6"
awk 'NR>=4 && NR<=6 {
    print substr($0,0,1)
}' "$p"