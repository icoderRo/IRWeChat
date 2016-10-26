//
//  LCBaseChatCell.m
//  weChat
//
//  Created by Lc on 16/3/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCBaseChatCell.h"
#import "LCSession.h"
#import "LCShapedImageView.h"
#import "DALabeledCircularProgressView.h"
#define progressViewWH  50

@interface LCBaseChatCell ()
// label上展示图片,不需放在头文件供外界设置
@property (nonatomic, weak) LCShapedImageView *chatImageView;
@property (weak, nonatomic) DALabeledCircularProgressView *progressView;
@property (nonatomic, weak) UILabel *mapViewMaskLabel;
@end

@implementation LCBaseChatCell
#pragma mark - lazy
- (UIImageView *)backgroundMsgView
{
    if (!_backgroundMsgView) {
        UIImageView *backgroundMsgView = [[UIImageView alloc] init];
        _backgroundMsgView = backgroundMsgView;
        [self.contentView addSubview:_backgroundMsgView];
    }
    
    return _backgroundMsgView;
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        UIImageView *backgroundMsgView = [[UIImageView alloc] init];
        _backgroundImageView = backgroundMsgView;
        [self.contentView addSubview:_backgroundImageView];
    }
    
    return _backgroundImageView;
}

- (UIImageView *)backgroundVoiceView
{
    if (!_backgroundVoiceView) {
        UIImageView *backgroundMsgView = [[UIImageView alloc] init];
        _backgroundVoiceView = backgroundMsgView;
        [self.contentView addSubview:_backgroundVoiceView];
    }
    
    return _backgroundVoiceView;
}

- (UILabel *)mapViewMaskLabel
{
    if (!_mapViewMaskLabel) {
        UILabel *mlabel = [[UILabel alloc] init];
        mlabel.textAlignment = NSTextAlignmentCenter;
        mlabel.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        mlabel.font = [UIFont systemFontOfSize:11];
        mlabel.textColor = [UIColor whiteColor];
        _mapViewMaskLabel = mlabel;
        [self.chatImageView addSubview:_mapViewMaskLabel];
    }
    
    return _mapViewMaskLabel;
}
- (DALabeledCircularProgressView *)progressView
{
    if (!_progressView) {
        DALabeledCircularProgressView *dcView = [[DALabeledCircularProgressView alloc] initWithFrame:CGRectMake((self.chatImageView.width - progressViewWH) * 0.5, (self.chatImageView.height - progressViewWH) * 0.5, progressViewWH, progressViewWH)];
        dcView.roundedCorners = 5;
        dcView.progressLabel.textColor = [UIColor whiteColor];
        dcView.hidden = YES;
        _progressView = dcView;
        [self.chatImageView addSubview:_progressView];
        
    }
    
    return _progressView;
}

- (LCShapedImageView *)chatImageView
{
    if (!_chatImageView) {
        LCShapedImageView *chatImageView = [[LCShapedImageView alloc] init];
        chatImageView.contentMode = UIViewContentModeScaleAspectFill;
        _chatImageView = chatImageView;
        
        // 将图片加载在msgLabel上显示
        [_msgLabel addSubview:_chatImageView];
    }
    
    return _chatImageView;
}

- (UIImageView *)headerImageView
{
    if (!_headerImageView) {
        UIImage *imageName = [UIImage imageNamed:[NSString stringWithFormat:@"aio_voiceChange_effect_%zd", arc4random_uniform(7)]];
        UIImageView *headerImageView = [[UIImageView alloc] initWithImage:imageName];
        _headerImageView = headerImageView;
        _headerImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_headerImageView];
    }
    
    return _headerImageView;
}

- (UILabel *)voiceTimeLabel
{
    if (!_voiceTimeLabel) {
        UILabel *voicetimeLabel = [[UILabel alloc] init];
        voicetimeLabel.textColor = [UIColor grayColor];
        voicetimeLabel.font = [UIFont systemFontOfSize:14];
        _voiceTimeLabel = voicetimeLabel;
        [self.contentView addSubview:_voiceTimeLabel];
    }
    
    return _voiceTimeLabel;
}

