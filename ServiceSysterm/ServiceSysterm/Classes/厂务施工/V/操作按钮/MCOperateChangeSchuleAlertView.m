//
//  MCOperateChangeSchuleAlertView.m
//  ServiceSysterm
//
//  Created by Andy on 2020/10/29.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MCOperateChangeSchuleAlertView.h"
#import "UITextView+Placeholder.h"

#define DEFAULT_MAX_HEIGHT kScreenHeight*0.4

//屏幕适配
/**当前设备对应375的比例*/
#define Ratio_375 (kScreenWidth/375.0)
/**转换成当前比例的数*/
#define Ratio(x) ((int)((x) * Ratio_375))

@interface MCOperateChangeSchuleAlertView ()<UITextViewDelegate>



@property (nonatomic,strong)UIView * contentV;

@property (nonatomic,copy)NSString * dateString;

@end

@implementation MCOperateChangeSchuleAlertView







-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        [self setupPickView];
    }
    return self;
}
-(void)setupPickView{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3/1.0];
    UIView * bottomView  =[[UIView alloc]init];
    bottomView.frame  =CGRectMake(0, kScreenHeight, kScreenWidth, 220);
    bottomView.backgroundColor  =[UIColor whiteColor];
    _contentV  =bottomView;
    [self addSubview:bottomView];
    
//    UIToolbar *toolbar=[[UIToolbar alloc] init];
//    toolbar.frame  = CGRectMake(0, 0, kScreenWidth, 40);
       
    UIView * toolBarView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    toolBarView.backgroundColor  =RGBA(242, 242, 242, 1);
    toolBarView.layer.borderWidth  =0.5;
    toolBarView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [bottomView addSubview:toolBarView];
    UIButton * cancelBut =[UIButton buttonWithType:UIButtonTypeCustom];
    cancelBut.frame = CGRectMake(8, 0, 60, 40);
    cancelBut.titleLabel.font  =[UIFont systemFontOfSize:14];
    [cancelBut setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancelBut setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBut addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    
    [toolBarView addSubview:cancelBut];
    
    UILabel * titleLab  =[[UILabel alloc]initWithFrame:CGRectMake(toolBarView.frame.size.width*0.5-60, 0, 120, 40)];
    titleLab.textAlignment  =NSTextAlignmentCenter;
    titleLab.font  =[UIFont systemFontOfSize:15];
    titleLab.text =@"选择时间";
    [toolBarView addSubview:titleLab];
    
    UIButton * sureBut  =[UIButton buttonWithType:UIButtonTypeCustom];
    sureBut.titleLabel.font  =[UIFont systemFontOfSize:15];
    [sureBut setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sureBut setTitle:@"确定" forState:UIControlStateNormal];
    sureBut.frame =CGRectMake(CGRectGetMaxX(toolBarView.frame)-68, 0, 60, 40);
    [sureBut addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    
    [toolBarView addSubview:sureBut];
     

    UIDatePicker * datePicker  = [[UIDatePicker alloc]init];
    datePicker.frame  = CGRectMake(0, 40, kScreenWidth, 180);
    datePicker.datePickerMode  = UIDatePickerModeDateAndTime;
    
    datePicker.locale  =[NSLocale localeWithLocaleIdentifier:@"zh"];
    
    datePicker.date  =[NSDate date];
    
    [datePicker addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    
    [bottomView addSubview:datePicker];
   
    
    
    
}

-(void)remove{
    [self dismissAlert];
}

-(void)doneClick{
    [self dismissAlert];
    
    if (self.dateString.length  ==0) {
        NSDateFormatter * formater  =[[NSDateFormatter alloc]init];
        [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.dateString  =[formater stringFromDate:[NSDate date]];
    }
    if (self.dateBlock) {
        self.dateBlock(self.dateString);
    }
}

-(void)changeValue:(UIDatePicker*)pickView{
    NSDateFormatter * format  =[[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.dateString  = [format stringFromDate:pickView.date];
    
    
}
- (void)show{
    
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 1;
        self->_contentV.frame = CGRectMake(0, kScreenHeight - 220, kScreenWidth, 220);
    } completion:^(BOOL finished) {
    }];
}

/** 添加Alert出场动画 */
- (void)dismissAlert{
   [UIView animateWithDuration:0.2f animations:^{
           self.alpha = 0;
           self->_contentV.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 220);
       } completion:^(BOOL finished) {
           self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
       }];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissAlert];
}
@end
