## SHELL脚本编程
### 任务一：用bash编写一个图片批处理脚本，实现以下功能
- 支持命令行参数方式使用不同功能
- 支持对指定目录下所有支持格式的图片文件进行批处理
- 支持以下常见图片批处理功能的单独使用或组合使用
  - 支持对jpeg格式图片进行图片质量压缩
  - 支持对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
  - 支持对图片批量添加自定义文本水印
  - 支持批量重命名（统一添加文件名前缀或后缀，不影响原始文件扩展名）
  - 支持将png/svg图片统一转换为jpg格式图片
#### 实验思路
- 使用getopt设置长参数和短参数
- 设置不同的FLAG判断参数是否被使用
- 根据flag进行命令参数的拼接、修改图片的类型和范围
- 用find命令找到指定目录下的文件
- 用for循环遍历指定目录下的文件集合对其类型进行更改
#### 内置帮助信息
```
Useage:bash image.sh  -d [directory] [option|option]
options:
  -d [directory]                支持对指定目录下所有支持格式的图片文件进行批处理,该脚本会创建一个输出目录
  -c                            将png / svg更改为jpg图像
  -r|--resize [width*height]    使用700x700或50％x50％等分辨率调整图像大小
  -q|--quality [number]         压缩jpg图像的质量 
  -w|watermark [watermark]      支持对图片批量添加自定义文本水印
  --prefix[prefix]              统一添加文件名前缀，不影响原始文件扩展名
  --postfix[postfix]            统一添加文件名后缀，不影响原始文件扩展名
```
#### 实验结果
- 支持对jpeg格式图片进行图片质量压

![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw4/%E5%AE%9E%E9%AA%8C%E5%9B%9B/image4/compressed_jpg.png)

- 支持对图片批量添加自定义文本水印

![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw4/%E5%AE%9E%E9%AA%8C%E5%9B%9B/image4/add_watermark.png)

- 支持批量重命名（统一添加文件名前缀或后缀，不影响原始文件扩展名）

![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw4/%E5%AE%9E%E9%AA%8C%E5%9B%9B/image4/add_prefix.png)
![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw4/%E5%AE%9E%E9%AA%8C%E5%9B%9B/image4/add_postfix.png)

- 支持将png/svg图片统一转换为jpg格式图片

![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw4/%E5%AE%9E%E9%AA%8C%E5%9B%9B/image4/png_to_jpg.png)

- 支持对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率

![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw4/%E5%AE%9E%E9%AA%8C%E5%9B%9B/image4/resize_image.png)

- 对图片名添加前缀后缀并调整大

![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw4/%E5%AE%9E%E9%AA%8C%E5%9B%9B/image4/add_prefix_postfix_resize.png)

