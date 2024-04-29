//
//  UIView+Extension.h
//
//  Created by dengchen on 16/4/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (Extension)

- (UIViewController *)myViewController;

- (void)cornerRadius:(CGFloat)size;

- (id)findResponderWithClass:(Class)aclass;

- (UIViewController*)getSuperController;
@property (nonatomic, assign) CGFloat radius;

- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)width;
- (CGFloat)height;

@property(assign,nonatomic) CGFloat cyf_centerX;
@property(assign,nonatomic) CGFloat cyf_centerY;


- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;

@end
