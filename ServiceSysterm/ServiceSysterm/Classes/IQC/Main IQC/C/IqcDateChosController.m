//
//  IqcDateChosController.m
//  ServiceSysterm
//
//  Created by Andy on 2022/1/6.
//  Copyright © 2022 SLPCB. All rights reserved.
//

#import "IqcDateChosController.h"
#import "LXCalendarView.h"
#import "UIColor+Expanded.h"
@interface IqcDateChosController ()

@property(nonatomic,strong)LXCalendarView *calenderView;

@property (nonatomic,copy)NSString *beginStr;

@property (nonatomic,copy)NSString *endStr;

@end

@implementation IqcDateChosController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel * beginLabel  =[[UILabel alloc]init];
    beginLabel.text = @"开始日期";
    beginLabel.textAlignment  = NSTextAlignmentCenter;
    [self.view addSubview:beginLabel];
    [beginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(8);
        make.top.mas_offset(14);
        make.width.mas_equalTo(320);
        make.height.mas_equalTo(21);
    }];
    LXCalendarView *beginView  =[[LXCalendarView alloc]initWithFrame:CGRectMake(0, 40, 330, 0)];
  
    
    beginView.currentMonthTitleColor =[UIColor hexStringToColor:@"2c2c2c"];
    beginView.lastMonthTitleColor =[UIColor hexStringToColor:@"8a8a8a"];
    beginView.nextMonthTitleColor =[UIColor hexStringToColor:@"8a8a8a"];
    
    beginView.isHaveAnimation = YES;
    
    beginView.isCanScroll = NO;
    
    beginView.isShowLastAndNextBtn = YES;
    
    beginView.isShowLastAndNextDate = YES;
    
    beginView.todayTitleColor =[UIColor purpleColor];
    
    beginView.selectBackColor =[UIColor blueColor];

    beginView.backgroundColor =[UIColor whiteColor];
    [beginView dealData];
    
    [self.view addSubview:beginView];
    KWeakSelf
    beginView.selectBlock = ^(NSInteger year, NSInteger month, NSInteger day) {
        weakSelf.beginStr  =[NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
        if (weakSelf.endStr.length >0) {
            NSDictionary *dic =@{@"begin":weakSelf.beginStr,@"end":weakSelf.endStr};
            [[NSNotificationCenter defaultCenter]postNotificationName:@"chosDate" object:dic];
        }
        
    };
    
    UILabel *endLab  =[[UILabel alloc]init];
    endLab.text =@"结束日期";
    endLab.textAlignment  =NSTextAlignmentCenter;
    [self.view addSubview:endLab];
    [endLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(beginView.mas_right).mas_offset(16);
        make.top.mas_offset(14);
        make.width.mas_equalTo(320);
        make.height.mas_equalTo(21);
    }];
    
    LXCalendarView *endView  =[[LXCalendarView alloc]initWithFrame:CGRectMake(340, 40, 330, 0)];
   
    endView.currentMonthTitleColor =[UIColor hexStringToColor:@"2c2c2c"];
    endView.lastMonthTitleColor =[UIColor hexStringToColor:@"8a8a8a"];
    endView.nextMonthTitleColor =[UIColor hexStringToColor:@"8a8a8a"];
    
    endView.isHaveAnimation = YES;
    
    endView.isCanScroll = NO;
    
    endView.isShowLastAndNextBtn = YES;
    
    endView.isShowLastAndNextDate = YES;
    
    endView.todayTitleColor =[UIColor purpleColor];
    
    endView.selectBackColor =[UIColor blueColor];

    endView.backgroundColor =[UIColor whiteColor];
    [endView dealData];
    
    [self.view addSubview:endView];
    
    endView.selectBlock = ^(NSInteger year, NSInteger month, NSInteger day){
        NSString *endStr  = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
        weakSelf.endStr  =endStr;
        if (weakSelf.beginStr.length  ==0) {
            [Units showErrorStatusWithString:@"请选择开始日期"];
            return;
        }
        NSDictionary *dic =@{@"begin":weakSelf.beginStr,@"end":endStr};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"chosDate" object:dic];
    };
    
}



@end