- (UILabel *)msgLabel
{
    if (!_msgLabel) {
        UILabel *msgLabel = [[UILabel alloc] init];
        msgLabel.backgroundColor = [UIColor clearColor];
        msgLabel.numberOfLines = 0;
        msgLabel.userInteractionEnabled = YES;
        if (iPhone5 || iPhone4S) {
            msgLabel.preferredMaxLayoutWidth = iPhone5preferredMaxWidth;
        } else if(iPhone6s) {
            msgLabel.preferredMaxLayoutWidth = iPhone6spreferredMaxWidth;
        } else if(iPhone6SP) {
            msgLabel.preferredMaxLayoutWidth = iPhone6sPluspreferredMaxWidth;
        }
        
        _msgLabel = msgLabel;
        [self.contentView addSubview:self.msgLabel];
        
        [_msgLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(msgLabelTap:)]];
        [_msgLabel addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTap:)]];
    }
    
    return _msgLabel;
}

- (UIImageView *)redCircleView
{
    if (!_redCircleView) {
        UIImageView *redCircleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"未读消息-红底"]];
        _redCircleView = redCircleView;
        [self.contentView addSubview:_redCircleView];
    }
    
    return _redCircleView;
}

- (UILabel *)nicknameLabel
{
    if (!_nicknameLabel) {
        UILabel *nicknameLabel = [[UILabel alloc] init];
        nicknameLabel.textColor = [UIColor lightGrayColor];
        nicknameLabel.font = [UIFont systemFontOfSize:14];
        _nicknameLabel = nicknameLabel;
        [self.contentView addSubview:_nicknameLabel];
    }
    
    return _nicknameLabel;
}

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] init];
        activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _activityIndicatorView = activityIndicatorView;
        [self.contentView addSubview:_activityIndicatorView];
    }
    
    return _activityIndicatorView;
}

- (UIImageView *)failImageView
{
    if (!_failImageView) {
        UIImageView *failImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_message_cell_error"]];
        failImageView.userInteractionEnabled = YES;
        _failImageView = failImageView;
        [self.contentView addSubview:_failImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(failImageViewTap:)];
        [_failImageView addGestureRecognizer:tap];
    }
    
    return _failImageView;
}

#pragma mark -  init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = colorf0fGrey;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self headerImageView];
        [self backgroundMsgView];
        [self voiceTimeLabel];
        [self msgLabel];
        [self redCircleView];
        [self activityIndicatorView];
        [self failImageView];
    }
    
    return self;
}

#pragma mark - cellHeight
- (CGFloat)cellHeight
{
    [self layoutIfNeeded];
    return self.msgLabel.bounds.size.height + 35;
}

#pragma mark - setsession
- (void)setSession:(LCSession *)session
{
    _session = session;
    self.voiceTimeLabel.hidden = YES;
    self.redCircleView.hidden = YES;
    self.nicknameLabel.hidden = YES;
    [self.activityIndicatorView stopAnimating];
    self.failImageView.hidden = YES;
    self.chatImageView.hidden = YES;
    self.backgroundMsgView.hidden = NO;
    self.mapViewMaskLabel.hidden = YES;
    
    // 显示 失败,发送中 等状态
    [self showActivityIndicatorViewAndFailImageView];
    
    if (session.messageType == messageTypeText) { // 文本
        _msgLabel.attributedText = session.text;
        
    } else if (session.messageType == messageTypeVoice){ // 语音
        _msgLabel.attributedText = [self showVoiceAttributedString];
        
    } else if (session.messageType == messageTypeImage){ // 图片
        [self showImageViewAttributedString];
        
    } else if (session.messageType == messageTypeMap) { // 地图
        [self showMapViewAttributedString];
    }
    
    if (session.sourceType == sourcetypeFrom) {
        
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:session.userHeadUrl] placeholderImage:[UIImage imageNamed:@"aio_voiceChange_effect_5"]];
    }
}

