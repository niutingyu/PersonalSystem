//
//  CustomRectLabel.m
//  ServiceSysterm
//
//  Created by Andy on 2021/7/10.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "CustomRectLabel.h"

@interface CustomRectLabel ()




@end

@implementation CustomRectLabel


- (instancetype)init {
    if (self = [super init]) {
        _textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}

@end
