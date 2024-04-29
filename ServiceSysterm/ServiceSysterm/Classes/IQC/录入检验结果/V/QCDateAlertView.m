//
//  QCDateAlertView.m
//  ServiceSysterm
//
//  Created by Andy on 2021/6/1.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "QCDateAlertView.h"
#import "AssetConst.h"



@interface QCDateAlertView ()

@property (nonatomic,strong)UIView * menuBackView;


@end
@implementation QCDateAlertView

+(void)showassetAlertViewWithCode:(NSString*)code{
    QCDateAlertView *assetView = [[QCDateAlertView alloc]initCode:code];
    [[UIApplication sharedApplication].delegate.window addSubview:assetView];
    
}

-(instancetype)initCode:(NSString*)codeStr{
    if (self = [super init]) {
        //self.code = codeStr;
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
    updateView.frame = CGRectMake(Ratio(20), Ratio(18), bgView.frame.size.width -Ratio(40), maxHeight);
    updateView.backgroundColor = [UIColor whiteColor];
    updateView.layer.masksToBounds = YES;
    updateView.layer.cornerRadius = 4.0f;
    [bgView addSubview:updateView];
    
    UITapGestureRecognizer * tap  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchOutSide)];
    [self addGestureRecognizer:tap];
    
    
    [self showWithAlert:bgView];
    
}

- (void)showWithAlert:(UIView*)alert{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = SELAnimationTimeInterval;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [alert.layer addAnimation:animation forKey:nil];

}

-(void)touchOutSide{
    [self dismissAlert];
}
/** 添加Alert出场动画 */
- (void)dismissAlert{
    
    [UIView animateWithDuration:SELAnimationTimeInterval animations:^{
        self.transform = (CGAffineTransformMakeScale(1.5, 1.5));
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

@end
