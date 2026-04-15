# LO03  
# 第3次 Linux 习题课（TD n°3）

## 1. `which` 命令

当一个可执行文件被启动时，Linux 系统会优先在**当前目录**中查找这个可执行文件；如果没有找到，Linux 就会在变量 `$PATH` 所列出的目录中继续查找。  

示例：

```bash
root@serveur# echo $PATH
/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
```

下面给出了 `which` 命令的 man 手册说明。  

请编写一个脚本，用来**模拟 `which` 命令的行为**。

---

## 2. 回文单词？

编写一个 Shell 脚本，用于检查某个单词是否为**回文**。  
该单词将作为脚本参数传入。  

示例：`bob`、`serres`、`rotor`、`radar`、`laval`

---

## 3. 文件中的回文词

编写一个 Shell 脚本，用于找出某个文件中包含的**所有回文词**。  
该文件将作为脚本参数传入。

---

## 4. `tree` 命令

编写一个 `tree` 命令（该命令在 Linux 下本身就存在），用于显示某个目录的**树状结构**，目录名由参数传入。  

如果命令没有参数，则默认显示**当前目录**。  

显示格式要求如下：

- 每个文件名前加上 `+--`
- 每个目录名前加上 `\--`

示例：

```text
tree /home/chezmoi
+-- fichier1
+-- fichier2
\-- rep1
    +-- fichier1_rep1
    +-- fichier2_rep1
    \-- rep1_1
        +-- fichier1_rep1_1
        +-- fichier2_rep1_1
\-- rep2
    +-- fichier1_rep2
    +-- fichier2_rep2
```

建议：定义一个函数，并对其进行**递归调用**。

---

## 5. 单词列表

给定如下文件：

```text
This is the first document
The second document is here
This document is the third
Here is another document
```

编写一个脚本，列出文本中的每一个单词。

脚本输出示例：

```text
This is the first document second third
another
```

---

## 6. 字典

在你的 Linux 系统中，目录 `/usr/share/dict/` 下有一个名为 `words` 的文件，  
其中包含了词典中的所有单词，**每行一个单词**，并且按照**字母顺序排序**。  

例如调用方式：

```bash
./dico.sh 5 i2 u4
```

这表示要查找一个 **5 个字母** 的单词，且：

- 第 2 个字母是 `i`
- 第 4 个字母是 `u`

请编写一个名为 `dico` 的脚本，使其能够在 `words` 文件中找出符合传入条件的单词。  

例如：`./dico.sh 5 i2 u4`

表示查找一个 5 字母单词，其中第 2 个字母是 `i`，第 4 个字母是 `u`。  

脚本可能返回如下结果：

```text
linux
digue
lieux
minus
sinus
virus
```

脚本的调用形式始终如下：

1. 第一个参数表示**单词长度**（在本例中是 `5`）
2. 后续若干参数表示“**某个字母及其位置**”

在示例中给出了两个字母位置条件：`i2` 和 `u4`，  
但实际使用时，可能会有更多这样的条件。
