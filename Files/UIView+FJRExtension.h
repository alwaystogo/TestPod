
//  UIViewCategary
//
//  Created by yunfei.yang on 2018/10/9.
//  Copyright © 2018年 yunfei.yang. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIView (FJRExtension)

@property (nonatomic, assign) CGFloat fjr_x;
@property (nonatomic, assign) CGFloat fjr_y;
@property (nonatomic, assign) CGFloat fjr_centerX;
@property (nonatomic, assign) CGFloat fjr_centerY;
@property (nonatomic, assign) CGFloat fjr_width;
@property (nonatomic, assign) CGFloat fjr_height;
@property (nonatomic, assign) CGSize  fjr_size;

- (UIImage *)fjr_snapshotImage;

+ (CGFloat)fjr_viewWPercent;

/**
 Remove all subviews.
 
 @warning Never call this method inside your view's drawRect: method.
 */
- (void)fjr_removeAllSubviews;

- (void)fjr_removeAllGestureRecognizers;


@end
