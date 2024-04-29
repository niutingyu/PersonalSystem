//
//  AppointAlertView.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/30.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "AppointAlertView.h"
#import "AssetConst.h"

#import "SelectedMemberTableCell.h"
@interface AppointAlertView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableDictionary * selectedItemDictionary;
@property (nonatomic,strong)NSMutableArray * selectedItemArray;//多选数组
@end
@implementation AppointAlertView

+(void)showAlertWithDatasource:(NSMutableArray *)datasource itemCallbackBlock:(selectedItemBlock)itemCallbackBlock dismissBlock:(dismissBlock)dismissBlock{
    AppointAlertView * alertView =[[AppointAlertView alloc]initWithDatasource:datasource itemBlock:itemCallbackBlock dismiss:dismissBlock];
    [[UIApplication sharedApplication].delegate.window addSubview:alertView];
}


-(instancetype)initWithDatasource:(NSMutableArray*)datasource itemBlock:(selectedItemBlock)itemBlock dismiss:(dismissBlock)dismissBlock{
    if (self =[super init]) {
        _dataArray = datasource;
        _itemBlock = itemBlock;
        _disappearBlock = dismissBlock;
        [self setUI];
    }return self;
}
-(void)setUI{
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
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [updateView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(-2);
        make.right.mas_offset(2);
        make.width.height.mas_equalTo(36);
    }];
    if (!_tableView) {
        _tableView =[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource =self;
        _tableView.tableFooterView =[UIView new];
        [_tableView registerNib:[UINib nibWithNibName:@"SelectedMemberTableCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
        _tableView.rowHeight = 50.0f;
        [updateView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.top.mas_offset(38);
            make.bottom.mas_offset(-45);
        }];
    }
    
    UIButton * sureButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sureButton.backgroundColor = RGBA(242, 242, 242, 1);
    [sureButton addTarget:self action:@selector(sureChos) forControlEvents:UIControlEventTouchUpInside];
    [updateView addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.mas_equalTo(40);
        
    }];
    
     [self showWithAlert:updateView];
    
}



-(void)cancel{
    //取消
    [self dismissAlert];
    if (self.disappearBlock) {
        self.disappearBlock();
    }
  
}

//确认选择
-(void)sureChos{
  
    NSString * tipString =nil;
    for (DetailMemberModel * model in self.dataArray) {
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
         DetailMemberModel * model =self.dataArray[idx];
        if (self.itemBlock) {
            self.itemBlock(model, nil);
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
            DetailMemberModel * selectedModel = [self.dataArray objectAtIndex:[str integerValue]];
            if (![self.selectedItemArray containsObject:selectedModel]) {
                [self.selectedItemArray addObject:selectedModel];
            }
            
        }
        if (self.itemBlock) {
            self.itemBlock(nil, self.selectedItemArray);
        }
        
    }
   
   
   
    [self dismissAlert];
   
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectedMemberTableCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cellId"];
    cell.textLabel.font =[UIFont systemFontOfSize:16.0f];
    DetailMemberModel * model = self.dataArray[indexPath.row];
    cell.tipLab.text = [NSString stringWithFormat:@"%@(%@)",model.FName,model.UserName];
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0f;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"选择人员";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
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


@end
