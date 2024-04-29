//
//  UIView+Extension.m
//
//  Created by dengchen on 16/4/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (UIViewController *)myViewController {
    return [self findResponderWithClass:[UIViewController class]];
}

- (void)cornerRadius:(CGFloat)size
{
    if (size == 0) size = self.height * 0.5;
    
    self.layer.cornerRadius = size;
    self.layer.masksToBounds = YES;
    
}

-(void)setRadius:(CGFloat)radius{
    self.layer.cornerRadius=radius;
    self.layer.masksToBounds=YES;
}
-(CGFloat)radius{
    return self.layer.cornerRadius;
}

// 在aclass的所有对象中 找出需要的Responder对象(响应者)
- (id)findResponderWithClass:(Class)aclass  //myHomeVc
{
    //UIResponder对象表示一个可以接收触摸屏上的触摸事件的对象
    UIResponder *nextResponder = self.nextResponder;
    
    while (nextResponder) {
        
        // 如果nextResponder对象的类和aclass 相同
        if ([nextResponder isKindOfClass:aclass]) {
            return nextResponder; // 返回nextResponder对象
        }
        
        nextResponder = nextResponder.nextResponder; 
    }
    return nil;
}

- (UIViewController*)getSuperController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


- (CGFloat)x {
    return self.frame.origin.x;
}
- (CGFloat)y {
    return self.frame.origin.y;
}
- (CGFloat)width {
    return self.frame.size.width;
}
- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setX:(CGFloat)x {
    CGRect newFrame = self.frame;
    newFrame.origin.x = x;
    self.frame = newFrame;
}
- (void)setY:(CGFloat)y {
    CGRect newFrame = self.frame;
    newFrame.origin.y = y;
    self.frame = newFrame;
}
- (void)setWidth:(CGFloat)width {
    CGRect newFrame = self.frame;
    newFrame.size.width = width;
    self.frame = newFrame;
}
- (void)setHeight:(CGFloat)height {
    CGRect newFrame = self.frame;
    newFrame.size.height = height;
    self.frame = newFrame;
}

- (CGFloat)cyf_centerX {
    return self.center.x;
}

- (CGFloat)cyf_centerY {
    return self.center.y;
}


- (void)setCyf_centerX:(CGFloat)cyf_centerX {
    CGPoint center = self.center;
    center.x=cyf_centerX;
    self.center= center;
}

- (void)setCyf_centerY:(CGFloat)cyf_centerY {
    CGPoint center = self.center;
    center.y=cyf_centerY;
    self.center=center;
}


@end
