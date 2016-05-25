//
//  LCInputToolBar.m
//  weChat
//
//  Created by Lc on 16/3/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCInputToolBar.h"
#import "LCMoreInputView.h"
#import "LCTextView.h"
#import "LCMoreInputView.h"
#import "LCEmotionView.h"
#import "LCSession.h"
#import "LCRecordingView.h"

@interface LCInputToolBar ()<UITextViewDelegate,LCMoreInputViewDelegate>
@property (weak, nonatomic) LCTextView *textView;
@property (weak, nonatomic) UIButton *voiceButton;
@property (weak, nonatomic) UIButton *emotionButton;
@property (weak, nonatomic) UIButton *addButton;
@property (weak, nonatomic) UIView *separatorView;
@property (weak, nonatomic) UIButton *buttom;
@property (weak, nonatomic) UIButton *recordButton;
@property (weak, nonatomic) LCMoreInputView *inputAddView;
@property (weak, nonatomic) LCEmotionView *inputemotionView;
@property (assign, nonatomic, getter=isDurationToolong) BOOL durationToolong;

@end

static CGFloat textViewH = 0;
static CGFloat mintextViewH = 26;
static CGFloat maxtextViewH = 74;
static CGFloat maxTextLength = 50;

@implementation LCInputToolBar
+ (instancetype)inputToolBar
{
    return [[self alloc] init];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self textView];
        [self voiceButton];
        [self emotionButton];
        [self addButton];
        [self separatorView];
        [self recordButton];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidEndEditing) name:@"textViewDidEndEditing" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClickEmotion:) name:@"userClickEmotion" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDeleteEmotions) name:@"didDeleteEmotion" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordIsTooLong) name:@"recordDUrationToolong" object:nil];
    }
    
    return self;
}

- (LCTextView *)textView
{
    if (!_textView) {
        LCTextView *textView = [[LCTextView alloc] init];
        textView.layer.cornerRadius = 5;
        textView.layer.borderWidth = 0.5;
        textView.layer.borderColor = LCColor(180, 180, 180).CGColor;
        textView.font = [UIFont systemFontOfSize:20];
        textView.textContainerInset = UIEdgeInsetsMake(2, 0, 0, 0);
        textView.delegate = self;
        textView.returnKeyType = UIReturnKeySend;
        textView.enablesReturnKeyAutomatically = YES;
        _textView = textView;
        [self addSubview:_textView];
    }
    
    return _textView;
}

