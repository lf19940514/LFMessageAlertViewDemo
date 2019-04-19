//
//  LFMessageAlertView.h
//  LFMessageAlertViewDemo
//
//  Created by souge 3 on 2019/4/18.
//  Copyright © 2019 LiuFei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LFMessageAlertViewShowTop,
    LFMessageAlertViewShowBottom,
} LFMessageAlertViewShowType;

@interface LFMessageAlertView : UIView
/**
 消息弹窗

 @param message 消息内容
 @param startY 初始位置
 @param endY 展示位置(不可超出屏幕，不然看不到)
 @param duration 展示时长
 @param settingBlock 弹窗设置
 */
+ (void)showMessage:(NSString *_Nonnull)message StartY:(CGFloat)startY EndY:(CGFloat)endY Duration:(CGFloat)duration SettingBlock:(void (^_Nullable) (LFMessageAlertView * _Nullable alertView))settingBlock;

/**
 视图弹窗

 @param showView 内容视图
 @param type 弹出位置(顶部，底部)
 @param duration 展示时长
 @param tapBlock 点击回调
 */
+ (void)showView:(UIView *_Nonnull)showView ShowType:(LFMessageAlertViewShowType)type Duration:(CGFloat)duration TapBlock:(void(^_Nullable)(void))tapBlock;

// 消息弹窗可设置属性
@property (nonatomic, strong)UIColor * _Nullable backColor;//弹窗背景色
@property (nonatomic, strong)UIColor * _Nullable textColor;//字体颜色
@property (nonatomic, strong)UIFont * _Nullable textFont;//字体
@property (nonatomic, assign)CGFloat cornerRadius;//弹窗圆角

@end
