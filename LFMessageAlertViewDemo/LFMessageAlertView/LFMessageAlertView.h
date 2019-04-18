//
//  LFMessageAlertView.h
//  LFMessageAlertViewDemo
//
//  Created by souge 3 on 2019/4/18.
//  Copyright © 2019 LiuFei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    LFMessageAlertViewShowTop,
    LFMessageAlertViewShowBottom,
} LFMessageAlertViewShowType;

@interface LFMessageAlertView : UIView

+ (void)showMessage:(NSString *)message StartY:(CGFloat)startY Duration:(CGFloat)duration;

+ (void)showView:(UIView *)showView ShowType:(LFMessageAlertViewShowType)type Duration:(CGFloat)duration;

@end

NS_ASSUME_NONNULL_END
