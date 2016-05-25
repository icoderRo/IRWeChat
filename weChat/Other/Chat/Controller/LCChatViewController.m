//
//  LCChatViewController.m
//  weChat
//
//  Created by Lc on 16/3/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCChatViewController.h"
#import "LCInputToolBar.h"
#import "LCBaseChatCell.h"
#import "LCReceiverChatCell.h"
#import "LCSenderChatCell.h"
#import "LCBannerCell.h"
#import "LCSession.h"
#import "LCPhotoBrowseView.h"
#import "LCHttpParamTool.h"
#import "LCHttpTool.h"
#import "LCBanner.h"
#import "LCMapViewController.h"

#define inputToolBarDefailtHeight 44

@interface LCChatViewController ()<UITableViewDelegate, UITableViewDataSource, LCInputToolBarDelegate, LCBaseChatCellDelegate>

@property (strong, nonatomic) LCBaseChatCell *baseChatCellTool;
@property (weak, nonatomic) LCInputToolBar *inputToolBar;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (weak, nonatomic) UITableView *tableView;
@property (assign, nonatomic) NSInteger maxIndex;
@property (nonatomic, copy) NSString *currentTimeStr;
@property (nonatomic, strong) MASConstraint *inputToolBarBottomConstraint;
@property (nonatomic, strong) MASConstraint *inputToolBarHeight;
@end

@implementation LCChatViewController

static NSString * const senderchatCellId = @"senderchatCellId";
static NSString * const receiverChatCellId = @"receiverChatCellId";
static NSString * const bannerCellId = @"bannerCellId";

#pragma mark - lazy

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tableView =[[UITableView alloc] init];
        _tableView = tableView;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
        }];
    }
    
    return _tableView;
}

#pragma mark - init
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"群 号：475814382";
    self.view.backgroundColor = colorf0fGrey;
    self.navigationController.navigationBar.backgroundColor = [UIColor  yellowColor];
    [self setupTableView];
    [self setupToolBar];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"textViewDidEndEditing" object:nil];
}

- (void)setupTableView
{
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = colorf0fGrey;
    [self.tableView registerClass:[LCSenderChatCell class] forCellReuseIdentifier:senderchatCellId];
    [self.tableView registerClass:[LCReceiverChatCell class] forCellReuseIdentifier:receiverChatCellId];
    [self.tableView registerClass:[LCBannerCell class] forCellReuseIdentifier:bannerCellId];
    self.baseChatCellTool = [self.tableView dequeueReusableCellWithIdentifier:senderchatCellId];
    
}

- (void)setupToolBar
{
    LCInputToolBar *inputToolBar = [LCInputToolBar inputToolBar];
    
    inputToolBar.delegate = self;
    inputToolBar.targetType = self.targetType;
    inputToolBar.sessionId = self.sessionId;
    inputToolBar.targetId = self.targetId;
    
    self.inputToolBar = inputToolBar;
    [self.view addSubview:self.inputToolBar];
    
    [self.inputToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.tableView.mas_bottom);
        self.inputToolBarHeight = make.height.equalTo(@(inputToolBarDefailtHeight));
        self.inputToolBarBottomConstraint = make.bottom.equalTo(self.view);
    }];
    
    [self.inputToolBar setInputBarHeight:^(CGFloat height) {
        self.inputToolBarHeight.offset = height;
        [UIView animateWithDuration:.25 animations:^{
            [self.view layoutIfNeeded];
        }];
        //        [self scrollToBottom];
    }];
    
}

#pragma mark - monitorUIKeyboardFrame
- (void)keyboardWillChangeChangeFrame:(NSNotification *)note
{
    if (self.inputToolBar.switchingKeybaord) return;
    
    CGRect kbEndFrm = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbHeight = self.view.height -  kbEndFrm.origin.y;
    
    self.inputToolBarBottomConstraint.offset = - kbHeight;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];

    [self scrollToBottom];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"textViewDidEndEditing" object:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource[indexPath.row] isKindOfClass:[LCBanner class]]) {
        LCBannerCell *bannerCell = [tableView dequeueReusableCellWithIdentifier:bannerCellId];
        LCBanner *banner = self.dataSource[indexPath.row];
        bannerCell.time = banner.timerString;
        return bannerCell;
        
    }
    
    LCSession *session = self.dataSource[indexPath.row];
    LCBaseChatCell *chatCell = nil;
    
    if (session.sourceType == sourcetypeTo) {
        chatCell = [tableView dequeueReusableCellWithIdentifier:senderchatCellId];
    } else {
        chatCell = [tableView dequeueReusableCellWithIdentifier:receiverChatCellId];
    }
    
    chatCell.session = session;
    chatCell.delegate = self;
    return chatCell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource[indexPath.row] isKindOfClass:[LCBanner class]]) return 18;
    
    self.baseChatCellTool.session = self.dataSource[indexPath.row];
    return self.baseChatCellTool.cellHeight;  
}


