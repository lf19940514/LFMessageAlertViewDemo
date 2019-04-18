//
//  LFMessageAlertView.m
//  LFMessageAlertViewDemo
//
//  Created by souge 3 on 2019/4/18.
//  Copyright © 2019 LiuFei. All rights reserved.
//

#define IS_IPHONEX ([UIScreen mainScreen].bounds.size.height >= 812.0f)
#define kTopSafeHeight (IS_IPHONEX ? 44 : 0)
#define kBottomSafeHeight (IS_IPHONEX ? 34 : 0)
#import "LFMessageAlertView.h"

@interface LFMessageAlertView()<UIGestureRecognizerDelegate>

@property (nonatomic, copy)NSString *message;
@property (nonatomic, assign)CGFloat startY;
@property (nonatomic, assign)CGFloat duration;

@property (nonatomic, strong)UILabel *messageLabel;

@property (nonatomic, weak)UIView *showView;
@property (nonatomic, assign)LFMessageAlertViewShowType showType;

@end

@implementation LFMessageAlertView

+ (void)showMessage:(NSString *)message StartY:(CGFloat)startY Duration:(CGFloat)duration {
    LFMessageAlertView *alertView = [[LFMessageAlertView alloc] init];
    alertView.message = message;
    alertView.startY = startY;
    alertView.duration = duration;
    [alertView showMessageAnimation];
}

+ (void)showView:(UIView *)showView ShowType:(LFMessageAlertViewShowType)type Duration:(CGFloat)duration {
    LFMessageAlertView *alertView = [[LFMessageAlertView alloc] initWithFrame:showView.bounds];
    alertView.showView = showView;
    alertView.showType = type;
    alertView.duration = duration;
    [alertView showViewAnimation];
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
    
    UILabel *label = [[UILabel alloc] init];
    [self addSubview:label];
    label.font = [UIFont boldSystemFontOfSize:17.f];
    label.numberOfLines = 0;
    _messageLabel = label;
    
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
        if (self.startY >= ([UIScreen mainScreen].bounds.size.height/2.0)) {
            self.transform = CGAffineTransformMakeTranslation(0, -self.bounds.size.height);
        } else {
            self.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:self.duration options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
            self.alpha = 0;
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
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
    pan.delegate = self;
    [self addGestureRecognizer:pan];
}

- (void)panGestureHandle:(UIPanGestureRecognizer *)panGesture{
    
    CGPoint translation = [panGesture translationInView:self];
    CGPoint newCenter = CGPointMake(self.center.x+ translation.x,
                                    self.center.y + translation.y);
    //    限制屏幕范围：
    if (self.showType==LFMessageAlertViewShowTop) {
        newCenter.y = MIN(-self.bounds.size.height/2.0,  newCenter.y);
    } else {
        newCenter.y = MAX(([UIScreen mainScreen].bounds.size.height+self.bounds.size.height/2.0), newCenter.y);
    }
    self.center = CGPointMake(self.center.x, newCenter.y);
    [panGesture setTranslation:CGPointZero inView:self];
    
    
}


- (void)showViewAnimation {
    if (self.showType==LFMessageAlertViewShowTop) {
        self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, -self.bounds.size.height/2.0);
    } else {
        self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height+self.bounds.size.height/2.0);
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.5 delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        if (self.showType==LFMessageAlertViewShowTop) {
            self.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height+kTopSafeHeight+20);
        } else {
            self.transform = CGAffineTransformMakeTranslation(0, -(self.bounds.size.height+kBottomSafeHeight+20));
        }
    } completion:^(BOOL finished) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self dismissViewAnimation];
//        });
    }];
}

- (void)dismissViewAnimation {
    [UIView animateWithDuration:0.5 delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
