## WEB服务器
### 实验步骤
#### 安装过程
##### 安装verynginx
- 根据[文档](https://github.com/alexazhou/VeryNginx/blob/master/readme_zh.md)安装verynginx
```bash
git clone https://github.com/alexazhou/VeryNginx.git
cd VeryNginx
python install.py install
```
- 根据报错安装依赖
```
sudo apt install libssl1.0-dev
sudo apt install lua-rex-pcre
sudo apt install libpcre3 libpcre3-dev
sudo apt-get install --reinstall zlibc zlib1g zlib1g-dev
sudo apt install make
sudo apt install gcc
问题：
failed to run command: sh ./configure --prefix=/opt/verynginx/openresty/nginx \...
# 解决
sudo apt-get install --reinstall zlibc zlib1g zlib1g-dev
```
- 在Windows主机的hosts文件中添加一条对应的DNS解析，访问verynginx
![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/visit_verynginx.png)
##### 安装nginx
```bash
#安装nginx
sudo apt install nginx
# 安装mysql
sudo apt install mysql-server
# 安装mysql
sudo apt install php-fpm php-mysql
# 修改nginx配置文件，能够使用php解析
sudo vim /etc/nginx/sites-enabled/default
location ~ \.php$ 
{
         include snippets/fastcgi-php.conf;
         fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
}

# 重新启动nginx
sudo systemctl restart nginx
```
##### 安装wordpress
- [参考](https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-lemp-on-ubuntu-18-04#step-1-%E2%80%94-creating-a-mysql-database-and-user-for-wordpress)
```bash
# 将安装包下载到/var/www/html路径下
sudo wget https://wordpress.org/wordpress-4.7.zip
# 解压文件
sudo apt install unzip
unzip wordpress-4.7.zip
```
- wordpress的使用需要数据库的支持，在mysql中为wordpress新建一个数据库
```bash
# 安装mysql
sudo apt install mysql-server
# 新建一个wordpress数据库
CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
# 新建一个用户，并且刷新
GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
EXIT;
```
- 安装PHP扩展
```bash
sudo apt update
sudo apt install php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip
# 重启php-fpm
sudo systemctl restart php7.2-fpm
```
- 编辑配置文件```sudo vim /etc/nginx/sites-enabled/default```
```
server {
        listen 80;
        server_name  wp.sec.cuc.edu.cn;

         root /var/www/html;
        index index.html setup.php index.htm index.php index.nginx-debian.html;

         location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;

          }

             #配置php-fpm
        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
        }


}
```
- 重启nginx，使修改生效```systemctl restart nginx```
- 访问wordpress
![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/wordpress.png)
- 给wordpress配置ssl证书
```

    server {
        listen 443;
        server_name  wp.sec.cuc.edu.cn;
        include /opt/verynginx/verynginx/nginx_conf/in_server_block.conf;

       # location = / {
        #    root   html;
         #   index  index.html index.htm;
        #}
        #ssl config
         root /var/www/html;
        index index.html index.htm index.php index.nginx-debian.html;

        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;
        }
        ssl on;
        ssl_certificate /etc/ssl/certs/wordpress-selfsigned.crt;
        ssl_certificate_key /etc/ssl/private/wordpress-selfsigned.key;
      }
```
- 访问wordpress
![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/wordpress1.png)


##### 安装DVWA
[参考](https://kifarunix.com/how-to-setup-damn-vulnerable-web-app-lab-on-ubuntu-18-04-server/)
- 安装过程
```bash
# 下载dvwa，并移动到指定文件夹下
sudo git clone https://github.com/ethicalhack3r/DVWA /tmp/DVWA
sudo mv /tmp/DVWA /var/www/html

# 在mysql为DVWA新建一个用户, 修改DVWA中的配置,用于连接mysql数据库
 GRANT ALL ON dvwa.* TO 'dvwauser'@'localhost' IDENTIFIED BY 'p@ssw0rd';
 FLUSH PRIVILEGES;
 EXIT;
 
 # 重启mysql
 sudo systemctl restart mysql

# 打开配置文件
sudo vim /var/www/html/DVWA/config/config.inc.php
# 修改配置文件为
$_DVWA = array();
$_DVWA[ 'db_server' ]   = '127.0.0.1';
$_DVWA[ 'db_database' ] = 'dvwa';
$_DVWA[ 'db_user' ]     = 'dvwauser';
$_DVWA[ 'db_password' ] = 'p@ssw0rd';

# 修改PHP配置
sudo vim /etc/php/7.2/fpm/php.ini

allow_url_include = on
allow_url_fopen = on
safe_mode = off
magic_quotes_gpc = off
display_errors = off

# 重启php-fpm
sudo systemctl restart php7.2-fpm

#设置DVWA访问权限
sudo chown -R www-data.www-data /var/www/html/DVWA
```
- 更改配置文件，添加相应的监听块
```
sudo vim /etc/nginx/sites-enabled/default
 server {
        listen 5566;
        server_name  dvwa.sec.cuc.edu.cn;

         root /var/www/html/DVWA;
        index index.html setup.php index.htm index.php index.nginx-debian.html;

         location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;

          }

             #配置php-fpm
        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
        }
```
- 重启nginx
```sudo systemctl restart nginx```
- 访问dvwa
![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/dvwa2.png)
### 在verynginx上设置代理
![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/dvwa_pro.png)
![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/wordpress_pro.png)
![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/proxypass.png)
### 安全加固要求
- 使用IP地址方式均无法访问上述任意站点，并向访客展示自定义的友好错误提示信息页面-1
  - 设置Request Matcher 
  ![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/not_allowed_IP0.png)
  - 设置Response
  ![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/not_allowed_IP1.png)
  - 设置Filter
  
  ![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/not_allowed_IP2.png)
  - 结果
  ![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/not_allowed_IP3.png)
- Damn Vulnerable Web Application (DVWA)只允许白名单上的访客来源IP，其他来源的IP访问均向访客展示自定义的友好错误提示信息页面-2
  - 设置Request Matcher
  ![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/dvwa_white0.png)
  - 设置Response
  ![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/dvwa_white3.png)
  - 设置Filter
  ![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/dvwa_white2.png)
  - 结果
  ![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/dvwa_white1.png)
- 在不升级Wordpress版本的情况下，通过定制VeryNginx的访问控制策略规则，热修复WordPress < 4.7.1 - Username Enumeration
   - 设置Request Matcher
  ![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/wp_accept.png)
  - 设置Filter
  ![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/wp_filter.png)
- 通过配置VeryNginx的Filter规则实现对Damn Vulnerable Web Application (DVWA)的SQL注入实验在低安全等级条件下进行防护
  - 设置Request Matcher
  ![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/sql_inject.png)
  - 设置Response
  ![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/sql_response.png)
  - 设置Filter
  
  ![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/sql_filter.png)
  - 结果
  ![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/sql_result.png)
- VeryNginx的Web管理页面仅允许白名单上的访客来源IP，其他来源的IP访问均向访客展示自定义的友好错误提示信息页面-3
  - 设置Request Matcher
  ![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/verynginx_request.png)
  - 设置Response
  ![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/verynginx_refuse.png)
  - 设置Filter
  ![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/verynginx_filter.png)
  - 结果
  ![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/verynginx_result.png)
- 通过定制VeryNginx的访问控制策略规则实现
  - 限制DVWA站点的单IP访问速率为每秒请求数 < 50
  - 限制Wordpress站点的单IP访问速率为每秒请求数 < 20
  - 超过访问频率限制的请求直接返回自定义错误提示信息页面-4
    - 设置Response 
    
  ![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/Response.png)
    - 设置Frequency Limit
  ![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/fre_limit.png)
  - 禁止curl访问
    - 设置Request Matcher
   ![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/curl1.png)
    - 设置Filter
    
   ![image](https://raw.githubusercontent.com/CUCCS/linux-2019-PWHL/hw5/实验五/image5/curl2.png)
### 问题
- 在不升级Wordpress版本的情况下，通过定制VeryNginx的访问控制策略规则，热修复WordPress < 4.7.1 - Username Enumeration（漏洞复现失败）
- 做实验到后面的时候把虚拟机搞坏了，启动不了，目前还没有找到办法解决，所以配置文件就先不提交
### 参考实验
- [linux-2019-jackcily](https://github.com/CUCCS/linux-2019-jackcily/tree/job5)
- [TJY](https://github.com/CUCCS/linux/tree/master/2017-1/TJY/webserver)
- [snRNA](https://github.com/CUCCS/linux/tree/master/2017-1/snRNA/ex5)