//
//  PassWordReSetAlertView.m
//  ServiceSysterm
//
//  Created by Andy on 2019/6/6.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "PassWordReSetAlertView.h"
#import "AssetConst.h"

#import "ToolBar.h"


@interface PassWordReSetAlertView ()
@property (nonatomic,strong)ToolBar * tool;

@end
@implementation PassWordReSetAlertView

+(void)showAlert{
    PassWordReSetAlertView * alertView =[[PassWordReSetAlertView alloc]init];
    [[UIApplication sharedApplication].delegate.window addSubview:alertView];
}
-(instancetype)init{
    if (self =[super init]) {
        [self setUI];
        
    }return self;
}
-(void)setUI{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3/1.0];
    //bgView最大高度
    CGFloat maxHeight = 271;
    
    UIScrollView * scrollView =[[UIScrollView alloc]init];
    scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    //backgroundView
    
    UIView *bgView = [[UIView alloc]init];
    bgView.center = self.center;
    bgView.bounds = CGRectMake(0, 0, self.frame.size.width - Ratio(60), maxHeight+Ratio(18));
    [self addSubview:bgView];
    
    
    
   
    UIView *updateView = [[UIView alloc]init];
    updateView.frame = CGRectMake(Ratio(5), Ratio(18), bgView.frame.size.width -Ratio(10), maxHeight);
    updateView.backgroundColor = [UIColor whiteColor];
    updateView.layer.masksToBounds = YES;
    updateView.layer.cornerRadius = 4.0f;
    [bgView addSubview:updateView];
    
    
    UIButton * cancelButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    cancelButton.center = CGPointMake(CGRectGetMaxX(updateView.frame)-Ratio(10), CGRectGetMinY(updateView.frame)+Ratio(10));
    cancelButton.bounds = CGRectMake(0, 0, Ratio(36), 36);
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelButton];
    
    UILabel * titleLab =[[UILabel alloc]init];
    titleLab.text =@"重置工资查询密码";
    titleLab.textAlignment =NSTextAlignmentCenter;
    [titleLab sizeToFit];
    [updateView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(updateView);
        make.top.mas_offset(12);
    }];
    UITextField *codeTextField = [[UITextField alloc]init];
    codeTextField.placeholder =@"请输入您的工号";
    codeTextField.font =[UIFont systemFontOfSize:15];
    codeTextField.inputAccessoryView =self.tool;
    codeTextField.borderStyle = UITextBorderStyleRoundedRect;
    [updateView addSubview:codeTextField];
    [codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(8);
        make.top.mas_equalTo(titleLab.mas_bottom).mas_offset(12);
        make.right.mas_offset(-8);
        make.height.mas_equalTo(40);
    }];
    
   
    
    UITextField * mobileTextF =[[UITextField alloc]init];
    mobileTextF.placeholder =@"请输入您的手机号";
    mobileTextF.font =[UIFont systemFontOfSize:15];
    mobileTextF.inputAccessoryView =self.tool;
    mobileTextF.borderStyle =UITextBorderStyleRoundedRect;
    [updateView addSubview:mobileTextF];
    [mobileTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(8);
        make.top.mas_equalTo(codeTextField.mas_bottom).mas_equalTo(12);
        make.right.mas_offset(-8);
        make.height.mas_equalTo(40);
    }];
   
    UIButton * codeButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    codeButton.titleLabel.font =[UIFont systemFontOfSize:15];
    codeButton.backgroundColor = RGBA(116, 235, 210, 1);
    codeButton.layer.cornerRadius = 3.0f;
    codeButton.clipsToBounds = YES;
    [codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [updateView addSubview:codeButton];
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-8);
        make.top.mas_equalTo(mobileTextF.mas_bottom).mas_offset(12);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(85);
    }];
    UITextField * vertifyTextF =[[UITextField alloc]init];
    vertifyTextF.placeholder =@"请输入验证码";
    vertifyTextF.inputAccessoryView =self.tool;
    vertifyTextF.font =[UIFont systemFontOfSize:15];
    vertifyTextF.borderStyle = UITextBorderStyleRoundedRect;
    [updateView addSubview:vertifyTextF];
    [vertifyTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(8);
        make.top.mas_equalTo(mobileTextF.mas_bottom).mas_offset(12);
        make.right.mas_equalTo(codeButton.mas_left).mas_offset(-6);
        make.height.mas_equalTo(40);
        
    }];
    
    UIView * line =[[UIView alloc]init];
    line.backgroundColor = RGBA(242, 242, 242, 1);
    [updateView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(2);
        make.top.mas_equalTo(vertifyTextF.mas_bottom).mas_offset(12);
        make.right.mas_offset(-2);
        make.height.mas_equalTo(1);
    }];
    
    UIButton * sureButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    sureButton.backgroundColor = RGBA(149, 50, 52, 1);
    sureButton.layer.cornerRadius =3;
    sureButton.clipsToBounds =YES;
    [updateView addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(updateView);
        make.bottom.mas_offset(-12);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(45);
        
    }];
    
    [self showWithAlert:updateView];
}

-(void)cancel{
    [self dismissAlert];
}
- (void)showWithAlert:(UIView*)alert{
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.06f;
    
    NSMutableArray *values = [NSMutableArray array];
    //    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [alert.layer addAnimation:animation forKey:nil];
}

/** 添加Alert出场动画 */
- (void)dismissAlert{
    
    [UIView animateWithDuration:SELAnimationTimeInterval animations:^{
        //self.transform = (CGAffineTransformMakeScale(1.5, 1.5));
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    } ];
    
}

- (ToolBar *)tool{
    if (!_tool) {
        _tool = [ToolBar toolBar];
        
        __weak typeof(self) weakself = self;
        _tool.finishBlock = ^(){
            [weakself endEditing:YES];
        };
    }
    return _tool;
}
@end
