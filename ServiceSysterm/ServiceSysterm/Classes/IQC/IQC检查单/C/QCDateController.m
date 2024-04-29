//
//  QCDateController.m
//  ServiceSysterm
//
//  Created by Andy on 2021/8/18.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "QCDateController.h"
#import "LXCalender.h"
#import "UIColor+Expanded.h"
@interface QCDateController ()
@property(nonatomic,strong)LXCalendarView *calenderView;
@end

@implementation QCDateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.calenderView  =[[LXCalendarView alloc]initWithFrame:CGRectMake(0, 20, 330, 0)];
  
    
    self.calenderView.currentMonthTitleColor =[UIColor hexStringToColor:@"2c2c2c"];
    self.calenderView.lastMonthTitleColor =[UIColor hexStringToColor:@"8a8a8a"];
    self.calenderView.nextMonthTitleColor =[UIColor hexStringToColor:@"8a8a8a"];
    
    self.calenderView.isHaveAnimation = YES;
    
    self.calenderView.isCanScroll = NO;
    
    self.calenderView.isShowLastAndNextBtn = YES;
    
    self.calenderView.isShowLastAndNextDate = YES;
    
    self.calenderView.todayTitleColor =[UIColor purpleColor];
    
    self.calenderView.selectBackColor =[UIColor blueColor];

    self.calenderView.backgroundColor =[UIColor whiteColor];
    [self.calenderView dealData];
    
    [self.view addSubview:self.calenderView];
   // KWeakSelf
    self.calenderView.selectBlock = ^(NSInteger year, NSInteger month, NSInteger day) {
      
        NSDate *date1  =[NSDate date];
     
        NSDate *date2  =[Units dataFromString:[NSString stringWithFormat:@"%@-%@-%@",@(year),@(month),@(day)] withFormat:@"yyyy-MM-dd"];
        NSComparisonResult result  = [date1 compare:date2];
        if (result ==NSOrderedDescending) {
            [Units showErrorStatusWithString:@"有效期必须大于当前时间"];
            return;
        }
        NSDictionary *dict=@{@"year":@(year)?:@"",@"month":@(month)?:@"",@"day":@(day)?:@""};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"date" object:dict];
    };
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
