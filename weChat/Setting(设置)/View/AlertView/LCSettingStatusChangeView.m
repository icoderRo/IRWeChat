//
//  LCSettingStatusChangeView.m
//  TaiYangHua
//
//  Created by Lc on 15/12/25.
//  Copyright © 2015年 hhly. All rights reserved.
//

#import "LCSettingStatusChangeView.h"
#import "LCSettingConst.h"

//#import "SVProgressHUD.h"

@interface LCSettingStatusChangeView ()
@property (weak, nonatomic) IBOutlet UIButton *onLineBtn;
@property (weak, nonatomic) IBOutlet UIButton *busyBtn;
@property (weak, nonatomic) IBOutlet UIButton *leaveBtn;
@property (weak, nonatomic) IBOutlet UIButton *offLineBtn;
@property (weak, nonatomic) IBOutlet UIView *translateView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *translateBottomConstrain;

@end


@implementation LCSettingStatusChangeView
#pragma mark - monitor
- (IBAction)onLineClick:(UIButton *)sender {
  [self postUrlWithOnLineState:@(sender.tag) title:sender.titleLabel.text];
}

- (IBAction)busyClick:(UIButton *)sender {
    
    [self postUrlWithOnLineState:@(sender.tag) title:sender.titleLabel.text];
}

- (IBAction)leaveClick:(UIButton *)sender {
    
    [self postUrlWithOnLineState:@(sender.tag) title:sender.titleLabel.text];
}

- (IBAction)offLineClick:(UIButton *)sender {
    [self postUrlWithOnLineState:@(sender.tag) title:sender.titleLabel.text];
}

#pragma mark - postTOchangeStatus
- (void)postUrlWithOnLineState:(NSNumber *)number title:(NSString *)title
{
//    NSString *updateUserStateUrl = [NSString stringWithFormat:@"%@%@",kLCAppServerURL,kupdateUserState];
//    NSDictionary *dict = @{
//                           @"companyCode": [AuthModel sharedInstance].companyCode,
//                           @"userId":[AuthModel sharedInstance].userInfo.userId,
//                           @"onLineState":number,
//                           @"token" : [AuthModel sharedInstance].token
//                           };
//    
//    [[NetworkTools shareNetworkTools] settingControlPostWithURL:updateUserStateUrl params:dict success:^(id json) {
//        DLog(@"%@", json);
//        [SVProgressHUD showSuccessWithStatus:Localizable(@"成功")];
//        [self postNotification:title];
//        [self dismiss];
//    } failure:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:Localizable(@"失败")];
//        DLog(@"error code = 200");
//    }];
    
    [self postNotification:title];
     [self dismiss];
}


- (void)postNotification:(NSString *)text
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LCSettingStatusChangeViewDidChangeStatus object:self userInfo:@{@"title":text}];
}

- (void)awakeFromNib {
    self.translateBottomConstrain.constant = -self.translateView.height;
    
    [self.onLineBtn setTitle:@"在线" forState:UIControlStateNormal];
    [self.busyBtn setTitle:@"繁忙" forState:UIControlStateNormal];
    [self.leaveBtn setTitle:@"离开" forState:UIControlStateNormal];
    [self.offLineBtn setTitle:@"离线" forState:UIControlStateNormal];
}

#pragma mark - viewShow & dissmiss
- (void)show {
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    
    [window addSubview:self];
    
    [UIView animateWithDuration:.3 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        _translateView.transform = CGAffineTransformMakeTranslation(0, -self.translateView.height);
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:.3 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        _translateView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//}
@end
