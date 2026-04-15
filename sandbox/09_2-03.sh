# p=$(pwd)/test-files/09_2-03.txt
p=$3

# 辅助工具，用于在每个小问操作后恢复现场
reset(){
    echo "abbb
abbb
Asasa
b
abbbc
b
c" > "$p"
}

bei=$1
zhu=$2
# Shell 中的变量无法 awk 中无法直接用，得通过 -v 传入
awk -v bei="$bei" -v zhu="$zhu" '{
    gsub(bei,zhu,$0)
    print
}' "$p" > tmp
mv tmp "$p"

# reset