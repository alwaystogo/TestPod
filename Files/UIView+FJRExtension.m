
//  UIViewCategary
//
//  Created by yunfei.yang on 2018/10/9.
//  Copyright © 2018年 yunfei.yang. All rights reserved.
//

#import "UIView+FJRExtension.h"
#import <QuartzCore/QuartzCore.h>

//屏幕宽高
#define oScreenWide 375.0
#define oScreenHigh 667.0
//设计宽高
#define oViewWide [UIScreen mainScreen].bounds.size.width
#define oViewHigh [UIScreen mainScreen].bounds.size.height

#define vBottomMargen  12.5

@interface UIView()

@property (nonatomic, weak) UIActivityIndicatorView *fjr_activityIndicator;

@end

@implementation UIView (FJRExtension)

+ (CGFloat)fjr_viewWPercent
{
    CGFloat viewH = oViewHigh * [UIScreen mainScreen].bounds.size.height / oScreenHigh;
    CGFloat viewW = oViewWide * viewH / oViewHigh;
    CGFloat viewWPercent = viewW / oViewWide;
    
    CGFloat viewW2 = oViewWide * [UIScreen mainScreen].bounds.size.width / oScreenWide;
    CGFloat viewH2 = oViewHigh * viewW2 / oViewWide;
    CGFloat viewWPercent2 = viewW2 / oViewWide;
    
    if ((viewWPercent - viewWPercent2) > 0) {
        viewH = viewH2;
        viewW = viewW2;
        viewWPercent = viewWPercent2;
    }
    return viewWPercent;
}

- (void)setFjr_x:(CGFloat)fjr_x
{
    CGRect frame = self.frame;
    frame.origin.x = fjr_x;
    self.frame = frame;
}

- (CGFloat)fjr_x
{
    return self.frame.origin.x;
}

- (void)setFjr_y:(CGFloat)fjr_y
{
    CGRect frame = self.frame;
    frame.origin.y = fjr_y;
    self.frame = frame;
}

- (CGFloat)fjr_y
{
    return self.frame.origin.y;
}

- (void)setFjr_centerX:(CGFloat)fjr_centerX
{
    CGPoint center = self.center;
    center.x = fjr_centerX;
    self.center = center;
}

- (CGFloat)fjr_centerX
{
    return self.center.x;
}

- (void)setFjr_centerY:(CGFloat)fjr_centerY
{
    CGPoint center = self.center;
    center.y = fjr_centerY;
    self.center = center;
}

- (CGFloat)fjr_centerY
{
    return self.center.y;
}

- (void)setFjr_width:(CGFloat)fjr_width
{
    CGRect frame = self.frame;
    frame.size.width = fjr_width;
    self.frame = frame;
}

- (CGFloat)fjr_width
{
    return self.frame.size.width;
}

- (void)setFjr_height:(CGFloat)fjr_height
{
    CGRect frame = self.frame;
    frame.size.height = fjr_height;
    self.frame = frame;
}

- (CGFloat)fjr_height
{
    return self.frame.size.height;
}

- (void)setFjr_size:(CGSize)fjr_size
{
    //    self.width = size.width;
    //    self.height = size.height;
    CGRect frame = self.frame;
    frame.size = fjr_size;
    self.frame = frame;
}

- (CGSize)fjr_size
{
    return self.frame.size;
}

#pragma mark -
- (UIImage *)fjr_snapshotImage{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (UIImage *)fjr_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates{
    if (![self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        return [self fjr_snapshotImage];
    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (NSData *)fjr_snapshotPDF{
    CGRect bounds = self.bounds;
    //result data
    NSMutableData *data = [NSMutableData data];
    CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)data);
    CGContextRef context = CGPDFContextCreate(consumer, &bounds, NULL);
    CGDataConsumerRelease(consumer);
    if (!context) {
        return nil;
    }
    CGPDFContextBeginPage(context, NULL);
    CGContextTranslateCTM(context, 0, bounds.size.height);//y轴向上平移
    CGContextScaleCTM(context, 1.0, -1.0);//y轴翻转，坐标系平移结束UIKit坐标系
    [self.layer renderInContext:context];
    CGPDFContextEndPage(context);
    CGPDFContextClose(context);
    CGContextRelease(context);
    return data;
}

- (void)fjr_setLayerShadow:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius{
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = 1;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)fjr_removeAllSubviews{
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

- (void)fjr_removeAllGestureRecognizers{
    while (self.gestureRecognizers.count) {
        [self removeGestureRecognizer:self.gestureRecognizers.lastObject];
    }
}

- (CGFloat)fjr_visibleAlpha{
    if ([self isKindOfClass:[UIWindow class]]) {
        if (self.hidden) {
            return 0;
        }
        return self.alpha;
    }
    if (!self.window) {
        return 0;
    }
    CGFloat alpha = 1;
    UIView *v = self;
    while (v) {
        if (v.hidden) {
            alpha = 0;
            break;
        }
        alpha *= v.alpha;
        v = v.superview;
    }
    return alpha;
}

- (CGPoint)fjr_convertPoint:(CGPoint)point toViewOrWindow:(UIView *)view{
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertPoint:point toWindow:nil];
        }else{
            return [self convertPoint:point toView:nil];
        }
    }
    
    UIWindow *from = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    if ((!from || !to) ||
        (from == to)) {
        return [self convertPoint:point toView:view];
    }
    point = [self convertPoint:point toView:from];
    point = [to convertPoint:point fromWindow:from];
    point = [view convertPoint:point toView:to];
    return point;
}

- (CGPoint)fjr_convertPoint:(CGPoint)point fromViewOrWindow:(UIView *)view{
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertPoint:point fromWindow:nil];
        }else{
            return [self convertPoint:point fromView:nil];
        }
    }
    
    UIWindow *from = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    UIWindow *to = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    if ((!from || !to) || (from == to)) return [self convertPoint:point fromView:view];
    point = [from convertPoint:point fromView:view];
    point = [to convertPoint:point fromWindow:from];
    point = [self convertPoint:point fromView:to];
    return point;
}

- (CGRect)fjr_convertRect:(CGRect)rect fromViewOrWindow:(UIView *)view{
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertRect:rect fromWindow:nil];
        }else{
            return [self convertRect:rect fromView:nil];
        }
    }
    
    UIWindow *from = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    UIWindow *to = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    if ((!from || !to) ||
        (from == to)) {
        return [self convertRect:rect fromView:view];
    }
    rect = [from convertRect:rect fromView:view];
    rect = [to convertRect:rect fromWindow:from];
    rect = [self convertRect:rect fromView:to];
    return rect;
}

- (CGRect)fjr_convertRect:(CGRect)rect toViewOrWindow:(UIView *)view{
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertRect:rect toWindow:nil];
        } else {
            return [self convertRect:rect toView:nil];
        }
    }
    
    UIWindow *from = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    if (!from || !to) return [self convertRect:rect toView:view];
    if (from == to) return [self convertRect:rect toView:view];
    rect = [self convertRect:rect toView:from];
    rect = [to convertRect:rect fromWindow:from];
    rect = [view convertRect:rect fromView:to];
    return rect;
}

@end