- (UIButton *)voiceButton
{
    if (!_voiceButton) {
        UIButton *voiceButton = [[UIButton alloc] init];
        [voiceButton setAdjustsImageWhenHighlighted:NO];
        [voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoice_ios7"] forState:UIControlStateNormal];
        [voiceButton setImage:[UIImage imageNamed:@"qvip_ps_banner_icon"] forState:UIControlStateSelected];
        [voiceButton addTarget:self action:@selector(clickVoiceButton:) forControlEvents:UIControlEventTouchDown];
        _voiceButton = voiceButton;
        [self addSubview:_voiceButton];
    }
    
    return _voiceButton;
}

- (UIButton *)emotionButton
{
    if (!_emotionButton) {
        UIButton *emotionButton = [[UIButton alloc] init];
        [emotionButton setAdjustsImageWhenHighlighted:NO];
        [emotionButton setImage:[UIImage imageNamed:@"chat_bottom_smile_nor"] forState:UIControlStateNormal];
        [emotionButton setImage:[UIImage imageNamed:@"chat_bottom_emotion_press"] forState:UIControlStateSelected];
        [emotionButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchDown];
        _emotionButton = emotionButton;
        [self addSubview:_emotionButton];
    }
    
    return _emotionButton;
}

- (UIButton *)addButton
{
    if (!_addButton) {
        UIButton *addButton = [[UIButton alloc] init];
        [addButton setAdjustsImageWhenHighlighted:NO];
        [addButton setImage:[UIImage imageNamed:@"chat_bottom_up_nor"] forState:UIControlStateNormal];
        [addButton setImage:[UIImage imageNamed:@"chat_bottom_up_press"] forState:UIControlStateSelected];
        [addButton addTarget:self action:@selector(clickAddButton:) forControlEvents:UIControlEventTouchDown];
        _addButton = addButton;
        [self addSubview:_addButton];
    }
    
    return _addButton;
}

- (UIView *)separatorView
{
    if (!_separatorView) {
        UIView *separatorView = [[UIView alloc] init];
        separatorView.backgroundColor = LCColor(209, 209, 209);
        _separatorView = separatorView;
        [self addSubview:_separatorView];
    }
    
    return _separatorView;
}

- (UIButton *)recordButton
{
    if (!_recordButton) {
        UIButton *recordButton = [[UIButton alloc] init];
        recordButton.layer.cornerRadius = 5;
        recordButton.layer.borderWidth = 0.5;
        recordButton.layer.borderColor = LCColor(180, 180, 180).CGColor;
        [recordButton setTitle:@"按住  说话" forState:UIControlStateNormal];
        [recordButton setTitleColor:LCColor(100, 100, 100) forState:UIControlStateNormal];
        [recordButton setBackgroundColor:[UIColor whiteColor]];
        [recordButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [recordButton setHidden:YES];
        [recordButton addTarget:self action:@selector(startRecord:) forControlEvents:UIControlEventTouchDown];
        [recordButton addTarget:self action:@selector(endRecord:) forControlEvents:UIControlEventTouchUpInside];
        [recordButton addTarget:self action:@selector(dragExitRecord:) forControlEvents:UIControlEventTouchDragExit];
        [recordButton addTarget:self action:@selector(cancelRecord:) forControlEvents:UIControlEventTouchUpOutside];
        [recordButton addTarget:self action:@selector(dragEnterRecord:) forControlEvents:UIControlEventTouchDragEnter];
        _recordButton = recordButton;
        [self addSubview:_recordButton];
    }
    
    return _recordButton;
}

- (LCMoreInputView *)inputAddView
{
    if (!_inputAddView) {
        LCMoreInputView *inputView = [[LCMoreInputView alloc] initWithFrame:CGRectMake(0, 0,self.width, 200)];
        inputView.delegate = self;
        _inputAddView = inputView;
        self.textView.inputView = _inputAddView;
    }
    
    return _inputAddView;
}

- (LCEmotionView *)inputemotionView
{
    if (!_inputemotionView) {
        LCEmotionView *inputView = [[LCEmotionView alloc] initWithFrame:CGRectMake(0, 0, self.width, 200)];
        inputView.didclickSenderEmotion = ^{
            [self clickEmotionSenderButton];
        };
        
        _inputemotionView = inputView;
        [self.inputAddView addSubview:_inputemotionView];
    }
    
    return _inputemotionView;
}

#pragma mark - button addTarget
- (void)clickAddButton:(UIButton *)addButton
{
    // 表情按钮非选中状态
    self.emotionButton.selected = NO;
    self.voiceButton.selected = NO;
    self.recordButton.hidden = YES;
    addButton.selected = !addButton.isSelected;
    
    if (addButton.isSelected) { // 选中状态
        // 退出之前的键盘
        self.switchingKeybaord = YES;
        [self.textView endEditing:YES];
        self.switchingKeybaord = NO;
        
        // 弹出新的键盘,并禁止编辑
        self.textView.inputView = self.inputAddView;
        [self.textView setEditable:NO];
        [self.textView becomeFirstResponder];
        
    } else { //非选中状态
        // 允许编辑
        [self.textView setEditable:YES];
        // 结束编辑
        [self.textView endEditing:YES];
        // 键盘更改为系统键盘
        self.textView.inputView = nil;
    }
}

- (void)clickButton:(UIButton *)buttom
{
    self.voiceButton.selected = NO;
    self.recordButton.hidden = YES;
    // 更多按钮非选中状态
    self.addButton.selected = NO;
    buttom.selected = !buttom.isSelected;
    
    // 退出之间的键盘,并允许编辑
    self.switchingKeybaord = YES;
    [self.textView setEditable:YES];
    [self.textView endEditing:YES];
    self.switchingKeybaord = NO;
    
    if (buttom.isSelected) { // 弹出新键盘
        self.textView.inputView = self.inputemotionView;
        [self.textView becomeFirstResponder];
    } else { // 系统默认的键盘
        self.textView.inputView = nil;
        // 延迟弹出键盘
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.textView becomeFirstResponder];
        });
    }
}

