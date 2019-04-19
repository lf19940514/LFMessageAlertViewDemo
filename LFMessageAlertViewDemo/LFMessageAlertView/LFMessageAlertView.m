//
//  LFMessageAlertView.m
//  LFMessageAlertViewDemo
//
//  Created by souge 3 on 2019/4/18.
//  Copyright © 2019 LiuFei. All rights reserved.
//

#define IS_IPHONEX ([UIScreen mainScreen].bounds.size.height >= 812.0f)
#define kTopSafeHeight (IS_IPHONEX ? 44 : 20)
#define kBottomSafeHeight (IS_IPHONEX ? 34 : 20)
#import "LFMessageAlertView.h"

@interface LFMessageAlertView()

@property (nonatomic, copy)NSString *message;
@property (nonatomic, assign)CGFloat startY;
@property (nonatomic, assign)CGFloat endY;
@property (nonatomic, assign)CGFloat duration;

@property (nonatomic, strong)UILabel *messageLabel;

@property (nonatomic, weak)UIView *showView;
@property (nonatomic, assign)LFMessageAlertViewShowType showType;

@property (nonatomic, copy) void (^tapBlock)(void);

@end

@implementation LFMessageAlertView

+ (void)showMessage:(NSString *)message StartY:(CGFloat)startY EndY:(CGFloat)endY Duration:(CGFloat)duration SettingBlock:(void (^) (LFMessageAlertView *alertView))settingBlock{
    LFMessageAlertView *alertView = [[LFMessageAlertView alloc] init];
    alertView.message = message;
    alertView.startY = startY;
    alertView.endY = endY;
    alertView.duration = duration;
    settingBlock(alertView);
    [alertView showMessageAnimation];
}

+ (void)showView:(UIView *)showView ShowType:(LFMessageAlertViewShowType)type Duration:(CGFloat)duration TapBlock:(void(^)(void))tapBlock{
    LFMessageAlertView *alertView = [[LFMessageAlertView alloc] initWithFrame:showView.bounds];
    alertView.showView = showView;
    alertView.showType = type;
    alertView.duration = duration;
    alertView.tapBlock = ^{
        if (tapBlock) {
            tapBlock();
        }
    };
    
    [alertView showViewSetup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowOpacity = 0.2f;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowRadius = 6.0f;
    self.layer.cornerRadius = 6.0f;
    
}

- (void)setMessage:(NSString *)message {
    _message = message;
    
    _messageLabel = [[UILabel alloc] init];
    [self addSubview:_messageLabel];
    _messageLabel.font = [UIFont boldSystemFontOfSize:17.f];
    _messageLabel.numberOfLines = 0;
    
    _messageLabel.text = message;
    _messageLabel.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-50, 0);
    [_messageLabel sizeToFit];
    
    self.frame = CGRectMake(0, 0, _messageLabel.bounds.size.width+20, _messageLabel.bounds.size.height+20);
    _messageLabel.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
}

- (void)showMessageAnimation {
    self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, self.startY);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.alpha = 0;
    
    [UIView animateWithDuration:0.5 delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        self.alpha = 1;
        self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, self.endY);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:self.duration options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
            self.alpha = 0;
            self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, self.startY);
        } completion:^(BOOL finished) {
            self.messageLabel = nil;
            [self.messageLabel removeFromSuperview];
            [self removeFromSuperview];
        }];
    }];
}


- (void)setShowView:(UIView *)showView {
    _showView = showView;
    self.backgroundColor = showView.backgroundColor;
    showView.backgroundColor = [UIColor clearColor];
    [self addSubview:showView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandle:)];
    pan.delaysTouchesBegan = YES;
    [self addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)];
    [self addGestureRecognizer:tap];
}

- (void)panGestureHandle:(UIPanGestureRecognizer *)panGesture{
    
    CGPoint translation = [panGesture translationInView:self];
    CGPoint newCenter = CGPointMake(self.center.x+ translation.x,
                                    self.center.y + translation.y);
    //    限制屏幕范围：
    if (self.showType==LFMessageAlertViewShowTop) {
        newCenter.y = MIN(self.bounds.size.height/2.0+kTopSafeHeight,  newCenter.y);
    } else {
        newCenter.y = MAX(([UIScreen mainScreen].bounds.size.height-self.bounds.size.height/2.0-kBottomSafeHeight), newCenter.y);
    }
    self.center = CGPointMake(self.center.x, newCenter.y);
    [panGesture setTranslation:CGPointZero inView:self];
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        if (self.center.y < kTopSafeHeight+self.bounds.size.height/10.0 || self.center.y > [UIScreen mainScreen].bounds.size.height-kBottomSafeHeight-self.bounds.size.height/10.0) {
            [self dismissViewAnimation];
        }else{
            [self showViewAnimation];
        }
    }
}

- (void)tapGestureHandle:(UITapGestureRecognizer *)tapGesture {
    if (self.tapBlock) {
        self.tapBlock();
    }
    NSLog(@"点击view");
    [self dismissViewAnimation];
}

- (void)showViewSetup {
    if (self.showType==LFMessageAlertViewShowTop) {
        self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, -self.bounds.size.height/2.0);
    } else {
        self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height+self.bounds.size.height/2.0);
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self showViewAnimation];
}

- (void)showViewAnimation {
    [UIView animateWithDuration:0.3 delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        if (self.showType==LFMessageAlertViewShowTop) {
            self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, self.bounds.size.height/2.0+kTopSafeHeight);
        } else {
            self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height-self.bounds.size.height/2.0-kBottomSafeHeight);
        }
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewAnimation];
        });
    }];
}

- (void)dismissViewAnimation {
    [UIView animateWithDuration:0.3 delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        if (self.showType==LFMessageAlertViewShowTop) {
            self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, -self.bounds.size.height/2.0);
        } else {
            self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height+self.bounds.size.height/2.0);
        }
    } completion:^(BOOL finished) {
        [self.showView removeFromSuperview];
        [self removeFromSuperview];
    }];
}


- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    _messageLabel.font = textFont;
    
    _messageLabel.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-50, 0);
    [_messageLabel sizeToFit];
    
    self.frame = CGRectMake(0, 0, _messageLabel.bounds.size.width+20, _messageLabel.bounds.size.height+20);
    _messageLabel.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
}
- (void)setBackColor:(UIColor *)backColor {
    _backColor = backColor;
    self.backgroundColor = backColor;
}
- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    _messageLabel.textColor = textColor;
}
- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.layer.shadowRadius = cornerRadius;
}

@end
