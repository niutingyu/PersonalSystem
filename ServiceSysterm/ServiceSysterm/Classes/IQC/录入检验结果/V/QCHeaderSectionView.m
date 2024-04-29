//
//  QCHeaderSectionView.m
//  ServiceSysterm
//
//  Created by Andy on 2021/6/2.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "QCHeaderSectionView.h"

@implementation QCHeaderSectionView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor  =[UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    UILabel * titleLab  =[[UILabel alloc]init];
    titleLab.font  =[UIFont systemFontOfSize:17 weight:1];
    self.titleLab  =titleLab;
    [self addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(kScreenWidth-30);
    }];
}


@end
