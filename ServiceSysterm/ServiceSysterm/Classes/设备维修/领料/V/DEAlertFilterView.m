//
//  DEAlertFilterView.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/10.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEAlertFilterView.h"
#import "AssetConst.h"
#import "EDDatePickerView.h"
#import "DEMaterialListTableCell.h"
#import "DEBackStockAlertTableCell.h"
@interface DEAlertFilterView ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSMutableArray *_datasouce;
    NSInteger _flag;
}
@property (nonatomic,strong)UITableView * tableView;
@end
@implementation DEAlertFilterView



+(void)showAlertViewDatasouce:(NSMutableArray*)datasouce flag:(NSInteger)flag timeBlock:(chosTimeBlock)timeBlock{
    DEAlertFilterView * alertView = [[DEAlertFilterView alloc]initWithArray:datasouce flag:flag timeBlock:timeBlock];
    [[UIApplication sharedApplication].delegate.window addSubview:alertView];
    
}


-(instancetype)initWithArray:(NSMutableArray*)array flag:(NSInteger)flag timeBlock:(chosTimeBlock)timeBlock{
    if (self =[super init]) {
        _timeBlock = timeBlock;
        _datasouce = array;
        _flag = flag;
        
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
    titleLab.text =_flag==1001?@"物料清单":@"回仓申请";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:17];
    [updateView addSubview:titleLab];
    [self showWithAlert:bgView];
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLab.frame)+6, updateView.frame.size.width, updateView.frame.size.height -80) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight =100.0f;
        [updateView addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"DEMaterialListTableCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DEBackStockAlertTableCell" bundle:nil] forCellReuseIdentifier:@"stockCellId"];
        
        
    }
    
    //
    UIView * buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(updateView.frame)-60, updateView.frame.size.width, 50)];
    buttonView.backgroundColor = [UIColor whiteColor];
    [updateView addSubview:buttonView];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, buttonView.frame.size.width, buttonView.frame.size.height);
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sureCommit) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:btn];
    
    
    
    
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datasouce.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        DEMaterialListTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        DEMaterialDetailModel * model = _datasouce[indexPath.row];
        cell.model = model;
        return cell;
}

-(void)cancel{
    [self dismissAlert];
}

//textfield




-(void)sureCommit{
//    [self endEditing:YES];
    if (_flag ==1002) {
//
//        NSMutableArray *ReturnBillDetailList =[NSMutableArray array];
//        for (DEMaterialDetailModel *model in _datasouce) {
//            if ([model.backStoreCount integerValue] >[model.StockCount integerValue]) {
//                [Units showErrorStatusWithString:@"回仓个数不能大于出库个数"];
//                return;
//            }if (model.backStoreCount.length == 0) {
//                [Units showErrorStatusWithString:@"回仓个数不能为零"];
//                return;
//            }if (model.backStoreReason.length == 0) {
//                [Units showErrorStatusWithString:@"请填写回仓原因"];
//                return;
//            }
//             NSMutableDictionary *ReturnBillDict =[NSMutableDictionary dictionary];
//            [ReturnBillDict setObject:model.MaterialCode forKey:@"MaterialCode"];
//            [ReturnBillDict setObject:model.MaterialName forKey:@"MaterialName"];
//            [ReturnBillDict setObject:model.MaterialInfo forKey:@"MaterialInfo"];
//            [ReturnBillDict setObject:[NSString stringWithFormat:@"%@/%@",model.MaterialName,model.MaterialInfo] forKey:@"MaterialRecord"];
//            [ReturnBillDict setObject:model.UnitName forKey:@"StockUnit"];
//            [ReturnBillDict setObject:model.StockOutRecordId forKey:@"StockRecordId"];
//            [ReturnBillDict setObject:model.StockCount forKey:@"StockCount"];
//
//            [ReturnBillDict setObject:model.backStoreCount forKey:@"ReturnCount"];
//            [ReturnBillDict setObject:model.StockCount forKey:@"ActCount"];
//            [ReturnBillDict setObject:model.StockUnitId forKey:@"StockUnitId"];
//            [ReturnBillDict setObject:model.MaterialId forKey:@"MaterialId"];
//            [ReturnBillDict setObject:model.backStoreReason forKey:@"Reason"];
//            [ReturnBillDict setObject:model.Barcode forKey:@"Barcode"];
//            [ReturnBillDict setObject:model.BarcodeId forKey:@"BarcodeId"];
//            [ReturnBillDict setObject:@1 forKey:@"ListOperation"];
//
//            [ReturnBillDetailList addObject:ReturnBillDict];
//        }
//        if (self.timeBlock) {
//            self.timeBlock(ReturnBillDetailList);
//        }
    }else{
        [self dismissAlert];
    }
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
    KWeakSelf
    [UIView animateWithDuration:SELAnimationTimeInterval animations:^{
        //self.transform = (CGAffineTransformMakeScale(1.5, 1.5));
        weakSelf.backgroundColor = [UIColor clearColor];
        weakSelf.alpha = 0;
    }completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    } ];
    
}

@end
