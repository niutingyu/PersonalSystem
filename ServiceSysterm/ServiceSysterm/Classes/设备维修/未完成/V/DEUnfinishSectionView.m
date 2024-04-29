//
//  DEUnfinishSectionView.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/17.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEUnfinishSectionView.h"

@interface DEUnfinishSectionView ()
@property (nonatomic,assign)BOOL isSelected;

@end
@implementation DEUnfinishSectionView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
     
        self.backgroundColor = RGBA(99, 165, 255, 1);
        UILabel * titleLab = [[UILabel alloc]init];
        titleLab.font =[UIFont systemFontOfSize:16];
        _titleLab = titleLab;
        titleLab.userInteractionEnabled = YES;
        
        [titleLab sizeToFit];
        [self addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(16);
            make.centerY.mas_equalTo(self);
            make.height.mas_equalTo(18);
        }];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];

    }
    
    return self;
}
-(void)tap:(UIButton*)gesture{
   
    if (self.open_closeBlock) {
        self.open_closeBlock(gesture,self.section);
    }

}

-(void)setSection:(NSInteger)section{
    _section  =section;
}
@end
