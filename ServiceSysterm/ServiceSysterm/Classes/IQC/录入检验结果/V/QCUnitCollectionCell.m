//
//  QCUnitCollectionCell.m
//  ServiceSysterm
//
//  Created by Andy on 2021/6/5.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "QCUnitCollectionCell.h"

@implementation QCUnitCollectionCell




-(instancetype)initWithFrame:(CGRect)frame{
    if (self  =[super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}


-(void)setupUI{
    UILabel * label  =[[UILabel alloc]init];
    label.font  =[UIFont systemFontOfSize:17];
    label.text =@"单位";
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(80);
    }];
    
    UITextField * textField  =[[UITextField alloc]init];
    textField.placeholder  =@"请输入单位";
    [self.contentView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_right).mas_offset(5);
        make.top.bottom.mas_offset(0);
        make.right.mas_offset(-16);
    }];
    
}
@end
