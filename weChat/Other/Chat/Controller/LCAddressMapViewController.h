//
//  LCAddressMapViewController.h
//  weChat
//
//  Created by Lc on 16/4/19.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCAddressMapViewController;
@protocol LCAddressMapViewControllerDelegate <NSObject>

@required
- (void)addressMapViewController:(LCAddressMapViewController *)ddressMapViewController didClickSenderWithMapView:(UIImage *)MapView locationName:(NSString *)locationName;
@end
@interface LCAddressMapViewController :UIViewController
@property (weak, nonatomic) id<LCAddressMapViewControllerDelegate>  delegate;
@end
