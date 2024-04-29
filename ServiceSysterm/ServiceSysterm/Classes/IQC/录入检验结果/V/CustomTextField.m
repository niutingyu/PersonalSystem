//
//  CustomTextField.m
//  ServiceSysterm
//
//  Created by Andy on 2021/8/2.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "CustomTextField.h"


@interface CustomTextField ()



@end
@implementation CustomTextField

-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setSubTag:(NSInteger)subTag{
    _subTag =subTag;
    
}

-(void)setTextIndx:(NSIndexPath *)textIndx{
    _textIndx =textIndx;
}



@end
