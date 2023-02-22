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

