//
//  LCNewsCell.m
//  weChat
//
//  Created by Lc on 16/5/6.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCNewsCell.h"
#import "LCNews.h"
#import "LCPhotosView.h"
#define LCNewsCellMargin 10
#import "TTTAttributedLabel.h"
@interface LCNewsCell ()<TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerImageV;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *messageLabel;
@property (weak, nonatomic) IBOutlet LCPhotosView *photosViews;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreTextButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photosViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photosViewTopConstarint;
@end

@implementation LCNewsCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    if (iPhone5 || iPhone4S) {
        self.messageLabel.preferredMaxLayoutWidth = 225;
    } else if(iPhone6s) {
        self.messageLabel.preferredMaxLayoutWidth = 280;
    } else if(iPhone6SP) {
        self.messageLabel.preferredMaxLayoutWidth = 330;
    }
    
    self.messageLabel.delegate = self;
    self.messageLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
}

- (void)setNews:(LCNews *)news
{
    _news = news;
    
    self.headerImageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"aio_voiceChange_effect_%zd", arc4random_uniform(7)]];
    self.messageLabel.text = news.message;
     self.messageLabelHeightConstraint.constant = news.messageHeight;
    self.nickNameLabel.text = [NSString stringWithFormat:@"%@,  文本高度 %.1f", news.nickName, news.messageHeight];
    self.timeLabel.text = news.time;
    self.photosViewHeightConstraint.constant = news.photoHeight;
    self.moreTextButton.hidden = news.isHidden;
    self.moreTextButton.selected = news.isOpened;
   
    
    if (news.images.count) {
        self.photosViews.hidden = NO;
        self.photosViews.photos = news.images;
    } else {
        self.photosViews.hidden = YES;
    }
    
    if (self.moreTextButton.isHidden) {
        self.photosViewTopConstarint.constant = -20;
    } else {
        self.photosViewTopConstarint.constant = 10;
    }
    
}

- (IBAction)moreTextAction:(UIButton *)button
{
    button.selected = !button.isSelected;
    self.news.open = button.isSelected;
    self.news.cellHeight = 0;
    if ([self.delegate respondsToSelector:@selector(newsCell:didClickMoreTextButtonWithIndexPath:)]) {
        [self.delegate newsCell:self didClickMoreTextButtonWithIndexPath:self.indexPath];
    }
}

@end
