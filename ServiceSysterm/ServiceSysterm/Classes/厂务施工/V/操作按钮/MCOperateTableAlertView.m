//
//  MCOperateTableAlertView.m
//  ServiceSysterm
//
//  Created by Andy on 2020/10/29.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MCOperateTableAlertView.h"



#define DEFAULT_MAX_HEIGHT kScreenHeight/3

//屏幕适配
/**当前设备对应375的比例*/
#define Ratio_375 (kScreenWidth/375.0)
/**转换成当前比例的数*/
#define Ratio(x) ((int)((x) * Ratio_375))

@interface MCOperateTableAlertView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@end
@implementation MCOperateTableAlertView


+(void)showTableAlertViewWithHeadString:(NSString*)headTitle datasource:(NSMutableArray*)datasource memBlock:(choseMemberBlock)memBlock {
    MCOperateTableAlertView * alertView  =[[MCOperateTableAlertView alloc]initWithdatasource:datasource headString:headTitle choseMemBlock:memBlock];
    [[UIApplication sharedApplication].delegate.window addSubview:alertView];
    
}


-(instancetype)initWithdatasource:(NSMutableArray*)datasource headString:(NSString*)headString choseMemBlock:(choseMemberBlock)memBlock{
    if (self  =[super init]) {
        _memberBlock  =memBlock;
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
    
    
    //添加更新提示
    UIView *updateView = [[UIView alloc]init];
    updateView.frame = CGRectMake(Ratio(20), Ratio(18), bgView.frame.size.width -Ratio(40), maxHeight);
    updateView.backgroundColor = [UIColor whiteColor];
    updateView.layer.masksToBounds = YES;
    updateView.layer.cornerRadius = 4.0f;
    [bgView addSubview:updateView];
    
    //取消
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    
    cancelButton.center = CGPointMake(CGRectGetMaxX(updateView.frame)-Ratio(10), CGRectGetMinY(updateView.frame)+Ratio(10));
    cancelButton.bounds = CGRectMake(0, 0, Ratio(36), 36);
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelButton];
    //标题
    UILabel *titleLab = [UILabel new];
    titleLab.frame = CGRectMake(0, 10, updateView.frame.size.width, 18);
    titleLab.text = @"请选择故障类型";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:17];
    [updateView addSubview:titleLab];
    
    
    //tableview
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLab.frame)+6, updateView.frame.size.width, updateView.frame.size.height-60) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 50.0f;
        [updateView addSubview:_tableView];
      // [_tableView registerNib:[UINib nibWithNibName:@"SelectedMemberTableCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
        
        
    }
    
     UIView * buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(updateView.frame)-60, updateView.frame.size.width, 50)];
       buttonView.backgroundColor = [UIColor whiteColor];
       [updateView addSubview:buttonView];
       UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
       btn.frame = CGRectMake(0, 0, buttonView.frame.size.width, buttonView.frame.size.height);
       [btn setTitle:@"确定" forState:UIControlStateNormal];
       [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
       [btn addTarget:self action:@selector(sureChos) forControlEvents:UIControlEventTouchUpInside];
       [buttonView addSubview:btn];
    
    [self showWithAlert:bgView];
    
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
