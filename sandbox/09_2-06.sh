p=$(pwd)/test-files/09_2-06.txt

reset(){
    echo "Paul:Dupont :0144567799 :dupont@club.fr
Julie:Dalbanot:0469857468:julie@wanadoo.fr
George:Martin :0569874587:martin@free.fr" > "$p"
}

reset

# 1-1
awk '{
    split($0,arr,":") # 其实直接 $2 ":" $1 即可
    # newStr="$arr[1]$arr[0]$arr[2]$arr[3]"
    # awk 的字符串拼接是直接空格连接变量
    # 并且下标是从 1 开始
    newStr= arr[2] ":" arr[1] ":" arr[3] ":" arr[4]
    print newStr # 给 tmp
}' "$p" >> tmp
mv tmp "$p"

# reset

# 1-2
awk '{
    gsub(":","|",$0)
    print
}' "$p" > tmp
mv tmp "$p"

reset

# 2
## 注意要声明 IFS 是 : 即用 -F 或 BEGIN{FS=":"} 。否则格式会乱
awk -F: '{
    new= $1 " " $2 "\n" "Tel : " $3 "\n" "Email : " $4
    print new
}' "$p" > tmp
mv tmp "$p"

# reset