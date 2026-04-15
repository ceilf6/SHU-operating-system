# https://github.com/ceilf6/Lab/commit/99c78093416570a4184ecc3b2799164a28ffbb28

dfs(){
    # 要求输入缩进数 以及 当前所在目录

    # 先存储，防止被覆盖污染
    local depth="$1"
    local dir="$2"

    local preStr=""
    for ((i=0;i<depth;i++))
    do
        preStr="    $preStr"
    done

    # 防止污染全局
    local fileName
    local curStr
    for file in "$dir"/*
    # 直接从当前 目录/* 读取所有子目录
    do
        [ -e "$file" ] || continue # 空目录保护

        fileName=$(basename "$file")
        # 通过 basename 拿到文件名

        if [ -d "$file" ]
        then
            curStr="$preStr\-- $fileName"
            # 注意别忘记 "" 否则会空白折叠
            echo "$curStr"
            dfs $(($depth+1)) "$file"
        else
            curStr="$preStr+-- $fileName"
            echo "$curStr"
        fi
    done
}

dfs 0 "$(pwd)"