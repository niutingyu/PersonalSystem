//
//  DevicePartAlertView.m
//  ServiceSysterm
//
//  Created by Andy on 2019/8/9.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DevicePartAlertView.h"

#import "AssetConst.h"
#import "ApplyAcceptanceModel.h"

@interface DevicePartAlertView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSArray * datasource;
@end
@implementation DevicePartAlertView


+(void)showAlertViewWithdatsource:(NSArray*)datasource partBlock:(selectedDevicePartBlock)partblock{
    DevicePartAlertView * view = [[DevicePartAlertView alloc]initWithdatasource:datasource partblock:partblock];
    [[UIApplication sharedApplication].delegate.window addSubview:view];
    
}
-(instancetype)initWithdatasource:(NSArray*)datasource partblock:(selectedDevicePartBlock)partblock{
    if (self == [super init]) {
        _devicePartBlock = partblock;
        _datasource = datasource;
        [self setupUI];
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
    titleLab.text = @"请选择配件";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:17];
    [updateView addSubview:titleLab];
    [self showWithAlert:bgView];
    
    //tableview
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLab.frame)+6, updateView.frame.size.width, updateView.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 50;
        [updateView addSubview:_tableView];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
        
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    DevicePartsModel * model = self.datasource[indexPath.row];
    
    cell.textLabel.text = model.PartsDetailName;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //配件id
    
    DevicePartsModel * model = self.datasource[indexPath.row];
    
    if (self.devicePartBlock) {
        self.devicePartBlock(model.MaintainFacilityPartsId, model.PartsDetailName);
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

-(void)cancel{
    [self dismissAlert];
}
@end
