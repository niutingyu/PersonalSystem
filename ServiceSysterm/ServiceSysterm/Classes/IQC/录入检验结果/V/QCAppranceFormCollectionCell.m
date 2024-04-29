//
//  QCAppranceFormCollectionCell.m
//  ServiceSysterm
//
//  Created by Andy on 2021/7/26.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "QCAppranceFormCollectionCell.h"


@interface QCAppranceFormCollectionCell ()

@property (nonatomic,strong)CustomRectLabel * titleLab;


@end
@implementation QCAppranceFormCollectionCell


-(instancetype)initWithFrame:(CGRect)frame{
    if (self  =[super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.contentView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.contentView.layer.borderWidth = 0.5f;
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.contentView.clipsToBounds = YES;
    self.clipsToBounds = YES;
    
    CustomRectLabel * titleLab  =[[CustomRectLabel alloc]init];
    titleLab.font  =[UIFont systemFontOfSize:16];
    titleLab.textAlignment  =NSTextAlignmentCenter;
   // titleLab.textColor  =[UIColor blackColor];
    titleLab.text  =@"";
    titleLab.numberOfLines  =0;
    self.titleLab  =titleLab;
    
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.top.mas_offset(0);
        make.bottom.mas_offset(0);
        make.right.mas_offset(0);
    }];
}

-(void)setText:(NSString *)text{
    _text  =text;
    self.titleLab.text  =text?:@"";
}

-(void)setLabelColor:(UIColor *)labelColor{
    _labelColor =labelColor;
    self.titleLab.backgroundColor  = labelColor;
}
@end
