//
//  LHMainView.h
//  LHAnimationGroupDemo
//
//  Created by bosheng on 16/3/8.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShopCarEventDelegate <NSObject>

- (void)gwcBtnEvent;

@end

@interface LHMainView : UIView

@property (nonatomic,assign)id<ShopCarEventDelegate> delegate;


@end
