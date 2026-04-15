# grep '^\(.*\):.*\1$' 'str1:str1'                   
# grep: str1:str1: No such file or directory

# 得通过标准输入通过管道传入进行测试，否则就当成文件名了
echo 'str1:str1' | grep '^\(.*\):.*\1' # str1:str1 # 假如没有输出就是匹配失败