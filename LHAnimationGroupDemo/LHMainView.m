//
//  LHMainView.m
//  LHAnimationGroupDemo
//
//  Created by bosheng on 16/3/8.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "LHMainView.h"

#define DeviceMaxHeight ([UIScreen mainScreen].bounds.size.height)
#define DeviceMaxWidth ([UIScreen mainScreen].bounds.size.width)

@interface LHMainView()
{
    UIButton * gwcBtn;
}

@end

@implementation LHMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self firmInit];
    }
    
    return  self;
}

- (void)firmInit
{
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 64)];
    topView.backgroundColor = [UIColor colorWithRed:53.0/255 green:152.0/255 blue:220.0/255 alpha:1];
    [self addSubview:topView];
    
    UIButton * shopCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shopCarBtn.frame = CGRectMake(0, 0, 120, 120);
    shopCarBtn.center = self.center;
    [shopCarBtn setImage:[UIImage imageNamed:@"upimMainGrayShopCar"] forState:UIControlStateNormal];
    [shopCarBtn addTarget:self action:@selector(shopCarButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shopCarBtn];
    
    gwcBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    gwcBtn.frame = CGRectMake(DeviceMaxWidth-62, 22, 60, 44);
    [gwcBtn setBackgroundImage:[UIImage imageNamed:@"maingouwucheicon.png"] forState:UIControlStateNormal];
    [gwcBtn addTarget:self action:@selector(gwcBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:gwcBtn];
}

#pragma mark - 顶部购物车事件
- (void)gwcBtnEvent
{
    if ([self.delegate respondsToSelector:@selector(gwcBtnEvent)]) {
        [self.delegate gwcBtnEvent];
    }
}

#pragma mark - 下方购物车
- (void)shopCarButtonEvent:(UIButton *)button_
{
    CGRect rr = button_.frame;
    rr.size.width = 34;
    rr.size.height = 34;
    rr.origin.x = (DeviceMaxWidth-34)/2;
    rr.origin.y = (DeviceMaxHeight-34)/2;
    [self addToShopCarAnimation:rr];
}

//添加到购物车动画
- (void)addToShopCarAnimation:(CGRect)rect
{
    CGFloat moveD = rect.origin.y - 20;
    
    NSTimeInterval nowTime = [[NSDate date]timeIntervalSince1970]*1000;
    NSInteger imTag = (long)nowTime%(3600000*24);
    UIImageView * sImgView = [[UIImageView alloc]initWithFrame:rect];
    sImgView.tag = imTag;
    sImgView.image = [UIImage imageNamed:@"upimMainGrayShopCar"];
    [self addSubview:sImgView];
    
    //组动画之修改透明度
    CABasicAnimation * alphaBaseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaBaseAnimation.fillMode = kCAFillModeForwards;//不恢复原态
    alphaBaseAnimation.duration = 2.0*moveD/800;
    alphaBaseAnimation.removedOnCompletion = NO;
    [alphaBaseAnimation setToValue:[NSNumber numberWithFloat:0.3]];
    alphaBaseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];//决定动画的变化节奏
    
    //组动画之缩放动画
    CABasicAnimation * scaleBaseAnimation = [CABasicAnimation animation];
    scaleBaseAnimation.removedOnCompletion = NO;
    scaleBaseAnimation.fillMode = kCAFillModeForwards;//不恢复原态
    scaleBaseAnimation.duration = 2.0*moveD/800;
    scaleBaseAnimation.keyPath = @"transform.scale";
    scaleBaseAnimation.toValue = @0.3;
    
    //组动画之路径变化
    CGMutablePathRef path = CGPathCreateMutable();//创建一个路径
    CGPathMoveToPoint(path, NULL, sImgView.center.x, sImgView.center.y);
    //下面8行添加8条直线的路径到path中
    CGPathAddLineToPoint(path,NULL,sImgView.center.x-moveD/10,sImgView.center.y-moveD/8);
    CGPathAddLineToPoint(path,NULL,sImgView.center.x-moveD/20*3,sImgView.center.y-moveD/4);
    CGPathAddLineToPoint(path,NULL,sImgView.center.x-moveD/40*7,sImgView.center.y-moveD/8*3);
    CGPathAddLineToPoint(path,NULL,sImgView.center.x-moveD/80*15,sImgView.center.y-moveD/2);
    CGPathAddLineToPoint(path,NULL,sImgView.center.x-moveD/40*7,sImgView.center.y-moveD/8*5);
    CGPathAddLineToPoint(path,NULL,sImgView.center.x-moveD/20*3,sImgView.center.y-moveD/4*3);
    CGPathAddLineToPoint(path,NULL,sImgView.center.x-moveD/10,sImgView.center.y-moveD/8*7);
    CGPathAddLineToPoint(path,NULL,sImgView.center.x,sImgView.center.y-moveD);
    CGPathAddLineToPoint(path,NULL,gwcBtn.center.x,sImgView.center.y-moveD);
    CAKeyframeAnimation * frameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    frameAnimation.duration = 2.0*moveD/800;
    frameAnimation.removedOnCompletion = NO;
    frameAnimation.fillMode = kCAFillModeForwards;
    [frameAnimation setPath:path];
    CFRelease(path);
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = @[alphaBaseAnimation,scaleBaseAnimation,frameAnimation];
    animGroup.duration = 2.0*moveD/800;
    animGroup.fillMode = kCAFillModeForwards;//不恢复原态
    animGroup.removedOnCompletion = NO;
    [sImgView.layer addAnimation:animGroup forKey:[NSString stringWithFormat:@"%ld",(long)imTag]];
    
    NSDictionary * dic = @{@"animationGroup":sImgView};
    NSTimer * t = [NSTimer scheduledTimerWithTimeInterval:animGroup.duration target:self selector:@selector(removeImgView:) userInfo:dic repeats:NO];
    [[NSRunLoop currentRunLoop]addTimer:t forMode:NSRunLoopCommonModes];
    
}

- (void)removeImgView:(NSTimer *)timer
{
    //    NSLog(@"%@",timer.userInfo);
    UIImageView * imgView = (UIImageView *)[timer.userInfo objectForKey:@"animationGroup"];
    
    if (imgView) {
        [imgView removeFromSuperview];
        imgView = nil;
    }
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
