//
//  ApplyFinishAlertView.m
//  ServiceSysterm
//
//  Created by Andy on 2019/8/10.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "ApplyFinishAlertView.h"
#import "AssetConst.h"

#import "SelectedMemberTableCell.h"
@interface ApplyFinishAlertView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSArray * datasource;


@property (nonatomic,strong)NSMutableDictionary * selectedItemDictionary;
@property (nonatomic,strong)NSMutableArray * selectedItemArray;//多选数组
@end
@implementation ApplyFinishAlertView

+(void)showAlertWithSource:(NSMutableArray*)source maintainBlock:(chosMaintainIdBlock)maintainBlock{
    ApplyFinishAlertView *alertView = [[ApplyFinishAlertView alloc]initWithSource:source maintainIdBlock:maintainBlock];
    [[UIApplication sharedApplication].delegate.window addSubview:alertView];
}

-(instancetype)initWithSource:(NSMutableArray*)source  maintainIdBlock:(chosMaintainIdBlock)maintainIdBlock{
    if (self = [super init]) {
        _datasource = source;
        _maintainIdBlock = maintainIdBlock;
        
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
    titleLab.text = @"请选择故障类型";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:17];
    [updateView addSubview:titleLab];
    [self showWithAlert:bgView];
    
    //tableview
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLab.frame)+6, updateView.frame.size.width, updateView.frame.size.height-60) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 50.0f;
        [updateView addSubview:_tableView];
       [_tableView registerNib:[UINib nibWithNibName:@"SelectedMemberTableCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
        
        
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
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    SelectedMemberTableCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cellId"];
    cell.textLabel.font =[UIFont systemFontOfSize:16.0f];
   
    DetailMemberModel * model = self.datasource[indexPath.row];
    NSString * type;
    if ([model.FinishFlag isEqualToString:@"0"]) {
        type =@"未完成";
    }else if ([model.FinishFlag isEqualToString:@"1"]){
        type = @"待复核";
    }else{
        type =@"已完成";
    }
    cell.tipLab.text = [NSString stringWithFormat:@"%@(%@)",model.ContentName,type];
    cell.selectedButton.tag = indexPath.row;
    
    if ([model.selectedType isEqualToString:@"单选"]) {
        //单选
        NSArray * btns = [self.selectedItemDictionary allValues];
        for (NSString * selectedItem  in btns) {
            if ([selectedItem integerValue]== indexPath.row) {
                cell.selectedButton.selected = YES;
            }else{
                cell.selectedButton.selected =NO;
            }
        }
    }else{
        //多选
        NSArray * selectedItems = [self.selectedItemDictionary allValues];
        for (NSString * str  in selectedItems) {
            if ([str integerValue]== indexPath.row) {
                cell.selectedButton.selected = YES;
            }else{
                cell.selectedButton.selected =NO;
            }
        }
    }
    
    
    
    KWeakSelf
    cell.selectedItemBlock = ^(UIButton * _Nonnull sender) {
        //事件回调
        if (!weakSelf.selectedItemDictionary) {
            weakSelf.selectedItemDictionary =[NSMutableDictionary dictionary];
            
        }
        if ([model.selectedType isEqualToString:@"单选"]) {
            //单选
            [weakSelf.selectedItemDictionary setObject:[NSString stringWithFormat:@"%ld",sender.tag] forKey:@"key"];
            [weakSelf.tableView reloadData];
        }else{
            //多选
            sender.selected =! sender.selected;
            if (sender.selected) {
                [self.selectedItemDictionary setObject:[NSString stringWithFormat:@"%ld",sender.tag] forKey: @(indexPath.row)];
            }else{
                [self.selectedItemDictionary removeObjectForKey:@(indexPath.row)];
            }
        }
        
    };
    return cell;
   
}
//确认选择
-(void)sureChos{
    
    NSString * tipString =nil;
    for (DetailMemberModel * model in self.datasource) {
        tipString = model.selectedType;
    }
    if ([tipString isEqualToString:@"单选"]) {
        NSString * str =[self.selectedItemDictionary objectForKey:@"key"];
        if (str.length == 0) {
            [Units showErrorStatusWithString:@"请选择人员"];
            return;
        }
        //单选
        NSInteger idx = [[self.selectedItemDictionary objectForKey:@"key"]integerValue];
        DetailMemberModel * model =self.datasource[idx];
        if (self.maintainIdBlock) {
            self.maintainIdBlock(model,nil);
        }
        
    }else if ([tipString isEqualToString:@"多选"]){
        
        //多选
        NSArray * selectedArray = [self.selectedItemDictionary allValues];
        if (selectedArray.count == 0) {
            [Units showErrorStatusWithString:@"请选择人员"];
            return;
        }
        if (!_selectedItemArray) {
            _selectedItemArray =[NSMutableArray array];
        }
        //多选
        for (NSString * str in selectedArray) {
            DetailMemberModel * selectedModel = [self.datasource objectAtIndex:[str integerValue]];
            if (![self.selectedItemArray containsObject:selectedModel]) {
                [self.selectedItemArray addObject:selectedModel];
            }
            
        }
        if (self.maintainIdBlock) {
            self.maintainIdBlock(nil, self.selectedItemArray);
        }
        
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
