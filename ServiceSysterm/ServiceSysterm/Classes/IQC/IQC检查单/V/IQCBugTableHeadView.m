//
//  IQCBugTableHeadView.m
//  ServiceSysterm
//
//  Created by Andy on 2021/7/10.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "IQCBugTableHeadView.h"

@implementation IQCBugTableHeadView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}


-(void)setupUI{
    UIView * bottomView  =[[UIView alloc]init];
    bottomView.backgroundColor  = RGBA(234, 234, 234, 1);
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_offset(1);
        make.right.mas_offset(-1);
    }];
    
    UIView * topLine  =[[UIView alloc]init];
    topLine.backgroundColor  =[UIColor darkGrayColor];
    [bottomView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.top.mas_offset(0);
        make.right.mas_offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    
    UIView * line0 =[[UIView alloc]init];
    line0.backgroundColor  =[UIColor darkGrayColor];
    [bottomView addSubview:line0];
    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);
    }];
    CGFloat cellWidth  = (kScreenWidth-36-2)/4;
    //标号
    
    UIView * line1  =[[UIView alloc]init];
    line1.backgroundColor  = [UIColor darkGrayColor];
    [bottomView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(36);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);
    }];
    
    //处理方式
    UIView * line2  =[[UIView alloc]init];
    line2.backgroundColor  =[UIColor darkGrayColor];
    [bottomView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line1.mas_right).mas_offset(cellWidth);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);
    }];
    
    UILabel * methodLab  =[[UILabel alloc]init];
    methodLab.font  =[UIFont systemFontOfSize:16 weight:0.5];
    methodLab.text =@"处理方式";
    methodLab.textAlignment  =NSTextAlignmentCenter;
    [bottomView addSubview:methodLab];
    [methodLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line1.mas_right).mas_offset(2);
        make.top.mas_offset(8);
        make.bottom.mas_offset(-8);
        make.right.mas_equalTo(line2.mas_left).mas_offset(-2);
    }];
    
    //数量
    UIView * line3  =[[UIView alloc]init];
    line3.backgroundColor  =[UIColor darkGrayColor];
    [bottomView addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line2.mas_right).mas_offset(cellWidth);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);
    }];
    
    UILabel * countLab  =[[UILabel alloc]init];
    countLab.text  =@"数量";
    countLab.textAlignment  =NSTextAlignmentCenter;
    countLab.font  =[UIFont systemFontOfSize:16 weight:0.5];
    [bottomView addSubview:countLab];
    [countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line2.mas_right).mas_offset(2);
        make.top.mas_offset(8);
        make.bottom.mas_offset(-8);
        make.right.mas_equalTo(line3.mas_left).mas_offset(-2);
    }];
    
    //缺陷代码
    UIView * line4  =[[UIView alloc]init];
    line4.backgroundColor =[UIColor darkGrayColor];
    [bottomView addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line3.mas_right).mas_offset(cellWidth);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);
    }];
    UILabel * bugCodeLab  =[[UILabel alloc]init];
    bugCodeLab.text =@"缺陷代码";
    bugCodeLab.font  =[UIFont systemFontOfSize:16 weight:0.5];
    bugCodeLab.textAlignment =NSTextAlignmentCenter;
    [bottomView addSubview:bugCodeLab];
    [bugCodeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line3.mas_right).mas_offset(2);
        make.top.mas_offset(8);
        make.bottom.mas_offset(-8);
        make.right.mas_equalTo(line4.mas_left).mas_offset(-2);
    }];
    
    //缺陷名称
    UIView * line5  =[[UIView alloc]init];
    line5.backgroundColor =[UIColor darkGrayColor];
    [bottomView addSubview:line5];
    [line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-1);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(0.5);
    }];
    
    UILabel * bugNameLab  =[[UILabel alloc]init];
    bugNameLab.text  =@"缺陷名称";
    bugNameLab.font  =[UIFont systemFontOfSize:16 weight:0.5];
    bugNameLab.textAlignment  =NSTextAlignmentCenter;
    [bottomView addSubview:bugNameLab];
    [bugNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line4.mas_right).mas_offset(2);
        make.top.mas_offset(8);
        make.bottom.mas_offset(-8);
        make.right.mas_equalTo(line5.mas_left).mas_offset(-2);
    }];
    
    UIView * verticalLine  =[[UIView alloc]init];
    verticalLine.backgroundColor  =[UIColor darkGrayColor];
    [bottomView addSubview:verticalLine];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(1);
        make.right.mas_offset(-1);
        make.bottom.mas_offset(0);
        make.height.mas_equalTo(0.5);
    }];
}




-(void)setFrame:(CGRect)frame{
    
    frame.origin.x +=2;
    frame.size.width  -=4;
    [super setFrame:frame];
}
@end
