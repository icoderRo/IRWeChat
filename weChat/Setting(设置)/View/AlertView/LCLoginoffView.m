//
//  LCLoginoffView.m
//  TaiYangHua
//
//  Created by Lc on 16/1/15.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import "LCLoginoffView.h"

@interface LCLoginoffView ()
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIView *translateView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *translateBottomConstrain;

@end

@implementation LCLoginoffView
- (IBAction)sureButton:(UIButton *)sender {
    
    [self loginOff];
    
}

- (IBAction)cancelButton:(UIButton *)sender {
    
    [self dismiss];
}

- (void)awakeFromNib
{
    self.translateBottomConstrain.constant = -self.translateView.height;
}

- (void)loginOff
{
//    [MBProgressHUD showMessage:Localizable(@"正在注销...") toView:self];
//    // 注销登录
//    NSString *logotUrl = [NSString stringWithFormat:@"%@%@",kLCAppServerURL,klogout];
//    NSDictionary *dict = @{
//                           @"companyCode": [AuthModel sharedInstance].companyCode,
//                           @"userId":[AuthModel sharedInstance].userInfo.userId,
//                           @"token" : [AuthModel sharedInstance].token
//                           };
//    [[NetworkTools shareNetworkTools] settingControlPostWithURL:logotUrl params:dict success:^(id json) {
//        DLog(@"%@", [json[@"result"] class]);
//        
//        [MBProgressHUD hideHUDForView:self];
//        [MBProgressHUD showSuccess:Localizable(@"注销成功")];
//
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AutoLogin"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        LCLoginViewController* loginController = [[LCLoginViewController alloc] init];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginController];
//        
//        self.window.rootViewController = nav;
//        DLog(@"%i",[[NSUserDefaults standardUserDefaults] boolForKey:@"AutoLogin"]);
//        
//    } failure:^(NSError *error) {
//        [MBProgressHUD showError:Localizable(@"注销失败")];
//        [self dismiss];
//        DLog(@"error code = 202");
//    }];
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

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self dismiss];
//}
@end
