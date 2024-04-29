//
//  CorrectionButAlertView.m
//  ServiceSysterm
//
//  Created by Andy on 2022/3/12.
//  Copyright © 2022 SLPCB. All rights reserved.
//

#import "CorrectionButAlertView.h"
#import "AssetConst.h"
#import "UITextView+Placeholder.h"
@interface CorrectionButAlertView ()<UITextViewDelegate>

@property (nonatomic,copy)NSString *tipString;

@property (nonatomic,copy)NSString *flagStr;

@property (nonatomic,copy)NSString *remarkString;


@end
@implementation CorrectionButAlertView

+(void)showAlertViewWithTipStr:(NSString*)tipStr suBlock:(sureBlock)suBlock{
    CorrectionButAlertView *alertV  =[[CorrectionButAlertView alloc]initWithTipStr:tipStr sureBlock:suBlock];
    [[UIApplication sharedApplication].delegate.window addSubview:alertV];
}
-(instancetype)initWithTipStr:(NSString*)tipStr sureBlock:(sureBlock)sBlock{
    if (self  =[super init]) {
       _tipString  =tipStr;
        _sBlock  = sBlock;
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3/1.0];
    //bgView最大高度
    CGFloat maxHeight = 240;
    
    
    //backgroundView
    
    UIView *bgView = [[UIView alloc]init];
    bgView.center = self.center;
    bgView.bounds = CGRectMake(0, 0, self.frame.size.width - Ratio(40), maxHeight+Ratio(18));
    [self addSubview:bgView];
   
    
    //添加更新提示
    UIView *updateView = [[UIView alloc]init];
    updateView.frame = CGRectMake(Ratio(20), Ratio(18), bgView.frame.size.width -Ratio(40), maxHeight);
    updateView.backgroundColor = [UIColor whiteColor];
    updateView.layer.masksToBounds = YES;
    updateView.layer.cornerRadius = 4.0f;
    [bgView addSubview:updateView];
   
    
    //标题
    UILabel *titleLab = [UILabel new];
    titleLab.frame = CGRectMake(0, 15, updateView.frame.size.width, 18);
    titleLab.text = _tipString;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:17 weight:0.5];
    [updateView addSubview:titleLab];
    
    UIView *line  =[[UIView alloc]initWithFrame:CGRectMake(2, 43, updateView.frame.size.width-4, 0.5)];
    line.backgroundColor  =[UIColor darkGrayColor];
    [updateView addSubview:line];
    
    NSArray * titles =@[@"通过",@"退回"];
    for (int i =0; i<2; i++) {
        UIButton *but  =[UIButton buttonWithType:UIButtonTypeCustom];
        but.frame  = CGRectMake(8+80*i, CGRectGetMaxY(line.frame)+10, 80, 40);
        but.titleLabel.font  =[UIFont systemFontOfSize:17];
        [but setTitle:titles[i] forState:UIControlStateNormal];
        [but setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
        [but setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        but.imageEdgeInsets =UIEdgeInsetsMake(0, -15, 0, 0);
        [but addTarget:self action:@selector(butMethod:) forControlEvents:UIControlEventTouchUpInside];
        but.tag =100+i;
        [updateView addSubview:but];
        
    }
    
   
    
    //备注
    UITextView *remarkTextV =[[UITextView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(line.frame)+10+40+8, updateView.frame.size.width-20, 80)];
    remarkTextV.placeholder =@"请输入备注信息";
    remarkTextV.layer.borderWidth =0.5;
    remarkTextV.layer.borderColor  =[UIColor darkGrayColor].CGColor;
    remarkTextV.layer.cornerRadius =3;
    remarkTextV.clipsToBounds  =YES;
    remarkTextV.delegate  =self;
    [updateView addSubview:remarkTextV];
    
    UIView *bottomView  =[[UIView alloc]initWithFrame:CGRectMake(0, updateView.frame.size.height-40, updateView.frame.size.width, 40)];
    bottomView.backgroundColor  =[UIColor darkGrayColor];
    [updateView addSubview:bottomView];
    
    UIButton *cancelBut  =[UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBut setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBut.frame  = CGRectMake(0, 0.5, updateView.frame.size.width*0.5, 39.5);
    cancelBut.backgroundColor  = RGBA(242, 242, 242, 1);
    [cancelBut addTarget:self action:@selector(cncelMethod) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cancelBut];
    
    UIButton *sureBut =[UIButton buttonWithType:UIButtonTypeCustom];
    sureBut.frame  = CGRectMake(CGRectGetMaxX(cancelBut.frame)+0.5, 0.5, updateView.frame.size.width*0.5-0.5, 39.5);
    [sureBut setTitle:@"确定" forState:UIControlStateNormal];
    [sureBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sureBut.backgroundColor  =RGBA(242, 242, 242, 1);
    [sureBut addTarget:self action:@selector(sureMethod) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sureBut];
    
    [self showWithAlert:bgView];
    
    
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    self.remarkString  =textView.text;
    
    return YES;
}

-(void)butMethod:(UIButton*)sender{
    for (int i =0; i<2; i++) {
        UIButton *but  =[self viewWithTag:i+100];
        but.selected  =NO;
    }
    sender.selected =YES;
    self.flagStr  =[NSString stringWithFormat:@"%ld",sender.tag-100];
    
}

-(void)cncelMethod{
    [self dismissAlert];
}

-(void)sureMethod{
    [self endEditing:YES];
    if (self.sBlock) {
        self.sBlock(self.flagStr, self.remarkString);
    }
    [self dismissAlert];
    
}

- (void)showWithAlert:(UIView*)alert{
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = SELAnimationTimeInterval;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
  //  [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [alert.layer addAnimation:animation forKey:nil];
}


/** 添加Alert出场动画 */
- (void)dismissAlert{
    
    [UIView animateWithDuration:SELAnimationTimeInterval animations:^{
        self.transform = (CGAffineTransformMakeScale(1.5, 1.5));
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    } ];
    
}

@end
