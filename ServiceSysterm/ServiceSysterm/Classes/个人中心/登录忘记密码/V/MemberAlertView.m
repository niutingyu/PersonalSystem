//
//  MemberAlertView.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "MemberAlertView.h"
#import "AssetConst.h"

@interface MemberAlertView ()

@property (nonatomic,strong)PeopleListModel * model;

@end
@implementation MemberAlertView

+(void)showAlertViewModel:(PeopleListModel*)model{
    MemberAlertView * alertView = [[MemberAlertView alloc]initWithModel:model];
    [[UIApplication sharedApplication].delegate.window addSubview:alertView];
}

-(instancetype)initWithModel:(PeopleListModel*)model{
    if (self =[super init]) {
        _model =model;
        [self setUI];
    }
    return self;
}
-(void)setUI{
    
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3/1.0];
    //bgView最大高度
    CGFloat maxHeight = 160;
    
    
    //backgroundView
    
    UIView *bgView = [[UIView alloc]init];
    bgView.center = self.center;
   // bgView.backgroundColor =[UIColor blueColor];
    bgView.bounds = CGRectMake(0, 0, self.frame.size.width - Ratio(60), maxHeight+Ratio(120));
    [self addSubview:bgView];
  
    
    
  
    UIView *updateView = [[UIView alloc]init];
    updateView.frame = CGRectMake(Ratio(10), Ratio(18), bgView.frame.size.width -Ratio(20), maxHeight);
    updateView.backgroundColor = [UIColor whiteColor];
    updateView.layer.masksToBounds = YES;
    updateView.layer.cornerRadius = 4.0f;
    [bgView addSubview:updateView];
    
    //标题
    UILabel * titleLab =[[UILabel alloc]init];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleLab sizeToFit];
    titleLab.text =_model.FName;
    [updateView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(updateView);
        make.top.mas_offset(8);
    }];
    [self showWithAlert:updateView];
    //取消
//    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [cancelButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
//    [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
//    cancelButton.center = CGPointMake(CGRectGetMaxX(updateView.frame)-Ratio(10), CGRectGetMinY(updateView.frame)+Ratio(10));
//    cancelButton.bounds = CGRectMake(0, 0, Ratio(36), 36);
//    [bgView addSubview:cancelButton];
    
    UIView * midddleView =[[UIView alloc]init];
    [updateView addSubview:midddleView];
    [midddleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(updateView);
        make.top.mas_offset(6);
        make.bottom.mas_offset(-6);
        make.width.mas_equalTo(1);
        
    }];
    //工号
    UILabel * numberLab  = [[UILabel alloc]init];
   
    numberLab.font = [UIFont systemFontOfSize:15];
    numberLab.text =[NSString stringWithFormat:@"工号:%@",_model.UserName];
    [updateView addSubview:numberLab];
    [numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(8);
        make.top.mas_offset(38);
        make.right.mas_equalTo(midddleView).mas_offset(-8);
        make.height.mas_equalTo(20);
        
    }];
    //邮箱
    UILabel * emailLab =[[UILabel alloc]init];
    emailLab.textAlignment = NSTextAlignmentRight;
    emailLab.font =[UIFont systemFontOfSize:15];
    emailLab.text = [NSString stringWithFormat:@"邮箱:%@",_model.Email?:@"暂无"];
    [updateView addSubview:emailLab];
    [emailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(midddleView).mas_offset(8);
        make.right.mas_equalTo(updateView).mas_offset(-6);
        make.top.mas_offset(38);
        make.height.mas_equalTo(20);
    }];
    //部门
    UILabel * departmentLab =[[UILabel alloc]init];
  
    departmentLab.font =[UIFont systemFontOfSize:15];
    departmentLab.text = [NSString stringWithFormat:@"部门:%@",_model.DepName];
    [updateView addSubview:departmentLab];
    [departmentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(8);
        make.top.mas_equalTo(numberLab.mas_bottom).mas_offset(15);
        make.right.mas_equalTo(midddleView).mas_offset(-8);
    }];
    UILabel * jobLab =[[UILabel alloc]init];
    jobLab.textAlignment = NSTextAlignmentRight;
    jobLab.font =[UIFont systemFontOfSize:15];
    jobLab.text =[NSString stringWithFormat:@"职称:%@",_model.PositionName?:@"暂无"];
    [updateView addSubview:jobLab];
    [jobLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(midddleView).mas_offset(8);
        make.top.mas_equalTo(emailLab.mas_bottom).mas_offset(15);
        make.right.mas_equalTo(updateView).mas_offset(-6);
    }];
    //手机
    UILabel * mobileLab =[[UILabel alloc]init];
   
    mobileLab.font = [UIFont systemFontOfSize:15];
    mobileLab.text = [NSString stringWithFormat:@"电话:%@",_model.Mobile?:@"暂无"];
    mobileLab.attributedText = [Units changeLabel:_model.Mobile?:@"暂无" wholeString:mobileLab.text];
    [updateView addSubview:mobileLab];
    mobileLab.userInteractionEnabled = YES;
    [mobileLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(8);
        make.top.mas_equalTo(departmentLab.mas_bottom).mas_offset(15);
        make.right.mas_equalTo(midddleView).mas_offset(-2);
    }];
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [mobileLab addGestureRecognizer:tap];
    //短号
    UILabel * shortPhoneLab =[[UILabel alloc]init];
    shortPhoneLab.textAlignment = NSTextAlignmentRight;
    shortPhoneLab.font =[UIFont systemFontOfSize:15];
   
    NSString * shortPhone =nil;
    if ([_model.shortMobile isEqualToString:@""]||_model.shortMobile.length ==0) {
        shortPhone = @"暂无";
    }else{
        shortPhone =_model.shortMobile;
    }
     shortPhoneLab.text = [NSString stringWithFormat:@"短号:%@",shortPhone];
    shortPhoneLab.attributedText = [Units changeLabel:shortPhone wholeString:shortPhoneLab.text];
    [updateView addSubview:shortPhoneLab];
    [shortPhoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(midddleView).mas_offset(8);
        make.top.mas_equalTo(departmentLab.mas_bottom).mas_offset(15);
        make.right.mas_offset(-6);
    }];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelView:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(updateView);
        make.top.mas_equalTo(updateView.mas_bottom).mas_offset(50);
        make.width.height.mas_equalTo(Ratio(36));
    }];
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
-(void)cancelView:(UIButton*)sender{
  [self dismissAlert];
}
-(void)tap:(UITapGestureRecognizer*)sender{
//    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_model.Mobile]];//
    [[UIApplication sharedApplication]openURL:telURL];
//    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
//    [self addSubview:callWebview];
}
@end
