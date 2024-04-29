//
//  MainHeadReusableView.m
//  ServiceSysterm
//
//  Created by Andy on 2019/7/18.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "MainHeadReusableView.h"

@implementation MainHeadReusableView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
       // self.backgroundColor = RGBA(242, 242, 242, 1);
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }return self;
}

-(void)setupUI{
    UILabel * titleLab = [[UILabel alloc]init];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:17 weight:0.5];
    titleLab.text =@"维修";
    [titleLab sizeToFit];
    [self addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(12);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(18);
    }];
}
@end
