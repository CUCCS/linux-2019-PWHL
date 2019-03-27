# 动手实战Systemd
## 实验内容
- [Systemd 入门教程：命令篇 by 阮一峰的网络日志](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html)
- [Systemd 入门教程：实战篇 by 阮一峰的网络日志 ](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-part-two.html)
## 实验过程
### 入门教程命令篇
- [Systemd]( https://asciinema.org/a/yMq8ZD3WB7fIHRJzOPRu1f4v3
)
- [Systemd系统管理](https://asciinema.org/a/7g4QZQaavJFNvLqGESMoMvDGx
)
- [Unit](https://asciinema.org/a/Sjo55wIqfP1noTc7VLr4s1Ww6
)
- [Unit配置文件](https://asciinema.org/a/c0OI9VxNyfMyXGKKoPS2LaU2J
)
- [Target]( https://asciinema.org/a/KjhOZ2S7BgRVqX2DC3aBmkMPm
)
- [日志管理]( https://asciinema.org/a/cqH1TWzCHI6XoyxgBMFQCNIJl
)
### 入门教程实战篇
- [实战篇](https://asciinema.org/a/2SukZYUjfJKQaSoE7LhaNXPxV)
## 自查清单
- 如何添加一个用户并使其具备sudo执行程序的权限？
```bash
# 进入到root身份
su
# 添加用户
adduser 用户名
# 将用户添加到sudo用户组里
sudo usermod -a -G sudo 用户名
```
- 如何将一个用户添加到一个用户组？
```
sudo usermod -a -G usergroup username
```
- 如何查看当前系统的分区表和文件系统详细信息？
  - 分区表：```sudo fdisk -l```
  - 文件系统：```df -a```
- 如何实现开机自动挂载Virtualbox的共享目录分区？
  - 在```/etc/rc.local```文件中追加
  ```mount -t vboxsf sharing /mnt/share```
  - 重新启动虚拟机发现共享文件夹自动挂载成功
  ![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw3/image/img1.png)
- 基于LVM（逻辑分卷管理）的分区如何实现动态扩容和缩减容量？
  - 增容：```sudo lvextend --size +1G /dev/hello-vg/root``` 
  - 减容：```sudo lvreduce --size -1G /dev/hello-vg/root```
  ![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw3/image/origin.png)
  ![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw3/image/reduce.png)
- 如何通过systemd设置实现在网络连通时运行一个指定脚本，在网络断开时运行另一个脚本？
  - 更改网络连接配置文件
  ```
  ExecStart=script1
  ExecStop=script2
  ```
- 如何通过systemd设置实现一个脚本在任何情况下被杀死之后会立即重新启动？实现杀不死？
  - 将其配置文件的Service区块的Restart字段值设为always 

### 参考
- [linux-2019-jckling](https://github.com/CUCCS/linux-2019-jckling/blob/0x03/0x03/实验报告.md)
- [linux-2019-yang5220](https://github.com/CUCCS/linux-2019-yang5220/blob/lab3/lab3-linux/lab.md)