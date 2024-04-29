//
//  AppranceAlertReusableView.m
//  ServiceSysterm
//
//  Created by Andy on 2021/7/23.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "AppranceAlertReusableView.h"

@implementation AppranceAlertReusableView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self  =[super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.backgroundColor  =RGBA(242, 242, 242, 1);
    UIView * topLine  =[[UIView alloc]init];
    topLine.backgroundColor  =[UIColor darkGrayColor];
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(1);
        make.top.mas_offset(0);
        make.right.mas_offset(-1);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView * botomView  =[[UIView alloc]init];
    botomView.backgroundColor  =[UIColor darkGrayColor];
    [self addSubview:botomView];
    [botomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(1);
        make.right.mas_offset(-1);
        make.bottom.mas_offset(0);
        make.height.mas_equalTo(0.5);
    }];
    UILabel * titleLab  =[[UILabel alloc]init];
    titleLab.font  =[UIFont systemFontOfSize:17];
    [titleLab sizeToFit];
    self.titleLab  =titleLab;
    [self addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(21);
    }];
}

-(void)setFrame:(CGRect)frame{
    frame.origin.x += 3;
    frame.size.width -=6;
    [super setFrame:frame];
}
@end
