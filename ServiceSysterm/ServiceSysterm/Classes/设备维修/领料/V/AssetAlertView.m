//
//  AssetAlertView.m
//  SLPersonnelSystem
//
//  Created by Andy on 2019/4/22.
//  Copyright © 2019 深圳市深联电路有限公司. All rights reserved.
//

#import "AssetAlertView.h"
#import "AssetConst.h"

#import "ToolBar.h"


@interface AssetAlertView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy)NSString * code;

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSMutableArray * datasource;

@property (nonatomic,strong)NSMutableArray * placeholdContents;

@property (nonatomic,strong)ToolBar * toolBar;

@end
@implementation AssetAlertView


+(void)showassetAlertViewWithCode:(NSString*)code{
    AssetAlertView *assetView = [[AssetAlertView alloc]initCode:code];
    [[UIApplication sharedApplication].delegate.window addSubview:assetView];
    
}

-(instancetype)initCode:(NSString*)codeStr{
    if (self = [super init]) {
        self.code = codeStr;
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
   
    
    //标题
    UILabel *titleLab = [UILabel new];
    titleLab.frame = CGRectMake(0, 10, updateView.frame.size.width, 18);
    titleLab.text = @"资产盘点";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:17];
    [updateView addSubview:titleLab];
    [self showWithAlert:bgView];
    
    //tableview
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLab.frame)+6, updateView.frame.size.width, updateView.frame.size.height -80) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 50;
        [updateView addSubview:_tableView];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
        
        
    }
    
    //
    UIView * buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(updateView.frame)-60, updateView.frame.size.width, 50)];
    buttonView.backgroundColor = [UIColor whiteColor];
    [updateView addSubview:buttonView];
    
    
    
    NSArray * titles = @[@"取消",@"确定"];
    for (NSInteger i = 0; i <2; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonView.frame.size.width/2*i, 0, buttonView.frame.size.width*0.5, 50);
        button.backgroundColor = RGBA(242, 242, 242, 1);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+i;
        [buttonView addSubview:button];
    }
    //加一条线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(buttonView.frame.size.width*0.5, 15, 2, 20)];
    line.backgroundColor = [UIColor lightGrayColor];
    line.layer.cornerRadius = 3.f;
    line.clipsToBounds = YES;
    [buttonView addSubview:line];
    
}

-(void)buttonclick:(UIButton*)sender{
    [self dismissAlert];
    if (sender.tag == 101) {
        if (self.updateBlock) {
            self.updateBlock();
        }
    }
}

#pragma mark == == =tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
//    cell.titleLab.text = self.datasource[indexPath.row];
//    cell.titleTextField.placeholder = self.placeholdContents[indexPath.row];
//    cell.titleTextField.inputAccessoryView = self.toolBar;
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
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

#pragma mark == = = = = = = ==toolbar
- (ToolBar *)toolBar{
    if (!_toolBar) {
        _toolBar = [ToolBar toolBar];
        
        __weak typeof(self) weakself = self;
        _toolBar.finishBlock = ^(){
            [weakself endEditing:YES];
        };
    }
    return _toolBar;
}
-(NSMutableArray*)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
        NSArray * arr = @[@"资产名称",@"存放位置",@"盘点状态",@"备注"];
        [_datasource addObjectsFromArray:arr];
        
    }
    return _datasource;
}
-(NSMutableArray*)placeholdContents{
    if (!_placeholdContents) {
        NSArray * arr = @[@"请输入资产名称",@"请输入存放位置",@"",@"请输入备注"];
        _placeholdContents = [NSMutableArray array];
        [_placeholdContents addObjectsFromArray:arr];
    }
    return _placeholdContents;
}
@end
