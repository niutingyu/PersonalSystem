//
//  DESearchTImeFilterView.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/18.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DESearchTImeFilterView.h"

@implementation DESearchTImeFilterView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[NSString stringWithFormat:@"查询时间:%@",[Units currentTimeWithFormat:@"yyyy-MM-dd"]] forState:UIControlStateNormal];
        btn.titleLabel.font =[UIFont systemFontOfSize:15];
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        btn.layer.borderColor  =[UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth =0.5;
        btn.layer.cornerRadius =3;
        btn.clipsToBounds =YES;
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        _timeButton =btn;
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(8);
            make.top.mas_offset(5);
            make.bottom.mas_offset(-5);
            make.width.mas_equalTo(kScreenWidth/2-16);
        }];
        
        UIButton * factoryBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
        [factoryBtn setTitle:@"请选择工厂" forState:UIControlStateNormal];
        factoryBtn.titleLabel.font  =[UIFont systemFontOfSize:15];
        [factoryBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        factoryBtn.layer.borderWidth =0.5;
        factoryBtn.layer.borderColor =[UIColor lightGrayColor].CGColor;
        factoryBtn.layer.cornerRadius =3;
        factoryBtn.clipsToBounds  =YES;
        [factoryBtn addTarget:self action:@selector(chosFactroy) forControlEvents:UIControlEventTouchUpInside];
        self.FactoryButton =factoryBtn;
        [self addSubview:factoryBtn];
        [factoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kScreenWidth/2-19);
            make.top.mas_offset(5);
            make.bottom.mas_offset(-5);
            make.right.mas_offset(-8);
            
        }];
    }
    
    
    return self;
}
-(void)btnClick{
    if (self.timeFilterBlock) {
        self.timeFilterBlock();
    }
}

-(void)chosFactroy{
    if (self.chosFactoryBlock) {
        self.chosFactoryBlock();
    }
}
@end