#pragma mark - LCSessionToolBarDelegate
// 发送文字
- (void)inputToolBar:(LCInputToolBar *)inputToolBar didSendTextSession:(LCSession *)textSession isNeedToAdd:(BOOL)add{
    // 推送文字
    // 恢复单行
    self.inputToolBarHeight.offset = inputToolBarDefailtHeight;
    [UIView animateWithDuration:.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        textSession.send = YES;
        textSession.fail = YES;
         [self.tableView reloadData];
    });
    if (add) {
        [self addSession:textSession];
        [self.tableView reloadData];
        [self scrollToBottom];
    }
}
// 上传语音
- (void)inputToolBar:(LCInputToolBar *)inputToolBar didSendVoiceSession:(LCSession *)voiceSession isNeedToAdd:(BOOL)add
{
    // 上传语音文件
//    NSDictionary *voiceFileParam = [LCHttpParamTool voiceParamsWithSession:voiceSession];
//    LCWeakSelf
//    [LCHttpTool uploadVoiceWithParams:voiceFileParam voiceSession:voiceSession success:^(id json) {
//        NSDictionary *voiceFileUrlParam = [LCHttpParamTool voiceURLParamsWithSession:voiceSession fileURL:json[@"fileUrl"]];
//        // 推送语音文件路径....
//        
//    } progress:nil failure:^(NSError *error) {
//        [weakSelf.tableView reloadData];
//    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        voiceSession.send = YES;
        voiceSession.fail = YES;
        [self.tableView reloadData];
    });
    if (add) {
        [self addSession:voiceSession];
        [self.tableView reloadData];
        [self scrollToBottom];
    }
}

// 上传图片
- (void)inputToolBar:(LCInputToolBar *)inputToolBar didSendImageSession:(LCSession *)imageSession isNeedToAdd:(BOOL)add
{
//    NSDictionary *imageFileParam = [LCHttpParamTool imageParamsWithSession:imageSession];
    // 上传图片文件
//    [LCHttpTool uploadImageWithParams:imageFileParam imageSession:imageSession success:^(id json) {
//        NSDictionary *imageFileUrlParam = [LCHttpParamTool imageURLParamsWithSession:imageSession fileURL:json[@"fileUrl"]];
//        // 推送图片文件路径...
//        
//        
//    } progress:nil failure:^(NSError *error) {
//        [weakSelf.tableView reloadData];
//    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        imageSession.send = YES;
        imageSession.fail = YES;
        [self.tableView reloadData];
    });
    if (add) {
        [self addSession:imageSession];
        [self.tableView reloadData];
        [self scrollToBottom];
    }
}

// 地图
- (void)inputToolBar:(LCInputToolBar *)inputToolBar didSendMapSession:(LCSession *)mapSession isNeedToAdd:(BOOL)add
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        mapSession.send = YES;
        mapSession.fail = YES;
    });
    
    if (add) {
        [self addSession:mapSession];
        [self.tableView reloadData];
        [self scrollToBottom];
    }
}

// 接收消息
//- (void)didReceiveSocketPushSession:(LCSession *)session
//{
//    BOOL isNeedScroll = NO;
//    if (self.tableView.contentOffset.y + self.tableView.height + 50 > self.tableView.contentSize.height)
//    {
//        isNeedScroll = YES;
//    }
//    
//    [self addSession:session];
//    [self.tableView reloadData];
//
//    if (isNeedScroll) {
//        [self scrollToBottom];
//    } else {
//         LCLog(@"在右下角弹出一个消息提醒框");
//    }
//}

#pragma mark - LCInternalBaseChatCellDelegate 
// asset
- (void)chatCell:(LCBaseChatCell *)chatCell didClickAssetSession:(LCSession *)session
{
    NSInteger i = 0;
    NSInteger index = 0;
    NSMutableArray *arr = [NSMutableArray array];
    for (id data in self.dataSource) {
        if ([[data class] isSubclassOfClass:[LCSession class]]) {
            LCSession *session1 = (LCSession *)data;
            if (session1.messageType == messageTypeImage) {
                i++;
                [arr addObject:session1];
            }   
            if ([session1.imageOriginalPath isEqualToString:session.imageOriginalPath]) {
                index = i -1;
            }
        }
    }
    
    LCPhotoBrowseView *photoBrowse = [[LCPhotoBrowseView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    photoBrowse.index = index;
    photoBrowse.datasource = arr;
    [photoBrowse show];
}

// mapView
- (void)chatCell:(LCBaseChatCell *)chatCell didClickMapViewSession:(LCSession *)session
{
    LCMapViewController *mpVc = [[LCMapViewController alloc] init];
    [self.navigationController pushViewController:mpVc animated:YES];
}

// 发送失败.从新发送
- (void)chatCell:(LCBaseChatCell *)chatCell didClickRetrySession:(LCSession *)session
{
    [self.tableView reloadData];
    
    if (session.messageType == messageTypeText) {
        [self inputToolBar:nil didSendTextSession:session isNeedToAdd:NO];
    } else if (session.messageType == messageTypeVoice) {
        [self inputToolBar:nil didSendVoiceSession:session isNeedToAdd:NO];
    } else if (session.messageType == messageTypeImage) {
        [self inputToolBar:nil didSendImageSession:session isNeedToAdd:NO];
    } else if (session.messageType == messageTypeMap) {
        [self inputToolBar:nil didSendMapSession:session isNeedToAdd:NO];
    }
}

- (void)addSession:(LCSession *)session
{
    NSString *timeStr = [NSString stringWithFormat:@"%zd", session.messageTime];
    
    LCBanner *banner = [LCBanner bannerWithTimerString:[timeStr timeString]];
    if (![self.currentTimeStr isEqualToString:banner.timerString]) {
        [self.dataSource addObject:banner];
        self.currentTimeStr = banner.timerString;
    }
    
    [self.dataSource addObject:session];
}

- (void)scrollToBottom
{
    if (self.dataSource.count == 0)return;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count -1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

@end
