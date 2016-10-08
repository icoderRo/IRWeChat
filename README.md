# LCWeChat 提供思路 · iOS

<p align="left">
![enter image description here]
(https://img.shields.io/badge/platform-iOS%208.0%2B-ff69b5618733984.svg) 
</a>

在使用中有任何问题都可以提 issue, 欢迎加入QQ群:475814382

聊天页面的实现难点则在于：

- 消息种类繁多，对各种消息类型需要进行不同的布局 界面的流畅以及异步处理方面有大量的开发工作；
- 推、拉 音视频图像等消息；
- 群组离线消息, 通知类型离线消息, 消息重复等等

## 有需要的小伙伴,可以参考思路
* 自动布局 计算高度 发送文本、富文本、复制粘贴、文本换行、发送图片(PhotoKit 图片选择器 图片浏览器)、发送语音(录制音频mp3格式 播放音频、音频录制与播放的封装、60秒自动发送等) 、发送定位、拍照
* 高仿最新QQ侧滑效果
* 高仿朋友圈,文本收缩, 下拉刷新
* 封装设置界面
* FMDB 存储model 快捷存储

### demo演示
![image](https://github.com/icoderRo/LCWeChat/blob/master/Resource/LCWeChat.gif)

### 部分代码结构
![image](https://github.com/icoderRo/LCWeChat/blob/master/Resource/chatCell.png)

![image](https://github.com/icoderRo/LCWeChat/blob/master/Resource/mainController.png)


