//
//  QCCOCCollectionViewCell.m
//  ServiceSysterm
//
//  Created by Andy on 2021/9/29.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "QCCOCCollectionViewCell.h"

@implementation QCCOCCollectionViewCell



-(instancetype)initWithFrame:(CGRect)frame{
    if (self  =[super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.contentView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.contentView.layer.borderWidth = 0.5f;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.contentView.clipsToBounds = YES;
    self.clipsToBounds = YES;
    UILabel *customLabel =[[UILabel alloc]init];
    customLabel.font  =[UIFont systemFontOfSize:16];
    customLabel.textAlignment  =NSTextAlignmentCenter;
    customLabel.numberOfLines  =0;
    customLabel.text  =@"";
    self.customLabel  =customLabel;
    
    [self.contentView addSubview:customLabel];
    [customLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}
-(void)setText:(NSString *)text{
    _text =text;
    self.customLabel.text  =text;
}

-(void)setIsedit:(BOOL)isedit{
    _isedit  =isedit;
    self.customLabel.hidden =isedit;
}
@end