- (void)clickVoiceButton:(UIButton *)voiceButton
{
    self.addButton.selected = NO;
    self.emotionButton.selected = NO;
    
    if (self.inputBarHeight) {
        self.inputBarHeight(27 + 18);
    }
    [self.textView endEditing:YES];
    voiceButton.selected = !voiceButton.isSelected;
    self.recordButton.hidden = !voiceButton.isSelected;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing
{
    self.textView.editable = YES;
    self.addButton.selected = NO;
    self.emotionButton.selected = NO;
    self.textView.inputView = nil;
}

#pragma mark - sendText
- (void)textViewDidChange:(UITextView *)textView
{
    
    if (self.textView.fullText.length > maxTextLength) {
        NSString *fullText = [self.textView.fullText substringToIndex:maxTextLength];
        self.textView.attributedText = [fullText emotionStringWithWH:24];
        self.textView.font = [UIFont systemFontOfSize:20];
        [MBProgressHUD showError:@"超过50字符"];
        return;
    }
    
    
    [self textViewDidchangeHeight:self.textView];
}
// 点击发送
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // 发送
    if ([text isEqualToString:@"\n"]){
        // 纯空格禁止发送
        NSString *spaceString = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (spaceString.length == 0) return NO;
        
        if ([self.delegate respondsToSelector:@selector(inputToolBar:didSendTextSession:isNeedToAdd:)]) {
            LCSession *session = [[LCSession alloc] init];
            session.sourceType = sourcetypeTo;
            session.messageType = messageTypeText;
            session.targetType = self.targetType;
            session.fullText = self.textView.fullText;
            session.sessionId = self.sessionId;
            session.targetId = self.targetId;
            session.messageTime = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]*1000;
            [self.delegate inputToolBar:self didSendTextSession:session isNeedToAdd:YES];
        }
        self.textView.fullText = nil;
        self.textView.attributedText = nil;
        return NO;
    }
    
    [self textViewDidchangeHeight:self.textView];
    return YES;
}

// 点击发送
- (void)clickEmotionSenderButton
{
    if (self.textView.attributedText.length == 0) return; // 无数据则返回
    __weak typeof(self) weakSelf = self;
    if ([self.delegate respondsToSelector:@selector(inputToolBar:didSendTextSession:isNeedToAdd:)]) {
        LCSession *session = [[LCSession alloc] init];
        session.sourceType = sourcetypeTo;
        session.messageType = messageTypeText;
        session.targetType = self.targetType;
        session.fullText = self.textView.fullText;
        session.sessionId = self.sessionId;
        session.targetId = self.targetId;
        session.messageTime = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]*1000;
        [weakSelf.delegate inputToolBar:weakSelf didSendTextSession:session isNeedToAdd:YES];
    }
    weakSelf.textView.fullText = nil;
    weakSelf.textView.attributedText = nil;
}

#pragma mark - imageChoose
// 发送图片
- (void)moreInputView:(LCMoreInputView *)moreInputView didFinishChooseImageThumbnailFrame:(CGSize)thumbnailFrame fileName:(NSString *)fileName
{
    if ([self.delegate respondsToSelector:@selector(inputToolBar:didSendImageSession:isNeedToAdd:)]) {
        
        LCSession *session = [[LCSession alloc] init];
        session.sourceType = sourcetypeTo;
        session.messageType = messageTypeImage;
        session.thumbnailFrame = thumbnailFrame;
        session.imageFileName = fileName;
        session.targetType = self.targetType;
        session.sessionId = self.sessionId;
        session.targetId = self.targetId;
        session.messageTime = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]*1000;
        [self.delegate inputToolBar:self didSendImageSession:session isNeedToAdd:YES];
    }
}

- (void)moreInputView:(LCMoreInputView *)moreInputView didFinishLocatingMapViewName:(NSString *)mapViewName locationName:(NSString *)locationName mapViewFrame:(CGSize)mapViewFrame
{
    if ([self.delegate respondsToSelector:@selector(inputToolBar:didSendMapSession:isNeedToAdd:)]) {
        
        LCSession *session = [[LCSession alloc] init];
        session.sourceType = sourcetypeFrom;
        session.messageType = messageTypeMap;
        session.mapViewFrame = mapViewFrame;
        session.mapViewFileName = mapViewName;
        session.locationName = locationName;
        session.targetType = self.targetType;
        session.sessionId = self.sessionId;
        session.targetId = self.targetId;
        session.messageTime = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]*1000;
        [self.delegate inputToolBar:self didSendMapSession:session isNeedToAdd:YES];
    }
}

#pragma mark - voiceRecord
// 开始录音
- (void)startRecord:(UIButton *)recordButton {
    if (![[LCAudioManager manager] checkMicrophoneAvailability]) {
        [MBProgressHUD showError:@"请在隐私界面 检测麦克风是否开启"];
        self.durationToolong = YES;
        return;
    }
    self.durationToolong = NO;
    [recordButton setTitle:@"松开发送语音" forState:UIControlStateNormal];
    [LCRecordingView subTitleLabelStatues:subTitleStatuesDefault];
    [LCAudioPlayTool stop];
    [LCRecordingView show];
    [[LCAudioManager manager] startRecordingWithFileName:[NSString recordFileName] completion:nil];
}