// 排版语音的样式
- (NSAttributedString *)showVoiceAttributedString
{
    if (self.session.isVoicePlaying) {
        [LCAudioPlayTool playingImageView];
    } else {
        [LCAudioPlayTool stopPlayingImageView];
    }
    
    _voiceTimeLabel.hidden = NO;
    _voiceTimeLabel.text = [NSString stringWithFormat:@"%zd''", self.session.duration];;
    NSInteger duration = self.session.duration;
    
    NSMutableAttributedString *voiceAttM = [[NSMutableAttributedString alloc] init];
    
    if ([self.reuseIdentifier isEqualToString:@"receiverChatCellId"]) {
        _redCircleView.hidden = self.session.isReadVoice;
        UIImage *receiverImg = [UIImage imageNamed:@"ReceiverVoiceNodePlaying_ios7"];
        [self appendAttr:voiceAttM image:receiverImg];
        [self appendAttr:voiceAttM duration:duration];
        
    }else{
        UIImage *receiverImg = [UIImage imageNamed:@"SenderVoiceNodePlaying_ios7"];
        [self appendAttr:voiceAttM duration:duration];
        [self appendAttr:voiceAttM image:receiverImg];
    }
    
    return [voiceAttM copy];
}

// 显示语音图片
- (void)appendAttr:(NSMutableAttributedString *)voiceAttM image:(UIImage *)receiverImg
{
    NSTextAttachment *imgAttachment = [[NSTextAttachment alloc] init];
    imgAttachment.bounds = CGRectMake(0, 0, 25, 25);
    imgAttachment.image = receiverImg;
    NSAttributedString *imgAtt = [NSAttributedString attributedStringWithAttachment:imgAttachment];
    [voiceAttM appendAttributedString:imgAtt];
}

// 显示语音长度
- (void)appendAttr:(NSMutableAttributedString *)voiceAttM duration:(NSInteger )duration
{
    // 限制显示语音的长度
    if (duration >30) duration = 30;
    
    // 根据语音时长决定语音长度
    for (int i = 0; i < duration; i++) {
        NSTextAttachment *imgAttachment1 = [[NSTextAttachment alloc] init];
        imgAttachment1.bounds = CGRectMake(0, 0, 5, 25);
        NSAttributedString *imgAtt1 = [NSAttributedString attributedStringWithAttachment:imgAttachment1];
        [voiceAttM appendAttributedString:imgAtt1];
    }
}

// 排版图片的样式
- (void)showImageViewAttributedString
{
    self.chatImageView.hidden = NO;
    self.backgroundMsgView.hidden = YES;
    NSTextAttachment *imgAttach = [[NSTextAttachment alloc] init];
    
    imgAttach.bounds = CGRectMake(0, 0, self.session.thumbnailFrame.width, self.session.thumbnailFrame.height);
    NSAttributedString *imgAtt = [NSAttributedString attributedStringWithAttachment:imgAttach];
    _msgLabel.attributedText = imgAtt;
    
    self.chatImageView.frame = CGRectMake(0, 0, self.session.thumbnailFrame.width, self.session.thumbnailFrame.height);
    self.chatImageView.layer.mask.contents = (__bridge id _Nullable)(self.backgroundMsgView.image.CGImage);
    
    LCWeakSelf
    if ([self.session.imageThumbnailPath hasPrefix:@"http:"] || [self.session.imageOriginalPath hasPrefix:@"http:"]) {
        if ([self.session.imageThumbnailPath hasPrefix:@"http:"]) { // 首选缩略图
            
            [self.chatImageView sd_setImageWithURL:[NSURL URLWithString:self.session.imageThumbnailPath] placeholderImage:nil options:SDWebImageLowPriority | SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.progressView.hidden = NO;
                    weakSelf.progressView.progress = 1.0 * receivedSize / expectedSize;
                });

                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    weakSelf.progressView.hidden = YES;
                });
            }];
        } else {
            
            [self.chatImageView sd_setImageWithURL:[NSURL URLWithString:self.session.imageOriginalPath] placeholderImage:nil options:SDWebImageLowPriority | SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.progressView.hidden = NO;
                    weakSelf.progressView.progress = 1.0 * receivedSize / expectedSize;
                });

                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    weakSelf.progressView.hidden = YES;
                });
            }];
        }
        
    }else{ // 本地来源
        UIImage *image = [UIImage imageWithContentsOfFile:[NSString imageCachesPathWithImageName:self.session.imageFileName]];
        [self.chatImageView setImage:image];
    }
}


