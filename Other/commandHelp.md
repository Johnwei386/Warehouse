## 一些实用命令
#### 使用ffmpeg压缩视频
```bash
# 将视频压缩指定大小
# -fs 10 : 表示文件大小最大值为10MB
ffmpeg  -i  Desktop/input.mp4  -fs 10MB  Desktop/output.mp4


# 设置视频的帧率为20fps
# -r 20：表示帧率设置为 20fps
ffmpeg  -i  Desktop/input.mp4  -r 20  Desktop/output.mp4


# 设置视频的码率
# -b:v :指定视频的码率
# -b:a : 指定音频的码率
# 1M：码率的值 1M 表示 1Mb/s
ffmpeg  -i  Desktop/input.mp4  -b:v 1M  Desktop/output.mp4


# 设置视频的分辨率
# -s 1920x1080表示分辨率为1920x1080
ffmpeg  -i  Desktop/input.mp4  -s 1920x1080  Desktop/output.mp4


# 可以结合上面的命令一起来使用
ffmpeg  -i  Desktop/input.mp4  -s 1920x1080  -b:v 1M  -r 20  Desktop/output.mp4

# 裁剪视频
ffmpeg -i 美丽心灵.mp4 -ss 00:00:00 -to 00:25:00 output/1.mp
```

#### 启动aria2c的rpc服务器
```bash
# 启动rpc服务器后可以将下载链接发送给rpc服务器进行下载.
aria2c --enable-rpc --rpc-allow-origin-all
```

#### linux配置加载动态链接库

```bash
# 1. 配置/etc/ld.so.conf文件, 此文件会加载/etc/ld.so.conf.d/目录下的所有配置文件,在此目录下添加配置文件即可
# 2. 执行ldconfig, 生效动态链接库配置

```

#### 使用lnav查看日志

```bash
# 下载安装lnav
sudo  apt  install  lnav  # 或者snap  install  lnav

# 查看默认系统日志
lnav

# 查看指定日志文件
lnav  日志文件路径

# 查看压缩的日志文件
lnav  -r  /path/to/***.gz

# lnav快捷键
# i => 切换到直方图视图
# p => 显示日志解析器结果

# 打开lnav后, 按 / 键后输入待查找字符串，进行日志搜索

# 快捷键
【?】         查看帮助信息
【g】         快速跳到文件的顶部
【G】         快速跳到文件的尾部
【i】         统计当前日志有多少数量的ERROR和WARNING，按【q】退出统计
【e】         快速跳到下一个ERROR行
【E】         快速跳到上一个ERROR行
【w】         快速跳到下一个WARNING行
【W】         快速跳到上一个WARNING行
【n】         快速跳到下一个搜索命中关键行
【N】         快速跳到上一个搜索命中关键行
【f】         快速跳到下一个文件
【F】         快速跳到上一个文件
【空格】       翻到下一页
【b】         翻到上一页
【向上箭头】   上一行翻页
【向下箭头】   下一行翻页
【p】         结构化日志行
```

查看大文件日志，Linux可使用klogg。

#### nginx生成和配置证书

生成证书：

```bash
# 1.创建服务器证书密钥文件 server.key：
openssl genrsa -des3 -out server.key 2048
# 输入密码，确认密码，自己随便定义，但是要记住，后面会用到。

# 2.创建服务器证书的申请文件 server.csr
openssl req -new -key server.key -out server.csr

# 输出内容为：
Enter pass phrase for root.key: ← 输入前面创建的密码
Country Name (2 letter code) [AU]:CN ← 国家代号，中国输入CN
State or Province Name (full name) [Some-State]:BeiJing ← 省的全名，拼音
Locality Name (eg, city) []:BeiJing ← 市的全名，拼音
Organization Name (eg, company) [Internet Widgits Pty Ltd]:MyCompany Corp. ← 公司英文名
Organizational Unit Name (eg, section) []: ← 可以不输入
Common Name (eg, YOUR name) []: ← 输入域名，如：iot.conet.com
Email Address []:admin@mycompany.com ← 电子邮箱，可随意填
Please enter the following ‘extra’ attributes
to be sent with your certificate request
A challenge password []: ← 可以不输入
An optional company name []: ← 可以不输入

# 3.备份一份服务器密钥文件
cp server.key server.key.org

# 4.去除文件口令
openssl rsa -in server.key.org -out server.key

# 5.生成证书文件server.crt
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
```

配置nginx

```bash
server {
    listen       443  ssl;
    listen       80;  #内网端口
    server_name  portal1;

    ssl_certificate        conf.d/key/server.crt;
    ssl_certificate_key    conf.d/key/server.key;

    ssl_session_cache    shared:SSL:1m;
    ssl_session_timeout  5m;

    ssl_ciphers  HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers  on;
    
    large_client_header_buffers 4 16k;
    client_body_buffer_size 128k;
    proxy_connect_timeout 600;
    proxy_read_timeout 600;
    proxy_send_timeout 600;
    proxy_buffer_size 64k;
    proxy_buffers   4 32k;
    proxy_busy_buffers_size 64k;
    proxy_temp_file_write_size 64k;

    proxy_set_header    Host                     $host:$server_port; #保留代理之前的host
    proxy_set_header    X-Real-IP                $remote_addr; #保留代理之前的真实客户端ip
    proxy_set_header    X-Forwarded-For          $proxy_add_x_forwarded_for;
    proxy_set_header    HTTP_X_FORWARDED_FOR     $remote_addr; #在多级代理的情况下，记录每次代理之前的客户端真实ip

    client_max_body_size 10m; #上传文件大小限制
    add_header X-Frame-Options SAMEORIGIN; #X-Frame-Options 低危漏洞

    proxy_intercept_errors on;
    recursive_error_pages on;
    server_tokens       off; #错误页面隐藏版本号
}
```