// 录音结束 上传音频
- (void)endRecord:(UIButton *)recordButton {
     if (self.isDurationToolong) return; // 防止录音过长,自动发送后,再次执行
    
    [[LCAudioManager manager] stopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (aDuration < 1) {
            [MBProgressHUD showError:@"录音时间过短"];
            return ;
        }
        
        if (!error) {
            if ([self.delegate respondsToSelector:@selector(inputToolBar:didSendVoiceSession:isNeedToAdd:)]) {
                LCSession *session = [[LCSession alloc] init];
                session.sourceType = sourcetypeFrom;
                session.messageType = messageTypeVoice;
                session.duration = aDuration;
                session.recordPath = recordPath;
                session.targetType = self.targetType;
                session.sessionId = self.sessionId;
                session.targetId = self.targetId;
                session.messageTime = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]*1000;
                [self.delegate inputToolBar:self didSendVoiceSession:session isNeedToAdd:YES];
            }
        }
    }];
    
    [recordButton setTitle:@"按住  说话" forState:UIControlStateNormal];
    [LCRecordingView dismiss];
    [LCRecordingView subTitleLabelStatues:subTitleStatuesDefault];
}

- (void)recordIsTooLong
{
    self.recordButton.tag = 60;
    [self endRecord:self.recordButton];
    self.durationToolong = YES;
}

// 取消录音
- (void)cancelRecord:(UIButton *)recordButton
{
    [LCRecordingView dismiss];
    [recordButton setTitle:@"按住  说话" forState:UIControlStateNormal];
    [[LCAudioManager manager] cancelRecording];
    [LCRecordingView subTitleLabelStatues:subTitleStatuesDefault];

}

// 离开按钮范围
- (void)dragExitRecord:(UIButton *)recordButton
{
    [recordButton setTitle:@"松开手指,取消发送语音" forState:UIControlStateNormal];
     [LCRecordingView subTitleLabelStatues:subTitleStatuesCancel];
}

// 移动回按钮范围
- (void)dragEnterRecord:(UIButton *)recordButton
{
    [recordButton setTitle:@"松开发送语音" forState:UIControlStateNormal];
     [LCRecordingView subTitleLabelStatues:subTitleStatuesDefault];
}

- (void)didEnterBackgroundNotification
{
    [LCAudioPlayTool stop];
    [LCRecordingView subTitleLabelStatues:subTitleStatuesDefault];
    [[LCAudioManager manager] cancelRecording];
}
// 插入表情
- (void)didClickEmotion:(NSNotification *)note
{
    LCLog(@"测试通知执行了几次"); // 之前测试项目中,NSNotification执行了两次,改用了block ,这个demo中未发现
    if (self.textView.fullText.length + 6 > maxTextLength) {
        [MBProgressHUD showError:@"超过50字符"];
        return ;
    }

    LCEmotion *emotion = note.userInfo[@"emotion"];
    [self.textView insertEmotion:emotion];
    [self textViewDidchangeHeight:self.textView];
}

// 删除表情
- (void)didDeleteEmotions
{
    [self.textView deleteBackward];
    
    [self textViewDidchangeHeight:self.textView];
}
// 更改输入框高度
- (void)textViewDidchangeHeight:(LCTextView *)textView;
{
    CGFloat contentHeight = textView.contentSize.height;
    if (contentHeight < mintextViewH) {
        textViewH = mintextViewH;
    } else if (contentHeight > maxtextViewH){
        textViewH = maxtextViewH;
    } else {
        textViewH = contentHeight;
    }
    
    if (self.inputBarHeight) {
        self.inputBarHeight(textViewH + 18);
    }
    [textView setContentOffset:CGPointZero animated:YES];
    [textView scrollRangeToVisible:textView.selectedRange];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 防止点击toobar键盘退出
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {}

#pragma mark - layoutSubViews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-5);
        make.width.equalTo(@(30));
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-5);
        make.width.equalTo(@(30));
    }];
    
    [self.emotionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addButton.mas_left).offset(-15);
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-5);
        make.width.equalTo(@(30));
    }];
    
    [self.recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.voiceButton.mas_right).offset(15);
        make.top.equalTo(self).offset(11);
        make.bottom.equalTo(self).offset(-6);
        make.right.equalTo(self.emotionButton.mas_left).offset(-15);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.voiceButton.mas_right).offset(15);
        make.top.equalTo(self).offset(11);
        make.bottom.equalTo(self).offset(-6);
        make.right.equalTo(self.emotionButton.mas_left).offset(-15);
    }];
    
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@(0.3));
    }];
}
@end
