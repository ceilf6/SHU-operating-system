cd test-files/

echo "=== pre"
ls -l

echo "
=== aft"
touch original.txt                      # 创建文件 "original.txt"
echo "test" > original.txt
ln -s original.txt lien_sym.txt         # 创建符号链接 # 符号链接会因为被引用路径文件丢失而报错
ln original.txt lien_phys.txt           # 创建硬链接 # 但是由于文件数据仍然有，所以硬链接作为文件入口仍然有用
rm original.txt                         # 删除原始文件
ls -l                                   # 观察结果