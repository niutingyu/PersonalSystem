//
//  MCOperateRemarkAlertView.m
//  ServiceSysterm
//
//  Created by Andy on 2020/10/29.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MCOperateRemarkAlertView.h"
#import "UITextView+Placeholder.h"

#define DEFAULT_MAX_HEIGHT kScreenHeight/3

//屏幕适配
/**当前设备对应375的比例*/
#define Ratio_375 (kScreenWidth/375.0)
/**转换成当前比例的数*/
#define Ratio(x) ((int)((x) * Ratio_375))


@interface MCOperateRemarkAlertView ()<UITextViewDelegate>

@property (nonatomic,copy)NSString *headString;

@property (nonatomic,copy)NSString * textString;

@end

@implementation MCOperateRemarkAlertView



+(void)showAlerMCRemarkAlertViewWithHeadString:(NSString*)headString commitBlock:(commitBlock)commitBlock{
    MCOperateRemarkAlertView * alertView  =[[MCOperateRemarkAlertView alloc]initWithCommitBlock:commitBlock text:headString];
    [[UIApplication sharedApplication].delegate.window addSubview:alertView];
    
}
-(instancetype)initWithCommitBlock:(commitBlock)commitBlock text:(NSString*)text{
    if (self  =[super init]) {
        
        _cBlock  =commitBlock;
        
        _headString  =text;
        [self setupUI];
    }
    return self;
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
    
    UIView *updateView = [[UIView alloc]init];
    updateView.frame = CGRectMake(Ratio(20), Ratio(18), bgView.frame.size.width -Ratio(40), DEFAULT_MAX_HEIGHT);
    updateView.backgroundColor = [UIColor whiteColor];
    updateView.layer.masksToBounds = YES;
    updateView.layer.cornerRadius = 4.0f;
    [bgView addSubview:updateView];
    
    
    UILabel * titleLabel  =[[UILabel alloc]initWithFrame:CGRectMake(16, 8, updateView.frame.size.width-32, 30)];
    
    titleLabel.font  =[UIFont systemFontOfSize:16 weight:0.5];
    
    titleLabel.textAlignment  =NSTextAlignmentCenter;
    
    titleLabel.text =self.headString;
    
    [updateView addSubview:titleLabel];
    
    UIView * line  =[UIView new];
    
    line.frame  = CGRectMake(8, CGRectGetMaxY(titleLabel.frame)+16, updateView.frame.size.width-16, 0.5);
    
    line.backgroundColor  =RGBA(54, 151, 217, 1);
    
    [updateView addSubview:line];
    
    UITextView * textView  =[[UITextView alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(line.frame)+8, updateView.frame.size.width-16, updateView.frame.size.height-60-30-8)];
    
    textView.layer.borderWidth  =0.5;
    
    textView.layer.borderColor  = RGBA(242, 242, 242, 1).CGColor;
    
    textView.delegate  =self;
    
    textView.layer.cornerRadius =3;
    
    textView.clipsToBounds  =YES;
    
    textView.placeholderColor  = [UIColor darkGrayColor];
    
    textView.placeholder =@"输入备注信息";
    
    [updateView addSubview:textView];
    
    UIView * buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(updateView.frame)-61, updateView.frame.size.width, 50)];
    
    buttonView.backgroundColor = RGBA(242, 242, 242, 1);
    
    [updateView addSubview:buttonView];
    
    UIButton * cancelBut  =[UIButton buttonWithType:UIButtonTypeCustom];
    
    cancelBut.frame = CGRectMake(0, 1, buttonView.frame.size.width*0.5-1, 49);
    
    [cancelBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    cancelBut.backgroundColor  =[UIColor whiteColor];
    
    [cancelBut setTitle:@"取消" forState:UIControlStateNormal];
    
    cancelBut.titleLabel.font  =[UIFont systemFontOfSize:15];
    
    [cancelBut addTarget:self action:@selector(cancelMethod) forControlEvents:UIControlEventTouchUpInside];
    
    
    [buttonView addSubview:cancelBut];
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(buttonView.frame.size.width*0.5+1,1 , buttonView.frame.size.width*0.5-1, 49);
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    btn.backgroundColor  = [UIColor whiteColor];
    
    
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.titleLabel.font  =[UIFont systemFontOfSize:15];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sureCommit) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:btn];
    
    [self showWithAlert:updateView];
    
    
}


-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    self.textString  =textView.text;
    return YES;
}

-(void)sureCommit{
    [self endEditing:YES];
    
    if ([self.headString isEqualToString:@"驳回"]||[self.headString isEqualToString:@"移除指派"]||[self.headString isEqualToString:@"解除暂停"]||[self.headString isEqualToString:@"填写工作日志"]||[self.headString isEqualToString:@"作废"]||[self.headString isEqualToString:@"问题记录"]||[self.headString  isEqualToString:@"驳回改期"]||[self.headString isEqualToString:@"驳回延期"]||[self.headString isEqualToString:@"驳回返工"]) {
        if (self.textString.length  ==0) {
            [Units showWarningWithTitle:@"提示" andSubTitle:@"备注必填" andView:self];
            return;
        }
    }
    
    if (self.cBlock) {
        self.cBlock(self.textString);
    }
    [self dismissAlert];
}


-(void)cancelMethod{
    [self dismissAlert];
}

- (void)showWithAlert:(UIView*)alert{
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3f;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
  //  [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
      [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [alert.layer addAnimation:animation forKey:nil];
}

/** 添加Alert出场动画 */
- (void)dismissAlert{
    KWeakSelf
    [UIView animateWithDuration:0.3f animations:^{
        //self.transform = (CGAffineTransformMakeScale(1.5, 1.5));
        weakSelf.backgroundColor = [UIColor clearColor];
        weakSelf.alpha = 0;
    }completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    } ];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissAlert];
}
@end
