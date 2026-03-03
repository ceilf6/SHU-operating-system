# LO03 – TD n°1 Linux（UTT）解析

> 这份讲义/“PPT”（实际是 1 页的 TD 练习单）是 UTT 的 **LO03 Linux** 课程 **TD1**。内容覆盖 Linux 命令行与 Shell 的基础：目录/文件操作、权限、重定向、引号与参数、条件/循环/case 脚本结构。  
> 参考文件：LO03 TD n°1 Linux（第 1 页） [oai_citation:0‡LO03-Linux-TD1_2026.pdf](sediment://file_0000000031a871fdb37371d8287ff7fd)

---

## 1. L’ARBORESCENCE（目录结构 / 树形结构）

### 题目要点

- “你现在在哪个目录？”：理解**当前工作目录**
- 创建 `$HOME/tp1`、`$HOME/tp1/rep`：练习创建目录
- 验证是否创建成功：练习查看目录
- 删除 `tp1` 和 `rep`：练习删除目录（含递归/空目录差别）
- 能否“一次创建 tp1/rep”：练习 `mkdir -p`

### 对应命令（典型解法）

- 查看当前目录：
  - `pwd`
- 创建目录：
  - `mkdir -p "$HOME/tp1"`
  - `mkdir -p "$HOME/tp1/rep"`
- 验证创建：
  - `ls -l "$HOME"`
  - `ls -l "$HOME/tp1"`
- 删除目录：
  - 删除空目录：`rmdir "$HOME/tp1/rep"`
  - 递归删除（危险命令，小心路径）：`rm -r "$HOME/tp1"`
- 一次性创建多级目录：
  - `mkdir -p "$HOME/tp1/rep"`

### 易错点

- `rmdir` 只能删**空目录**
- `rm -r` 会递归删除，路径写错会误删

---

## 2. LES DROITS（文件权限）

### 题目要点

- `touch` 创建文件后，默认权限是什么？
- 去掉所有者写权限
- 用**八进制**给“组”加修改+执行权限
- 用**符号法**给“其他人”加执行
- 给所有人读写权限

### 核心知识

- `ls -l` 权限示例：`-rw-r--r--`
  - 三组：owner / group / others
  - `r=4 w=2 x=1`（八进制叠加）

### 对应命令（示例流程）

1. 创建文件并查看权限：

- `touch a.txt`
- `ls -l a.txt`

2. 移除 owner 写权限：

- 符号法：`chmod u-w a.txt`

3. 给 group 添加写+执行（octal / 八进制）

- 先理解：只改 group 位可以用符号法更直观：`chmod g+wx a.txt`
- 若要求“八进制”，你需要知道原权限再计算（例如原来 `rw-r--r--` = 644）
  - 给 group 加 `wx`：group 从 `r--(4)` 变 `rwx(7)`，结果 674
  - `chmod 674 a.txt`
    > 八进制写法是“整体赋值”，需要你计算最终三位数。

4. 给 others 加执行（symbolic）

- `chmod o+x a.txt`

5. 所有人读写

- `chmod a+rw a.txt`  
  或 `chmod 666 a.txt`（不含执行）

### 易错点

- 八进制 `chmod 674` 是“覆盖式设定”，不是“增量”
- 给所有人 rw 不等于可删除：删除权限在**目录**上（见第 3 部分）

---

## 3. MANIPULATION DES FICHIERS（文件操作）

### 题目要点

- 拷贝 `.bashrc` 到 `$HOME/rep1`
- 把拷贝后的文件重命名为 `totomobile`
- 修改权限：让其他用户能读但不能“销毁/删除”
- 找两条命令查看文件
- 创建符号链接 `totocar -> totomobile`
- 查看符号链接
- 删除 `totocar`

### 对应命令（典型解法）

1. 创建目录并复制：

- `mkdir -p "$HOME/rep1"`
- `cp "$HOME/.bashrc" "$HOME/rep1/"`

2. 重命名：

- `mv "$HOME/rep1/.bashrc" "$HOME/rep1/totomobile"`

3. “别人能读但不能删除”怎么理解？

- **关键点：删除文件取决于“目录权限”**，不是文件本身
  - 其他用户能读：给文件 `o+r`
  - 不能删除：需要让目录对其他用户**没有写权限**（`o-w`），或者开启 sticky bit（更进阶）
- 最简单的练习式答案：
  - `chmod o+r "$HOME/rep1/totomobile"`
  - `chmod o-w "$HOME/rep1"`（限制别人对目录写入/删除）

4. 两种查看文件命令：

- `cat "$HOME/rep1/totomobile"`
- `less "$HOME/rep1/totomobile"`（或 `more` / `head`）

5. 创建符号链接：

- `ln -s "$HOME/rep1/totomobile" "$HOME/rep1/totocar"`

6. 查看链接：

- `ls -l "$HOME/rep1/totocar"`
- `readlink "$HOME/rep1/totocar"`

7. 删除链接：

- `rm "$HOME/rep1/totocar"`

### 易错点

- 删除权限在目录：目录可写则可删目录内文件（与文件本身权限不同）
- `ln -s 源 目标` 顺序不要写反

---

## 4. LES REDIRECTIONS（重定向 / 文本处理）

### 题目要点

- `totomobile` 有多少行/词/字符？
- 输出第 3 行、最后 2 行、2~5 行
- 统计 2~5 行之间有多少词
- 创建 `debut`（前三行）和 `fin`（后三行）
- 创建 `extremes` = debut + fin（拼接）

### 对应命令（典型解法）

1. 统计行/词/字符：

- 行：`wc -l totomobile`
- 词：`wc -w totomobile`
- 字符：`wc -c totomobile`

2. 第 3 行：

- `sed -n '3p' totomobile`  
  或：`head -n 3 totomobile | tail -n 1`

3. 最后 2 行：

- `tail -n 2 totomobile`

4. 2~5 行：

- `sed -n '2,5p' totomobile`  
  或：`head -n 5 totomobile | tail -n 4`

5. 统计 2~5 行的词数：

- `sed -n '2,5p' totomobile | wc -w`

6. 创建 debut / fin：

- `head -n 3 totomobile > debut`
- `tail -n 3 totomobile > fin`

7. extremes 拼接：

- `cat debut fin > extremes`

### 易错点

- `>` 覆盖写；`>>` 追加写
- `wc` 默认输出：行、词、字节（平台略有差异）

---

## 5. LES QUOTES（引号 / 参数 / 命令替换）

### 题目要点

- 写脚本输出：`Le prix du baril de brut se situe autour de 1$ US`
- 改为：价格来自脚本第一个参数
- 改为：价格来自文件 `tarif` 的内容
- 改为：tarif 文件名由参数传入

### 关键知识：引号与 `$`

- 单引号 `'...'`：不解析变量，不解析 `$`
- 双引号 `"..."`：解析变量，但更安全（保留空格）
- 输出字面量 `$`：要么用单引号，要么转义 `\$`

### 示例脚本思路（逐步升级）

- 固定输出：`echo 'Le prix ... 1$ US'`
- 参数输出：`prix="$1"`
- 文件内容：`prix="$(cat tarif)"`
- 参数指定文件：`prix="$(cat "$1")"`

---

## 6. LES STRUCTURES CONDITIONNELLES（条件判断）

### 题目要点

- 如果没给文件名参数：提示错误
- 如果参数文件不存在：提示错误

### 核心判断

- 参数为空：`[ -z "$1" ]`
- 文件存在：`[ -f "$1" ]`

### 典型结构

- `if ...; then ...; exit 1; fi`

---

## 7. LES STRUCTURES ITERATIVES（循环）

### 题目要点

- 显示多个国家的 tarif：每个国家一个文件 `<pays>.tarif`（如 `koweit.tarif`、`irak.tarif`）

### 常见解法

- 遍历匹配文件：
  - `for f in *.tarif; do ...; done`
- 取国家名：
  - `pays="${f%.tarif}"`

---

## 8. LE CASE（case 分支）

### 题目要点

- 假设 `date` 输出是美式：`Mon Mar 29 10:08:17 2004`
- 写脚本输出成：`Lundi 29 Mars 2004 à 10:05:17`
- 即使系统是法语也要做转换（因为格式不同）

### 关键思路

1. 用 `date` 获取原始字符串
2. 拆分出：
   - 星期缩写 Mon/Tue...
   - 月份缩写 Jan/Feb/Mar...
   - 日、时间、年
3. 用 `case` 把英文缩写映射成法文全称：
   - `Mon -> Lundi`
   - `Mar -> Mars`
4. 拼装输出格式：`<Jour> <JJ> <Mois> <AAAA> à <HH:MM:SS>`

### 易错点

- 月份 `Mar` 既可能表示 Tuesday（Tue）又可能表示 March（Mar），要根据字段位置判断
- 拆分字段时建议使用 `set -- $(date)` 或 `read` 分配变量（进阶）

---

## 总结：你学到什么

- Linux 基础命令：`pwd/ls/mkdir/rm/cp/mv/ln`
- 权限模型与 `chmod`：符号法 + 八进制
- 文本处理：`wc/head/tail/sed/cat`
- 重定向：`>` `>>` 管道 `|`
- Shell 脚本基础：参数 `$1`、命令替换 `$(...)`、条件 `if`、循环 `for`、分支 `case`

---

如果你想，我也可以把第 5~8 题写成一份“可直接运行”的 `td1.sh` 标准答案脚本（含注释）。

// ===

这个 PPT 是 UTT（Université de Technologie de Troyes）LO03 课程的 Linux 练习课（TD n°1）。

文件标题是：

LO03 – TD n°1 Linux ￼

也就是：
• 课程：LO03
• 类型：TD（Travaux Dirigés，习题课）
• 主题：Linux 基础操作练习

⸻

📚 这份 PPT 主要内容是什么？

它是一份 Linux 命令行基础操作练习单，包含 8 个部分：

⸻

1️⃣ L’ARBORESCENCE（文件系统结构）
• 当前目录在哪里
• 创建 / 删除目录
• 是否可以一次性创建多级目录

👉 主要练习：pwd mkdir rm ls

⸻

2️⃣ LES DROITS（文件权限）
• 创建文件
• 查看默认权限
• 修改权限（八进制 & 符号表示法）

👉 主要练习：touch chmod

⸻

3️⃣ MANIPULATION DES FICHIERS（文件操作）
• 复制文件
• 重命名
• 修改权限
• 创建符号链接
• 删除文件

👉 主要练习：cp mv ln -s rm cat

⸻

4️⃣ LES REDIRECTIONS（重定向）
• 统计行数 / 单词数 / 字符数
• 显示指定行
• 创建新文件
• 文件拼接

👉 主要练习：wc head tail sed cat > >>

⸻

5️⃣ LES QUOTES（Shell 引号 & 变量）
• 写 shell 脚本
• 使用参数
• 读取文件内容
• 变量替换

👉 主要练习：$1 $(cat file) echo

⸻

6️⃣ LES STRUCTURES CONDITIONNELLES（条件结构）
• 判断参数是否存在
• 判断文件是否存在

👉 主要练习：

if [ -z "$1" ]; then
if [ -f "$file" ]; then

⸻

7️⃣ LES STRUCTURES ITERATIVES（循环）
• 遍历多个国家的 tarif 文件

👉 主要练习：

for file in \*.tarif; do

⸻

8️⃣ LE CASE（case 结构）
• 格式化 date 命令输出
• 使用 case 转换月份英文 → 法文

👉 主要练习：

case $month in
Mon) echo "Lundi" ;;
esac

⸻

🧠 总结一句话

这是一份：

Linux 命令行 + Shell 脚本入门练习作业

内容涵盖：
• 文件系统
• 权限管理
• 文件操作
• 重定向
• 变量
• 条件判断
• 循环
• case 结构

属于 Linux 基础能力训练。

⸻

如果你愿意，我可以：
• 给你做一份 完整答案版
• 或者给你写一份 标准 shell 脚本示例
• 或者按考试难度给你做一个讲解版

你现在是要交作业还是准备考试？
