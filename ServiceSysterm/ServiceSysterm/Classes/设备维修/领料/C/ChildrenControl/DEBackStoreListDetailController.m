//
//  DEBackStoreListDetailController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/6/4.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEBackStoreListDetailController.h"
#import "DEBackStoreDetailCheckTableCell.h"

#import "YBPopupMenu.h"

#import "DEMaterialDetailModel.h"
@interface DEBackStoreListDetailController ()<YBPopupMenuDelegate,UITextFieldDelegate,UITextViewDelegate>{
    NSMutableArray * operationArray;
}
@property (nonatomic,strong)NSMutableArray * cellContentArray;
@property (nonatomic,strong)NSMutableArray * returnBillList;
@end

@implementation DEBackStoreListDetailController

-(NSMutableArray*)cellContentArray{
    if (!_cellContentArray) {
        _cellContentArray =[NSMutableArray array];
    }return _cellContentArray;
}
-(NSMutableArray*)returnBillList{
    if (!_returnBillList) {
        _returnBillList =[NSMutableArray array];
    }return _returnBillList;
}

-(void)getMessage{
    NSDictionary * parm = @{@"ReturnBillId":self.returnBillId};
    KWeakSelf
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    [HttpTool POST:[DeviceBackStoreListDetailURL getWholeUrl] param:parm success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:weakSelf.view];
        if ([[responseObject objectForKey:@"status"]integerValue]==0) {
            NSDictionary * dict = [Units jsonToDictionary:responseObject[@"data"]];
            DEMaterialDetailModel *model = [DEMaterialDetailModel mj_objectWithKeyValues:dict];
            NSMutableArray * arr = [DEReturnBillDetailModel mj_objectArrayWithKeyValuesArray:model.ReturnBillDetailList];
            [weakSelf.returnBillList addObjectsFromArray:arr];
            [weakSelf.datasource addObject:model];
            
            debugLog(@"= = =%@",model.Status);
            NSArray * arr1 = @[[NSString stringWithFormat:@"开单人:%@--%@",model.DepName,model.ReturnByName],
                               [NSString stringWithFormat:@"开料单号:%@",model.MatRequisitionCode],
                               [NSString stringWithFormat:@"回仓单号:%@",model.ReturnBillNum],[NSString stringWithFormat:@"回仓时间:%@",model.ReturnOn],[NSString stringWithFormat:@"单状态:%@",[weakSelf getOrderStatus:model.Status]]];
            [weakSelf.cellContentArray addObjectsFromArray:arr1];
            //设置操作按钮
            [weakSelf setupRIghtItem:model];
            
             debugLog(@" - -- --%@",dict);
        }
        [weakSelf.tableView reloadData];
    } error:^(NSString * _Nonnull error) {
        [Units hiddenHudWithView:weakSelf.view];
        
    }];
}


//单状态
-(NSString*)getOrderStatus:(NSString*)idx{
    NSString * status;
    
    switch ([idx integerValue]) {
        case -10:
            status =@"作废";
            break;
        case 0:
            status =@"待提交";
            break;
        case 1:
            status =@"退回";
            break;
        case 5:
            status =@"待部门审核";
            break;
        case 13:
            status =@"待IQC";
            break;
        case 15:
            status =@"待入库";
            break;
        case 20:
            status =@"回仓成功";
            break;
        case 21:
            status =@"回仓失败";
            
        default:
            break;
    }
    return status;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"单详情";
    
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle  =UITableViewCellSeparatorStyleSingleLine;
    self.tableView.estimatedRowHeight =100.0f;
    [self.tableView registerNib:[UINib nibWithNibName:@"DEBackStoreDetailCheckTableCell" bundle:nil] forCellReuseIdentifier:@"sotckCellId"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    
    [self getMessage];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0) {
        return self.cellContentArray.count;
    }else{
        return self.returnBillList.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cellId"];
        cell.textLabel.font =[UIFont systemFontOfSize:15];
        cell.selectionStyle =UITableViewCellEditingStyleNone;
        cell.textLabel.text = self.cellContentArray[indexPath.row];
        return cell;
    }else{
        DEBackStoreDetailCheckTableCell *cell =[tableView dequeueReusableCellWithIdentifier:@"sotckCellId"];
        DEReturnBillDetailModel *model = self.returnBillList[indexPath.row];
        cell.model =model;
        //判断能否输入
        DEMaterialDetailModel * detailModel = [self.datasource firstObject];
        if (detailModel.TaskModel) {
            cell.reasonTextField.userInteractionEnabled = YES;
            cell.backstoreNumberTextField.enabled = YES;
            cell.reasonTextField.delegate =self;
            cell.backstoreNumberTextField.delegate =self;
            cell.reasonTextField.tag = indexPath.row;
            cell.backstoreNumberTextField.tag =indexPath.row;
        }else{
            cell.reasonTextField.userInteractionEnabled =NO;
            cell.backstoreNumberTextField.enabled =NO;
        }
       
        return cell;
    }
}

//复制功能

-(void)tapCopy{
    UILongPressGestureRecognizer * tap =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tap.minimumPressDuration =1.0f;
}

-(void)tap:(UITapGestureRecognizer*)tap{
    
}
//textFieldDelegate

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textField.tag inSection:1];
    DEBackStoreDetailCheckTableCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    DEReturnBillDetailModel * model = self.returnBillList[indexPath.row];
    if ([textField isEqual:cell.backstoreNumberTextField]) {
        model.backStoreCount = textField.text;
    }else{
        model.backStoreReason = textField.text;
    }
    
    return YES;
}
-(void)setupRIghtItem:(DEMaterialDetailModel*)model{
    //taskmodel 返回的是一个字典 判断字典是否为空
     operationArray =[NSMutableArray array];
    if (model.TaskModel) {
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"操作" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(operation:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem =[[UIBarButtonItem alloc]initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem = rightItem;
        [operationArray addObject:model.TaskModel[@"taskName"]];
    }else{
        self.navigationItem.rightBarButtonItem =nil;
    }
}

-(void)operation:(UIButton*)item{
    //下拉选择框
   
    
    [YBPopupMenu showRelyOnView:item titles:operationArray icons:nil menuWidth:120 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.dismissOnSelected = NO;
        popupMenu.isShowShadow = YES;
        popupMenu.delegate = self;
        popupMenu.offset = 10;
        popupMenu.type = YBPopupMenuTypeDark;
        popupMenu.backColor = [UIColor whiteColor];
        popupMenu.textColor = [UIColor blackColor];
        popupMenu.maxVisibleCount =10;
        popupMenu.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    }];
}

-(void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    NSString *tipString = operationArray[index];
    if ([tipString isEqualToString:@"仓管员核实"]) {
        [self alertView:tipString];
    }
    [ybPopupMenu dismiss];
}

-(void)alertView:(NSString*)alertString{
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:alertString message:nil preferredStyle:UIAlertControllerStyleAlert];
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请填写备注(必填)";
    }];
    UIAlertAction * action1 =[UIAlertAction actionWithTitle:@"通过" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction * action2 =[UIAlertAction actionWithTitle:@"驳回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * action3 =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:action1];
    [controller addAction:action2];
    [controller addAction:action3];
    [self presentViewController:controller animated:YES completion:nil];
}
@end
