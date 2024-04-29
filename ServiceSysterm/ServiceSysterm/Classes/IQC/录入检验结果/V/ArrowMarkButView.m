//
//  ArrowMarkButView.m
//  ServiceSysterm
//
//  Created by Andy on 2021/6/5.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "ArrowMarkButView.h"

@implementation ArrowMarkButView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self  =[super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    _mainBut  =[UIButton buttonWithType:UIButtonTypeCustom];
    [_mainBut addTarget:self action:@selector(butMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_mainBut];
    [_mainBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_offset(0);
        make.right.mas_offset(-14);
    }];
    UIImageView * arrowMark  =[[UIImageView alloc]init];
    arrowMark.image  =[UIImage  imageNamed:@"ios-arrow-down"];
    self.arrowMark  = arrowMark;
    [self addSubview:arrowMark];
    [arrowMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(0);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
}

-(void)butMethod:(UIButton*)sender{
    if (self.buttonBlock) {
        self.buttonBlock(sender.tag);
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.arrowMark.transform  =  CGAffineTransformMakeRotation(M_PI);
    }];
    
}
@end