### 任务二：用bash编写一个文本批处理脚本，对以下附件分别进行批量处理完成相应的数据统计任务：
- [2014世界杯运动员数据](http://sec.cuc.edu.cn/huangwei/course/LinuxSysAdmin/exp/chap0x04/worldcupplayerinfo.tsv)
  - 统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比
  - 统计不同场上位置的球员数量、百分比
  - 名字最长的球员是谁？名字最短的球员是谁？
  - 年龄最大的球员是谁？年龄最小的球员是谁？
#### 实验思路
- 统计不同年龄：先把运动员数据的年龄那一列的数据全部取出，然后用for循环遍历，用if语句分别判断不同年龄的运动员数量
- 统计不同位置球员：把位置一列的数据取出，赋值给Positions，for循环遍历Positions,定义关联数组，记录对应位置球员的数量
- 名字最长最短球员:将名字一列数据取出并计算长度，初始定义maxlength和minlength，用for循环和if语句，将它们分别和每个名字的长度比较
#### 实验结果
![image](C:/Users/asus/Desktop/image4/task2.png)
### 任务三：用bash编写一个文本批处理脚本，对以下附件分别进行批量处理完成相应的数据统计任务：
- [Web服务器访问日志](http://sec.cuc.edu.cn/huangwei/course/LinuxSysAdmin/exp/chap0x04/web_log.tsv.7z)
  - 统计访问来源主机TOP 100和分别对应出现的总次数
  - 统计访问来源主机TOP 100 IP和分别对应出现的总次数
  - 统计最频繁被访问的URL TOP 100
  - 统计不同响应状态码的出现次数和对应百分比
  - 分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数
  - 给定URL输出TOP 100访问来源主机
#### 实验结果
- 帮助信息
```bash
Web.sh supports the statistical task of 'The Athlete Data of 2014 World Cup'

Usage: bash Web.sh [OPTIONS] [PARAMETER] 

-h, --sourcehost          统计访问来源主机TOP 100和分别对应出现的总次数

-i, --sourceip            统计访问来源主机TOP 100 IP和分别对应出现的总次数

-u, --frenquencyurl        统计最频繁被访问的URL TOP 100

-c, --responcecode         统计不同响应状态码的出现次数和对应百分比

-e, --errorcode            分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数

-s, --specifiedurl[=URL]   给定URL输出TOP 100访问来源主机

--help                     请求帮助
```
- 统计访问来源主机TOP 100和分别对应出现的总次数（只填写部分结果）
```
   6530 edams.ksc.nasa.gov
   4846 piweba4y.prodigy.com
   4791 163.206.89.4
   4607 piweba5y.prodigy.com
   4416 piweba3y.prodigy.com
   3889 www-d1.proxy.aol.com
   3534 www-b2.proxy.aol.com
   3463 www-b3.proxy.aol.com
   3423 www-c5.proxy.aol.com
   3411 www-b5.proxy.aol.com
```
- 统计访问来源主机TOP 100 IP和分别对应出现的总次数
```
   4791 163.206.89.4
   1435 128.217.62.1
   1360 163.205.1.19
   1292 163.205.3.104
   1256 163.205.156.16
   1252 163.205.19.20
   1054 128.217.62.2
   1015 163.206.137.21
    949 128.159.122.110
    848 128.159.132.56
```
- 统计最频繁被访问的URL TOP 100
```
  97410 /images/NASA-logosmall.gif
  75337 /images/KSC-logosmall.gif
  67448 /images/MOSAIC-logosmall.gif
  67068 /images/USA-logosmall.gif
  66444 /images/WORLD-logosmall.gif
  62778 /images/ksclogo-medium.gif
  43687 /ksc.html
  37826 /history/apollo/images/apollo-logo1.gif
  35138 /images/launch-logo.gif
  30346 /
  27810 /images/ksclogosmall.gif

```
- 统计不同响应状态码的出现次数和对应百分比
```
Responce code:

code:200   times: 1398987    proportion 89.11%
code:304   times: 134146    proportion 8.54%
code:302   times: 26497    proportion 1.68%
code:404   times: 10055    proportion .64%
code:403   times: 171    proportion .01%
code:501   times: 27    proportion 0%
code:500   times: 3    proportion 0%
```
- 分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数
```
404 responce code:
   1337 404 /pub/winvn/readme.txt
   1185 404 /pub/winvn/release.txt
    683 404 /shuttle/missions/STS-69/mission-STS-69.html
    319 404 /images/nasa-logo.gif
    253 404 /shuttle/missions/sts-68/ksc-upclose.gif
    209 404 /elv/DELTA/uncons.htm
    200 404 /history/apollo/sa-1/sa-1-patch-small.gif
    166 404 /://spacelink.msfc.nasa.gov
    160 404 /images/crawlerway-logo.gif
    154 404 /history/apollo/a-001/a-001-patch-small.gif
403 responce code:
     32 403 /software/winvn/winvn.html/wvsmall.gif
     32 403 /software/winvn/winvn.html/winvn.gif
     32 403 /software/winvn/winvn.html/bluemarb.gif
     12 403 /ksc.html/images/ksclogo-medium.gif
     10 403 /ksc.html/images/WORLD-logosmall.gif
     10 403 /ksc.html/images/USA-logosmall.gif
     10 403 /ksc.html/images/NASA-logosmall.gif
     10 403 /ksc.html/images/MOSAIC-logosmall.gif
      5 403 /ksc.html/facts/about_ksc.html
      4 403 /ksc.html/shuttle/missions/missions.html
```
- 给定URL输出TOP 100访问来源主机
```
/ksc.html/shuttle/missions/missions.html
      1 scooter.pa-x.dec.com
      1 205.139.35.40
      1 163.135.192.101
      1 152.163.192.70
```
### 参考实验
- [snRNA](https://github.com/CUCCS/linux/tree/master/2017-1/snRNA/ex4)
- [FitzBC](https://github.com/CUCCS/linux/tree/master/2017-1/FitzBC/%E5%AE%9E%E9%AA%8C4)
- [TJY](https://github.com/CUCCS/linux/tree/master/2017-1/TJY/bash)