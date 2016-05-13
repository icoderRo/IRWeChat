//
//  LCSettingAboutUsViewController.m
//  TaiYangHua
//
//  Created by Lc on 16/2/25.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import "LCSettingAboutUsViewController.h"

@interface LCSettingAboutUsViewController ()
@property (weak, nonatomic) UIImageView *logoImageView;
@property (weak, nonatomic) UIButton *versionsButton;
@property (weak, nonatomic) UIButton *updateButton;
@property (weak, nonatomic) UILabel *detailLabel;
@end

@implementation LCSettingAboutUsViewController
- (UIImageView *)logoImageView
{
    if (!_logoImageView) {
        UIImageView *logoImageView = [[UIImageView alloc] init];
        logoImageView.image = [UIImage imageNamed:@"aio_voiceChange_effect_0"];
        _logoImageView = logoImageView;
        [self.view addSubview:_logoImageView];
        
        [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(100);
            make.centerX.equalTo(self.view);
            make.height.equalTo(@(80));
            make.width.equalTo(@(80));
        }];
        
    }
    
    return _logoImageView;
}

- (UIButton *)versionsButton
{
    if (!_versionsButton) {
        UIButton *versionsButton = [[UIButton alloc] init];
        versionsButton.layer.cornerRadius = 5;
        versionsButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        versionsButton.layer.borderWidth = 1;
        [versionsButton setTitle:@"版本号:demo" forState:UIControlStateNormal];
        [versionsButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [versionsButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _versionsButton = versionsButton;
        [self.view addSubview:_versionsButton];
        
        [_versionsButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.logoImageView).offset(120);
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(200));
        }];
    }
    
    return _versionsButton;
}

- (UIButton *)updateButton
{
    if (!_updateButton) {
        UIButton *updateButton = [[UIButton alloc] init];
        updateButton.layer.cornerRadius = 5;
        [updateButton setTitle:@"点击更新" forState:UIControlStateNormal];
        [updateButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [updateButton setBackgroundColor:color227shallblue];
        [updateButton addTarget:self action:@selector(clickUpdateButton) forControlEvents:UIControlEventTouchUpInside];
        _updateButton = updateButton;
        [self.view addSubview:_updateButton];
        
        [_updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.versionsButton).offset(260);
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(200));
        }];
        
    }
    
    return _updateButton;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.text = @"lawCong";
        
        detailLabel.textColor = [UIColor lightGrayColor];
        detailLabel.textAlignment = NSTextAlignmentCenter;
        CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);
        UIFontDescriptor *desc = [ UIFontDescriptor fontDescriptorWithName :[ UIFont boldSystemFontOfSize:20 ]. fontName matrix :matrix];
        UIFont *font = [ UIFont fontWithDescriptor :desc size :20];
        detailLabel.font = font;
        _detailLabel = detailLabel;
        [self.view addSubview:_detailLabel];
        
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.updateButton).offset(60);
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(150));
        }];
    }
    
    return _detailLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"QQ:616619792";
    self.view.backgroundColor = colorf0fGrey;
    
    [self logoImageView];
    [self versionsButton];
    [self updateButton];
    [self detailLabel];
}

- (void)clickUpdateButton
{
    NSString  *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@",@"APPLE_STORE_APP_ID"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
@end
