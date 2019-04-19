//
//  ViewController.m
//  LFMessageAlertViewDemo
//
//  Created by souge 3 on 2019/4/18.
//  Copyright © 2019 LiuFei. All rights reserved.
//

#import "ViewController.h"
#import "LFMessageAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [LFMessageAlertView showMessage:@"测试信息测试信息" StartY:self.view.bounds.size.height-40 Duration:1];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-40, 100)];
    view.backgroundColor = [UIColor redColor];
    [LFMessageAlertView showView:view ShowType:(LFMessageAlertViewShowBottom) Duration:3 TapBlock:^{
        self.view.backgroundColor = [self RandomColor];
    }];
    [LFMessageAlertView showMessage:@"测试信息" StartY:44 EndY:84 Duration:1 SettingBlock:^(LFMessageAlertView *alertView) {
        alertView.textColor = [UIColor redColor];
    }];
}

- (UIColor *)RandomColor {
    NSInteger aRedValue = arc4random() % 255;
    NSInteger aGreenValue = arc4random() % 255;
    NSInteger aBlueValue = arc4random() % 255;
    UIColor *randColor = [UIColor colorWithRed:aRedValue / 255.0f green:aGreenValue / 255.0f blue:aBlueValue / 255.0f alpha:1.0f];
    return randColor;
}

@end
