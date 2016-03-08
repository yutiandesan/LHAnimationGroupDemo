//
//  ViewController.m
//  LHAnimationGroupDemo
//
//  Created by bosheng on 16/3/8.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "ViewController.h"
#import "LHMainView.h"

@interface ViewController ()<ShopCarEventDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    LHMainView * shopCarView = [[LHMainView alloc]initWithFrame:self.view.bounds];
    shopCarView.delegate = self;
    [self.view addSubview:shopCarView];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ShopCarEventDelegate
- (void)gwcBtnEvent
{
    NSLog(@"点击顶部购物车");
}


@end
