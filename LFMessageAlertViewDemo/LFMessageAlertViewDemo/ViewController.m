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
    [LFMessageAlertView showView:view ShowType:(LFMessageAlertViewShowTop) Duration:5];
}


@end
