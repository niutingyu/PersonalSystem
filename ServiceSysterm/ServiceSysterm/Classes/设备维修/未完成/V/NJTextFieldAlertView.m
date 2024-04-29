//
//  NJTextFieldAlertView.m
//  ServiceSysterm
//
//  Created by Andy on 2021/10/8.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "NJTextFieldAlertView.h"
#import "AssetConst.h"
@implementation NJTextFieldAlertView



-(instancetype)initWithtextfieldBlock:(textfieldHandle)textfieldBlock{
    if (self =[super init]) {
        
    }return self;
}

-(void)setupUI{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3/1.0];
    //bgView最大高度
    CGFloat maxHeight = DEFAULT_MAX_HEIGHT;
    
    
    //backgroundView
    
    UIView *bgView = [[UIView alloc]init];
    bgView.center = self.center;
    bgView.bounds = CGRectMake(0, 0, self.frame.size.width - Ratio(40), maxHeight+Ratio(18));
    [self addSubview:bgView];
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.frame = CGRectMake(Ratio(20), Ratio(18), bgView.frame.size.width -Ratio(40), maxHeight);
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.masksToBounds = YES;
    bottomView.layer.cornerRadius = 4.0f;
    [bgView addSubview:bottomView];
    
    //标题
    UILabel *titleLab = [UILabel new];
    titleLab.frame = CGRectMake(0, 10, bottomView.frame.size.width, 18);
    titleLab.text = @"请选择故障类型";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:17];
    [bottomView addSubview:titleLab];
    
}
@end
