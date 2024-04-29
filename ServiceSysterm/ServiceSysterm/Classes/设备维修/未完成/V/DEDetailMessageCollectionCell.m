//
//  DEDetailMessageCollectionCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/6/14.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEDetailMessageCollectionCell.h"

@implementation DEDetailMessageCollectionCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        [self setupLabel];
    }return self;
}
-(void)setupLabel{
    UILabel * titleLab =[[UILabel alloc]init];
    titleLab.textAlignment =NSTextAlignmentCenter;
    titleLab.font =[UIFont systemFontOfSize:15];
    titleLab.backgroundColor = RGBA(245, 245, 245, 1);
    self.titleLabel = titleLab;
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.centerY .mas_equalTo(self.contentView);
        make.top.mas_offset(8);
        make.left.mas_offset(8);
        make.right.mas_offset(8);
        make.bottom.mas_offset(8);
       // make.height.mas_equalTo(30);
        
    }];
}
@end