// 排版map样式
- (void)showMapViewAttributedString
{
    self.chatImageView.hidden = NO;
    self.backgroundMsgView.hidden = YES;
    self.mapViewMaskLabel.hidden = NO;
    NSTextAttachment *imgAttach = [[NSTextAttachment alloc] init];
    
    imgAttach.bounds = CGRectMake(0, 0, self.session.mapViewFrame.width, self.session.mapViewFrame.height);
    NSAttributedString *imgAtt = [NSAttributedString attributedStringWithAttachment:imgAttach];
    _msgLabel.attributedText = imgAtt;
    
    self.chatImageView.frame = CGRectMake(0, 0, self.session.mapViewFrame.width, self.session.mapViewFrame.height);
    self.chatImageView.layer.mask.contents = (__bridge id _Nullable)(self.backgroundMsgView.image.CGImage);
    CGFloat mapHeight = 30;
    self.mapViewMaskLabel.frame = CGRectMake(0, self.chatImageView.height - mapHeight, self.chatImageView.width, mapHeight);
    // 暂且只考虑本地发送
    UIImage *image = [UIImage imageWithContentsOfFile:[NSString imageCachesPathWithImageName:self.session.mapViewFileName]];
    [self.chatImageView setImage:image];
    self.mapViewMaskLabel.text = self.session.locationName;
}

// 发送方 菊花、重发 的标记
- (void)showActivityIndicatorViewAndFailImageView
{
    if ([self.reuseIdentifier isEqualToString:@"senderchatCellId"]){
        if (self.session.isSend == YES) {
            [self.activityIndicatorView stopAnimating];
            if (self.session.isFail) {
                self.failImageView.hidden = NO;
            }
        } else if (self.session.isSend == NO) {
            [self.activityIndicatorView startAnimating];
            self.failImageView.hidden = YES;
        }
    }
    
}

#pragma mark - UITapGestureRecognizer
- (void)msgLabelTap:(UITapGestureRecognizer *)recognizer{ // 播放语音 展示图片
    
    if (self.session.messageType == messageTypeVoice) {
        
        self.session.readVoice = YES;
        self.redCircleView.hidden = YES;
        // 更新消息状态
//        [[LCBaseDatabaseAPI shareBaseDatabase] insertSession:self.session];
        BOOL receiver = [self.reuseIdentifier isEqualToString:@"receiverChatCellId"];

        [LCAudioPlayTool playWithMessage:self.session msgLabel:self.msgLabel receiver:receiver];
        
    } else if (self.session.messageType == messageTypeImage) {
        [LCAudioPlayTool stop];
        if ([self.delegate respondsToSelector:@selector(chatCell:didClickAssetSession:)]) {
            [self.delegate chatCell:self didClickAssetSession:self.session];
        }
    } else if (self.session.messageType == messageTypeMap) {
         [LCAudioPlayTool stop];
        if ([self.delegate respondsToSelector:@selector(chatCell:didClickMapViewSession:)]) {
            [self.delegate chatCell:self didClickMapViewSession:self.session];
        }
    }
}

- (void)failImageViewTap:(UITapGestureRecognizer *)recognizer{ // 重新发送失败的消息
    LCSession *session = self.session;
    session.send = NO;
    
    if ([self.delegate respondsToSelector:@selector(chatCell:didClickRetrySession:)]) {
        [self.delegate chatCell:self didClickRetrySession:session];
    }
}

// 长按复制功能
- (void)longTap:(UIGestureRecognizer*) recognizer {
    
    if (self.session.messageType == messageTypeText) {
        [self becomeFirstResponder];
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        
        menu.menuItems = @[
                           [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(customerCopy:)]
                           ];
        CGRect rect = CGRectZero;
        if ([self.reuseIdentifier isEqualToString:@"senderchatCellId"]){
            rect = CGRectMake(self.msgLabel.x * 0.01, self.height * 0.15, self.msgLabel.width, 1);
        } else {
            rect = CGRectMake(-self.msgLabel.x * 0.01, self.height * 0.15, self.msgLabel.width, 1);
        }
        [[UIMenuController sharedMenuController] setTargetRect:rect inView:self.msgLabel];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
    }
}

- (BOOL)canBecomeFirstResponder {
    
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    return (action == @selector(customerCopy:));
}

- (void)customerCopy:(id)sender {
    
    NSData *sessionData = [NSKeyedArchiver archivedDataWithRootObject:self.session];
    UIPasteboard *pboard = [UIPasteboard pasteboardWithName:@"myPboard" create:YES];
    [pboard setData:sessionData forPasteboardType:@"session"];
}
@end
