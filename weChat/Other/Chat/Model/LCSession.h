//
//  LCSession.h
//  weChat
//
//  Created by Lc on 16/1/21.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, chatMessageType) {
    messageTypeText = 0,
    messageTypeImage = 1,
    messageTypeTypefile = 2,
    messageTypeVoice = 3,
    messageTypeMap = 4,
};

typedef NS_ENUM(NSInteger, chatSourcetype){
    sourcetypeTo = 0,
    sourcetypeFrom = 1,
};

typedef NS_ENUM(NSInteger, chatTargetType){
    chatTargetTypeSingle = 1,
    chatTargetTypeGroup = 2,
};


@interface LCSession : NSObject <NSCoding>
/**
 *  公共
 *
 */
// 消息类型
@property (assign, nonatomic) chatMessageType messageType;
// 来源类型
@property (assign, nonatomic) chatSourcetype sourceType;
// 讨论组为讨论组名, 个人 为用户名
@property (copy, nonatomic) NSString *listName;
// 讨论组为讨论组头像, 个人 为用户头像
@property (copy, nonatomic) NSString *headUrl;
// 用户名
@property (copy, nonatomic) NSString *userName;
// 用户头像
@property (copy, nonatomic) NSString *userHeadUrl;
// 是否发送
@property (assign, nonatomic, getter=isSend) BOOL send;
// 发送失败
@property (assign, nonatomic, getter=isFail) BOOL fail;
// 消息ID
@property (copy, nonatomic) NSString *chatId;
// 会话标志 1-个聊 2-群聊
@property (assign, nonatomic) NSInteger targetType;
// 当前消息收发时间
@property (assign, nonatomic) NSInteger messageTime;
// 消息索引
@property (assign, nonatomic) NSInteger messageIndex;
// 会话ID
@property (copy, nonatomic) NSString *sessionId;
// 目标客服ID
@property (copy, nonatomic) NSString *targetId;

@property (assign, nonatomic) CGFloat cellHeight;

/**
 *  文本
 *
 */
// 本地显示的消息内容
@property (copy, nonatomic) NSAttributedString *text;
// 发送给服务器的消息
@property (copy, nonatomic) NSString *fullText;

/**
 *  录音
 *
 */
// 录音时长
@property (assign, nonatomic) NSInteger duration;
// 录音路径
@property (copy, nonatomic) NSString *recordPath;
// 网络音频文件路径
@property (copy, nonatomic) NSString *recordURL;
// 未读语音
@property (assign, nonatomic, getter=isReadVoice) BOOL readVoice;
// 是否正在播放音频
@property (assign, nonatomic, getter=isVoicePlaying) BOOL voicePlaying;

/**
 *  图片
 *
 */
// 缩略图路径
@property (copy, nonatomic) NSString *imageThumbnailPath;
// 原图路径
@property (copy, nonatomic) NSString *imageOriginalPath;
// 图片名称
@property (copy, nonatomic) NSString *imageFileName;
// 缩略大小
@property (assign, nonatomic) CGSize thumbnailFrame;

/**
 *  地图 --- 尚未在项目中应用,暂且只考虑本地发送需要的字段
 *
 */
// 地图名称
@property (copy, nonatomic) NSString *mapViewFileName;
// 地图大小
@property (assign, nonatomic) CGSize mapViewFrame;
// 地图定位点名称
@property (copy, nonatomic) NSString *locationName;

@end
