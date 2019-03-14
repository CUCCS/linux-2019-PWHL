### 实验环境
- Ubuntu 18.04 Server 64bit
- Virtualbox
- win10
- 网络环境
  - NAT
  - host-only(192.168.56.102)
### 实验问题
- 如何配置无人值守安装iso并在Virtualbox中完成自动化安装。
- Virtualbox安装完Ubuntu之后新添加的网卡如何实现系统开机自动启用和自动获取IP？
- 如何使用sftp在虚拟机和宿主机之间传输文件？
### 实验过程
- 使用镜像ubuntu18.04-server安装虚拟机，并为其添加一块host-only网卡，设置网卡ip为192.168.56.102
- 使用命令```sudo vim /etc/netplan/01-netcfg.yaml```打开配置文件，添加如下内容
![image](https://github.com/CUCCS/linux-2019-PWHL/blob/hw1/img1/img1.png)
- 使用```sudo netplan apply```命令添加的内容生效
![image](https://github.com/CUCCS/linux-2019-PWHL/blob/hw1/img1/img2.png)
- 配置宿主机putty ssh使其能够免密登录虚拟机
  - 使用命令```sudo apt install ssh```安装ssh，首先使用用户名和密码登录到虚拟机
  - 在宿主机中使用puttygen生成一对公私钥，下载私钥，将公钥毛寸到虚拟机的authorized_keys文件中
  - 使用命令```vim ~/.ssh/authorized_keys```打开文件,将公钥写入文件
  ![image](https://github.com/CUCCS/linux-2019-PWHL/blob/hw1/img1/img5.png)
  - 在putty中添加私钥，可免密登录
  ![image](https://github.com/CUCCS/linux-2019-PWHL/blob/hw1/img1/img6.png)

- 制作iso镜像
```
#首先下载镜像到虚拟机
wget http://sec.cuc.edu.cn/ftp/iso/ubuntu-18.04.1-server-amd64.iso

# 在当前用户目录下创建一个用于挂载iso镜像文件的目录
mkdir loopdir

# 挂载iso镜像文件到该目录
mount -o loop ubuntu-18.04.1-server-amd64.iso loopdir

# 创建一个工作目录用于克隆光盘内容
mkdir cd
 
# 同步光盘内容到目标工作目录
# 一定要注意loopdir后的这个/，cd后面不能有/
rsync -av loopdir/ cd

# 卸载iso镜像
umount loopdir

# 进入目标工作目录
cd cd/

# 编辑Ubuntu安装引导界面增加一个新菜单项入口
vim isolinux/txt.cfg
```
- 添加以下内容到该文件然后保存退出
```
label autoinstall
  menu label ^Auto Install Ubuntu Server
  kernel /install/vmlinuz
  append  file=/cdrom/preseed/ubuntu-server-autoinstall.seed debian-installer/locale=en_US console-setup/layoutcode=us keyboard-configuration/layoutcode=us console-setup/ask_detect=false localechooser/translation/warn-light=true localechooser/translation/warn-severe=true initrd=/install/initrd.gz root=/dev/ram rw quiet
```
![image](https://github.com/CUCCS/linux-2019-PWHL/blob/hw1/img1/img3.png)
- 将文件```ubuntu-server-autoinstall.seed```下载到目录``` ~/cd/preseed```目录中
- 编辑```isolinux/isolinux.cfg```增加内容```timeout 10```
- 用命令```find . -type f -print0 | xargs -0 md5sum > /tmp/md5sum.txt```重新生成md5sum.txt,移动到指定位置```sudo mv /tmp/md5sum.txt md5sum.txt```
- 安装相应软件包
```
apt-cache search mkisofs
sudo apt install genisoimage
```

- 建立脚本并运行，生成无人值守镜像
```
#打开脚本
sudo vim gen_iso.sh

#添加以下内容
IMAGE=custom.iso
BUILD=~/cd/

mkisofs -r -V "Custom Ubuntu Install CD" \
            -cache-inodes \
            -J -l -b isolinux/isolinux.bin \
            -c isolinux/boot.cat -no-emul-boot \
            -boot-load-size 4 -boot-info-table \
            -o $IMAGE $BUILD

#执行shell脚本，刻录镜像
sudo bash gen_iso.sh
```
![image](https://github.com/CUCCS/linux-2019-PWHL/blob/hw1/img1/img8.png)
- 下载镜像
```
#使用psftp.exe下载

  #登录
  psftp -l 用户名 -pw 密码  用户名@IP
  #下载 
  get /home/用户名/cd/文件名
```
[录频](https://www.bilibili.com/video/av46266570
)
### 对比文件差异，使用[文件对比工具](http://mergely.com/editor)
- 左边为官方文件，右边为定制文件
  - 选择支持的语言，跳过安装时对语言的询问
  ![image](https://github.com/CUCCS/linux-2019-PWHL/blob/hw1/img1/img9.png)
  - 修改链路检测超时时间和等待DHCP服务器超时时间，设置手动配置网络
  ![image](https://github.com/CUCCS/linux-2019-PWHL/blob/hw1/img1/img10.png)
  - 修改静态IP，网关IP，域名服务器IP
  ![image](https://github.com/CUCCS/linux-2019-PWHL/blob/hw1/img1/img11.png)
  - 设置默认主机名和域名，且强制主机名为isc-vm-host
  ![image](https://github.com/CUCCS/linux-2019-PWHL/blob/hw1/img1/img12.png)
  - 设置用户名为cuc,密码为```sec.cuc.edu.cn```
  ![image](https://github.com/CUCCS/linux-2019-PWHL/blob/hw1/img1/img13.png)
  - 设置时区为上海，关闭时钟校正
  ![image](https://github.com/CUCCS/linux-2019-PWHL/blob/hw1/img1/img14.png)
  - 自动分配最大可用分区
  ![image](https://github.com/CUCCS/linux-2019-PWHL/blob/hw1/img1/img15.png)
  - 使用lvm方法对磁盘进行分区，设置最大卷组。使用预定义分区分配方法
  ![image](https://github.com/CUCCS/linux-2019-PWHL/blob/hw1/img1/img16.png)
  - 不使用网络镜像
  ![image](https://github.com/CUCCS/linux-2019-PWHL/blob/hw1/img1/img17.png)
  - 安装server版的包，安装openssh，不启用更新。自动进行安全更新
  ![image](https://github.com/CUCCS/linux-2019-PWHL/blob/hw1/img1/img18.png)
  ![image](https://github.com/CUCCS/linux-2019-PWHL/blob/hw1/img1/img19.png)
### 实验遇到的问题
- 按照实验步骤依次操作后发现会报以下错误
![image](https://github.com/CUCCS/linux-2019-PWHL/blob/hw1/img1/img_q.png)
- 在将两个文件```ubuntu-server-autoinstall.seed```和```preseed.cfg```进行对比时，把```ubuntu-server-autoinstall.seed```下载到本地是一个html文件，然后想到前面的步骤使用wget+链接的方法将文件下载到虚拟机时，可能下载到的是一个html文件，所以在宿主机将```ubuntu-server-autoinstall.seed```文件下载后，该文件后缀名为txt，然后再改为.seed文件，再将其用psftp传入虚拟机，然后生成的iso文件就没有问题
![image](https://github.com/CUCCS/linux-2019-PWHL/blob/hw1/img1/img20.png)

- 参考
  - [Linux基础实验](https://github.com/c4pr1c3/LinuxSysAdmin/blob/master/chap0x01.exp.md)
  - [linux-2019-jackcily](https://github.com/CUCCS/linux-2019-jackcily/blob/job1/%E5%AE%9E%E9%AA%8C%E4%B8%80.md)
  - [linux-2019-LeLeF](https://github.com/CUCCS/linux-2019-LeLeF/blob/chap0x01/chap0x01VirtualBox%20%E6%97%A0%E4%BA%BA%E5%80%BC%E5%AE%88%E5%AE%89%E8%A3%85Unbuntu%E7%B3%BB%E7%BB%9F%E5%AE%9E%E9%AA%8C/chap0x01%20VirtualBox%20%E6%97%A0%E4%BA%BA%E5%80%BC%E5%AE%88%E5%AE%89%E8%A3%85Unbuntu%E7%B3%BB%E7%BB%9F%E5%AE%9E%E9%AA%8C.md)
  - [linux-2019-jckling](https://github.com/CUCCS/linux-2019-jckling/tree/0x01/0x01)
