//
//  GarbageFootAddView.m
//  ServiceSysterm
//
//  Created by Andy on 2021/8/19.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "GarbageFootAddView.h"

@implementation GarbageFootAddView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self  =[super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    UIButton * mSender  =[UIButton buttonWithType:UIButtonTypeCustom];
    mSender.frame = CGRectMake(8, 7, kScreenWidth-16, 46);
    [mSender setTitle:@"添加物品" forState:UIControlStateNormal];
    [mSender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mSender addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    //self.mSender =mSender;
    
    [self addSubview:mSender];
   
    
    CAShapeLayer *border = [CAShapeLayer layer];
      
      //虚线的颜色
      border.strokeColor = [UIColor blueColor].CGColor;
      //填充的颜色
      border.fillColor = [UIColor clearColor].CGColor;
      
      //设置路径
      border.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, kScreenWidth-16, 46)].CGPath;
      
      border.frame =CGRectMake(0, 0, kScreenWidth-16, 46);
      //虚线的宽度
      border.lineWidth = 1.f;
      
      
      //设置线条的样式
      //    border.lineCap = @"square";
      //虚线的间隔
      border.lineDashPattern = @[@4, @2];
    
      [mSender.layer addSublayer:border];
}

-(void)add{
    if (self.addBlock) {
        self.addBlock();
    }
}
@end
