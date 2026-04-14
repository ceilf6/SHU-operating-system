# 2
solve2(){
    local -i cur=1
    while IFS= read -r curLine || [ -n "$curLine" ]
    # 后面 || 或的逻辑是为了文件最后一行很可能没有以换行符结尾导致没有read
    do
        echo "第${cur}行 $curLine"
        ((cur++))
    done < "$1"
}
solve2 $(pwd)/test-files/FichierNote.txt

# 3
solve3(){
    local -i cntD=0
    local -i cntF=0
    for i in $(ls "./")
    do
        if [ -d "$(pwd)/$i" ]
        # 路径外面别忘记 " "
        then
            ((cntD++))
        elif [ -f "$(pwd)/$i" ]
        # 参考答案直接全补的，这不好因为除了目录还有链接文件等等也不是普通文件
        then
            cntF=$((cntF+1))
        fi
    done
    echo "普通文件数量 $cntF"
    echo "目录数量 $cntD"
}
solve3

# 6
solve6(){
    local -i cnt=0
    while read curLine || [ -n "$curLine" ]
    do
        # 指针不会动，只会读取第一行
        # read cur < $(pwd)/test-files/FichierNote.txt
        set $curLine
        curGrade=$3
        if [ "$curGrade" -ge 10 ]
        then
            ((cnt++))
        fi
    done < $(pwd)/test-files/FichierNote.txt
    echo "分数大于10的记录数量 $cnt"
}
solve6

# 7
## 参考答案直接拿到是 date 也就是当前的时间，而不是文件的修改时间
solve7(){
    # for file in "$(pwd)"/test-files/*
    # do
    #     set -- $(ls -l "$file")
    #     echo $#
    #     echo $*
    # done

    # ls -l "$(pwd)"/test-files/* | while read curLine
    # do
    #     set -- $curLine
    #     echo $#
    #     echo $*
    # done

    for file in "$(pwd)"/test-files/*
    do
        # 如果不是普通文件就跳过，因为会损坏文件
        [ -f "$file" ] || continue
    
        set -- $(ls -l "$file")
        lastTime="$6 $7 $8"
        
        tmpFile="/tmp/fichtemp.$$"
        echo $lastTime > "$tmpFile"
        cat "$file" >> "$tmpFile"
        mv "$tmpFile" "$file"
        rm "$tmpFile"
    done
}
solve7

# 8
solve8(){
    preFilePath=$1
    tmpFile="/tmp/fichtemp.$$"
    while read curLine || [ -n "$curLine" ]
    do
        curTmp="/tmp/fichtemp2.$$"
        cat "$tmpFile" > "$curTmp"
        echo "$curLine" > "$tmpFile"
        cat "$curTmp" >> "$tmpFile"
        rm "$curTmp"
    done < "$preFilePath"
    mv "$tmpFile" "${preFilePath}-reverse"
}
solve8 $(pwd)/test-files/esN

# 9
## 启动之后移到中转区 .poubelle 等到后面触发删除
## 老师答案对目录和普通文件的区分处理得不是很好，我觉得得用递归处理
## 如果不要求目录结构的话直接 cp -a 即可
solve9(){
    dPath='.poubelle'
    if [ ! -d "$dPath" ]
    then
        mkdir "$dPath"
    fi

    # find 查找起点 条件 动作
    # 触发删除操作
    find $dPath -mtime +30 -exec rm -rf {} \; # 需要转义 \ 才会交给 find

    for input in "$@"
    do
        if [ -f "$input" ]
        then
            mv "$input" "$dPath/$(basename "$input")"
            solve7 "$dPath/$(basename "$input")"
        elif [ -d "$input" ]
        then
            mkdir "$dPath/$(basename "$input")"
            solve9 "$input"/* # 递归调用
            rmdir "$input"
        fi
    done
}

# ===

backup_recursively(){
    local input="$1"
    local targetPath="$2"
    local child

    if [ -L "$input" ] || [ -f "$input" ]
    then
        cp -P "$input" "$targetPath" || return 1
        rm -f "$input"
    elif [ -d "$input" ]
    then
        mkdir -p "$targetPath" || return 1
        for child in "$input"/* "$input"/.[!.]* "$input"/..?*
        do
            [ -e "$child" ] || continue
            backup_recursively "$child" "$targetPath/$(basename "$child")" || return 1
        done
        rmdir "$input"
    fi
}

solve9_2(){
    local dPath='.poubelle'
    local input
    local dateStr
    local backupName
    local backupPath
    local suffix

    mkdir -p "$dPath"

    # 只清理垃圾桶里面的顶层备份，避免把 .poubelle 自己删掉
    find "$dPath" -mindepth 1 -maxdepth 1 -mtime +30 -exec rm -rf {} +

    for input in "$@"
    do
        if [ ! -e "$input" ] && [ ! -L "$input" ]
        then
            echo "目标不存在: $input"
            continue
        fi

        case "$input" in
            .|"$dPath"|./"$dPath"|"$dPath"/*|./"$dPath"/*)
                echo "拒绝处理危险目标: $input"
                continue
                ;;
        esac

        dateStr="$(date '+%Y%m%d-%H%M%S')"
        backupName="$(basename "$input")_${dateStr}"
        backupPath="$dPath/$backupName"
        suffix=0
        while [ -e "$backupPath" ]
        do
            suffix=$((suffix+1))
            backupPath="$dPath/${backupName}_$suffix"
        done

        backup_recursively "$input" "$backupPath"
    done
}
