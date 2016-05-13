//
//  LCSettingPasswordChangeView.m
//  TaiYangHua
//
//  Created by Lc on 15/12/28.
//  Copyright © 2015年 hhly. All rights reserved.
//

#import "LCSettingPasswordChangeView.h"


@interface LCSettingPasswordChangeView ()
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *newlyPwdTextField;

@property (weak, nonatomic) IBOutlet UITextField *sureNewlyPwdTextField;
@property (weak, nonatomic) IBOutlet UIView *translateView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *translateBottomConstrain;
@property (weak, nonatomic) IBOutlet UISwitch *oldPwdSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *newlyPwdSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *sureNewlySwitch;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end

@implementation LCSettingPasswordChangeView

#pragma mark - monitor & Cache
- (IBAction)sureBtnClick:(UIButton *)sender {
    
//    if (   ([self.oldPwdTextField.text isEqualToString:@""] || [self.oldPwdTextField.text length]==0 )
//        || ([self.newlyPwdTextField.text isEqualToString:@""] || [self.newlyPwdTextField.text length]==0)
//        || ([self.sureNewlyPwdTextField.text isEqualToString:@""] || [self.sureNewlyPwdTextField.text length]==0)) {
//        
//        [SVProgressHUD showInfoWithStatus:@"请输入密码")];
//        return;
//    }
//    
//    if (![self.oldPwdTextField.text isEqualToString:[AuthModel sharedInstance].password]) {
//        DLog(@"%@", [AuthModel sharedInstance].password);
//        [SVProgressHUD showErrorWithStatus:@"原密码错误")];
//        return;
//    }
//    
//    NSString *regular = @"^[a-zA-Z0-9_]{6,20}$";
//     NSPredicate *regularPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
//   if([regularPredicate evaluateWithObject:self.newlyPwdTextField.text] == NO ||
//      [regularPredicate evaluateWithObject:self.sureNewlyPwdTextField.text] == NO) {
//       
//       [SVProgressHUD showErrorWithStatus:@"规则:6-20位英文字母、数字或下划线")];
//       return;
//    }
//    
//    if (![self.newlyPwdTextField.text isEqualToString:self.sureNewlyPwdTextField.text]) {
//        [SVProgressHUD showInfoWithStatus:@"输入密码不一致")];
//        return;
//    }
//    
//    
//
//    NSString *pwdChangeUrl = [NSString stringWithFormat:@"%@%@",kLCAppServerURL,kresetPassword];
//    NSDictionary *dict = @{
//                           @"companyCode": [AuthModel sharedInstance].companyCode,
//                           @"userId":[AuthModel sharedInstance].userInfo.userId,
//                           @"token" : [AuthModel sharedInstance].token,
//                           @"oldPassword": self.oldPwdTextField.text.md5String,
//                           @"password": self.newlyPwdTextField.text.md5String
//                           };
//    
//    [[NetworkTools shareNetworkTools] settingControlPostWithURL:pwdChangeUrl params:dict success:^(id json) {
//        DLog(@"%@", json);
//        if ([json[@"result"] intValue] == 1) {
//            [SVProgressHUD showSuccessWithStatus:@"更换密码成功")];
//        } else {
//            [SVProgressHUD showErrorWithStatus:@"更换密码失败")];
//        }
//        [self endEditing:YES];
//        [self dismiss];
//    } failure:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"更换密码失败")];
//         DLog(@"error code = 201");
//    }];
}

- (IBAction)cancelBtnClick:(UIButton *)sender {
    
    [self endEditing:YES];
    [self dismiss];
}

- (IBAction)oldPwdSwitch:(UISwitch *)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:[NSString stringWithFormat:@"%@", @(sender.tag)]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.oldPwdTextField.secureTextEntry = sender.isOn ? NO : YES;
    [self.oldPwdTextField becomeFirstResponder];
}

- (IBAction)newlyPwdSwitch:(UISwitch *)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:[NSString stringWithFormat:@"%@", @(sender.tag)]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.newlyPwdTextField.secureTextEntry = sender.isOn ? NO : YES;
    [self.newlyPwdTextField becomeFirstResponder];
}

- (IBAction)sureNewlyPwdSwitch:(UISwitch *)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:[NSString stringWithFormat:@"%@", @(sender.tag)]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.sureNewlyPwdTextField.secureTextEntry = sender.isOn ? NO : YES;
    [self.sureNewlyPwdTextField becomeFirstResponder];
    
}

#pragma mark - init
- (void)awakeFromNib {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardwillHideChangeFrame:) name:UIKeyboardWillHideNotification object:nil];
    });
    
    self.translateView.translatesAutoresizingMaskIntoConstraints = NO;
    self.translateBottomConstrain.constant = -self.translateView.height;
    
    [self setUpSwitchStatus];
    [self setUpData];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUpData
{
    self.oldPwdTextField.placeholder = @"旧密码";
    self.newlyPwdTextField.placeholder = @"新密码";
    self.sureNewlyPwdTextField.placeholder = @"确认新密码";
    [self.sureBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [self.cancelBtn setTitle:@"取消修改" forState:UIControlStateNormal];
}

- (void)setUpSwitchStatus
{
    self.oldPwdSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@",@(self.oldPwdSwitch.tag)]];
    self.oldPwdTextField.secureTextEntry = self.oldPwdSwitch.on ? NO : YES;
    self.newlyPwdSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@",@(self.newlyPwdSwitch.tag)]];
    self.newlyPwdTextField.secureTextEntry =  self.newlyPwdSwitch.on ? NO : YES;
    self.sureNewlySwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@",@(self.sureNewlySwitch.tag)]];
    self.sureNewlyPwdTextField.secureTextEntry = self.sureNewlySwitch.on ? NO : YES;
}

#pragma mark - changeFrame
- (void)keyboardWillShowChangeFrame:(NSNotification *)note
{
    CGRect keyBoardRect = [note.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    NSTimeInterval duration = [note.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:duration animations:^{
            _translateView.transform = CGAffineTransformMakeTranslation(0,-self.translateView.height - keyBoardRect.size.height);
        }];
    });

}

- (void)keyboardwillHideChangeFrame:(NSNotification *)note
{
    NSTimeInterval duration = [note.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:duration animations:^{
            _translateView.transform = CGAffineTransformMakeTranslation(0,-self.translateView.height);
        }];
    });
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:.3 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            _translateView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (UIView *view in self.translateView.subviews) {
        view.layer.cornerRadius = 10;
        view.layer.borderWidth = 0.1;
//        view.layer.borderColor = XWColor(220, 220, 220).CGColor;
    }
}
@end
