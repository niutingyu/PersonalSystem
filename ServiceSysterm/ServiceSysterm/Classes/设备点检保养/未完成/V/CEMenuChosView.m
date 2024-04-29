//
//  CEMenuChosView.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/27.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "CEMenuChosView.h"


@interface CEMenuChosView ()
@property (nonatomic,strong)NSMutableArray * selectedButtons;

@end
@implementation CEMenuChosView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
      
       
        NSArray * titles =@[@"点检列表",@"保养列表",@"点检超时",@"保养超时",@"外包保养"];
        for (int i =0; i<5; i++) {
            UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(2+(kScreenWidth/5)*i, 0, (kScreenWidth-8)/5, 40);
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            btn.backgroundColor =[UIColor whiteColor];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
            btn.titleLabel.font =[UIFont systemFontOfSize:14.0f];
            [btn addTarget:self action:@selector(chosItem:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            if (i == 0) {
                [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }
            [self.selectedButtons addObject:btn];
            [self addSubview:btn];
            UIView * line = [[UIView alloc]init];
            line.frame = CGRectMake((1+kScreenWidth/5)*i, 5, 1, 30);
            line.backgroundColor = RGBA(242, 242, 242, 1);
            [self addSubview:line];
        }
        UIView * bottomView =[[UIView alloc]init];
        bottomView.frame = CGRectMake(2, 39, kScreenWidth-4, 1);
        bottomView.backgroundColor = RGBA(242, 242, 242, 1);
        [self addSubview:bottomView];
    }return self;
}
-(void)chosItem:(UIButton*)sender{
    for (UIButton * btn in self.selectedButtons) {
        if (btn == sender) {
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
    }
    if (self.chosItemBlock) {
        self.chosItemBlock(sender.tag);
    }
}

-(NSMutableArray*)selectedButtons{
    if (!_selectedButtons) {
        _selectedButtons =[NSMutableArray array];
    }return _selectedButtons;
}
@end
