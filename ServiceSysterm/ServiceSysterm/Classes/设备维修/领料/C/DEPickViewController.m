//
//  DEPickViewController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/30.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEPickViewController.h"
#import "DEPickNewOrderTableCell.h"
#import "ToolBar.h"
#import "DECommitTableCell.h"
#import "DEMaterialTableCell.h"
#import "DEChosMessageController.h"
#import "DEPickChosMaterialController.h"
#import "DEReStockController.h"
#import "DWBubbleMenuButton.h"
#import "RegisterOutStockController.h"

#import "DeviceRepairTabController.h"
#import "DeviceNavController.h"
#import "DEPickChosMaterialModel.h"
#import <IQKeyboardManager.h>

#import "YBPopupMenu.h"

#import "MoudleModel.h"

#define FactoryId @"factoryId"//工厂id

#define MaterialType @"materialType"//领料类型

#define SelectedMaterialId @"materialId"//物料id

#define ApplyReason @"reason"//申请原因

#define ProcessName @"processName"//工序名称

#define MaterialCode @"materialCode"//领料单号

#define FIRSTFACTROY @"EB1F3A86937443E89F8ADBB555E7ACFE"//赣州一厂

#define SECONDFACTORY @"ebf619b20cfc465dabdd6179cefc22bf"//赣州二厂三场

@interface DEPickViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,YBPopupMenuDelegate>{
   
}
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * datasource;
@property (nonatomic,strong)ToolBar *tool;
@property (nonatomic,strong)NSMutableArray * chosMatrialArray;//选择的物料
@property (nonatomic,strong)NSMutableArray * contentArray;//内容数组

@property (strong,nonatomic)NSMutableDictionary * selectedMutableIdDictionary;//选中的设备id

@property (nonatomic,copy)NSString *factoryId;//工厂id

@end

@implementation DEPickViewController

-(NSMutableDictionary*)selectedMutableIdDictionary{
    if (!_selectedMutableIdDictionary) {
        _selectedMutableIdDictionary =[NSMutableDictionary dictionary];
        //取出工厂
                NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
                MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
                [modleArchiver finishDecoding];
         NSString * factoryName = moudleStatus.FactoryList[0][@"FactoryName"];
        if ([factoryName containsString:@"赣州一厂"]) {
            //G1
            [_selectedMutableIdDictionary setObject:FIRSTFACTROY forKey:ProcessName];
        }else{
            //G2.G3
         [_selectedMutableIdDictionary setObject:SECONDFACTORY forKey:ProcessName];
        }
        
    }return _selectedMutableIdDictionary;
}
-(NSMutableArray*)chosMatrialArray{
    if (!_chosMatrialArray) {
        _chosMatrialArray   =[NSMutableArray array];
    }
    return _chosMatrialArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)clickPopMenu:(UIButton*)sender{
    //下拉选择框
    NSArray * titles =@[@"回仓",@"出库"];
    [YBPopupMenu showRelyOnView:sender titles:titles icons:nil menuWidth:120 otherSettings:^(YBPopupMenu *popupMenu) {
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
- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enable =YES;
    self.navigationItem.title = @"领料开单";
   
    [self.view addSubview:self.tableView];
    self.view.backgroundColor =[UIColor whiteColor];
     [self creatslidebutton];
    
}
#pragma mark == = = = ==弹出按钮

-(void)creatslidebutton{

    UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"ios-more"] forState:UIControlStateNormal];
  //  btn.bounds = CGRectMake(0, 0, 50, 30);
    btn.imageView.contentMode =UIViewContentModeScaleAspectFit;
    [btn addTarget:self action:@selector(clickPopMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    [ybPopupMenu dismiss];
    if (index == 0) {
     [self.navigationController pushViewController:[DEReStockController new] animated:YES];
    }else{
        [self.navigationController pushViewController:[RegisterOutStockController new] animated:YES];
    }
   
}


#pragma mark tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0) {
        return self.datasource.count;
    }else if (section ==1){
        return self.chosMatrialArray.count;
    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return 50.0f;
    }else if (indexPath.section ==1){
        if (self.chosMatrialArray.count ==0) {
            return CGFLOAT_MIN;
        }else{
            return 158.0f;
        }
    }
    return 80.0f;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        DEPickNewOrderTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        cell.tipTitleLab.text = [NSString stringWithFormat:@"%@:",self.datasource[indexPath.row]];
        NSString * tipString = self.datasource[indexPath.row];
        if ([tipString isEqualToString:@"领料工厂"]) {
            cell.contentTextField.inputView = [UIView new];
            cell.contentTextField.placeholder = @"请选择领料工厂";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.contentTextField.enabled =YES;
        }else if ([tipString isEqualToString:@"工序名称"]){
            cell.contentTextField.placeholder =@"选择工序名称";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.contentTextField.enabled =YES;
        }else if ([tipString isEqualToString:@"领料类型"]){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.contentTextField.placeholder =@"请选择领料类型";
            cell.contentTextField.enabled =YES;
        }
        else if ([tipString isEqualToString:@"领料单号"]||[tipString isEqualToString:@"设备名称"]||[tipString isEqualToString:@"所属工序"]||[tipString isEqualToString:@"申请人"]){
            cell.contentTextField.enabled = NO;
            cell.accessoryType =UITableViewCellAccessoryNone;
            
        }else if ([tipString isEqualToString:@"申请物品"]){
            cell.contentTextField.placeholder = @"选择申请物品";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.contentTextField.enabled =YES;
        }
        else{
            cell.contentTextField.inputAccessoryView  = self.tool;
        }
        cell.contentTextField.delegate = self;
        cell.contentTextField.tag = indexPath.row;
        if (self.contentArray.count>0) {
        cell.contentTextField.text = self.contentArray[indexPath.row]?:@"";
        }
        
        return cell;
    }else if (indexPath.section == 1){
        DEMaterialTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"materialCellId"];
        DEPickChosMaterialModel * model = self.chosMatrialArray[indexPath.row];
        cell.materialArray =self.chosMatrialArray;
        cell.countTextField.tag = indexPath.row;
        cell.remarkTextField.tag = indexPath.row;
        cell.countTextField.delegate =self;
        cell.remarkTextField.delegate =self;
        cell.remarkTextField.inputAccessoryView =self.tool;
        cell.countTextField.inputAccessoryView =self.tool;
        cell.countTextField.keyboardType = UIKeyboardTypeNumberPad;
        cell.model = model;
        
        return cell;
    }
    else{
        DECommitTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"commitCellId"];
        KWeakSelf
        cell.commitMessage = ^{
        //提交
            [weakSelf commitOrder];
        };
        return cell;
    }
   
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return @"基础信息";
    }else if (section ==1){
        if (self.chosMatrialArray.count == 0) {
            return nil;
        }else{
            return [NSString stringWithFormat:@"物品清单:个数(%ld)",self.chosMatrialArray.count];
        }
    }
    else{
        return nil;
    }
    
}

#pragma mark --删除cell
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==1) {
        return YES;
    }return NO;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
   [_chosMatrialArray removeObjectAtIndex:indexPath.row];
    
   [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    
}
#pragma mark ==textfield
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textField.tag inSection:1];
    DEMaterialTableCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([textField isEqual:cell.countTextField] ||[textField isEqual:cell.remarkTextField]) {
        return;
    }
    NSString * tipString = self.datasource[textField.tag];
    if ([tipString isEqualToString:@"领料工厂"]) {
        [self loadFactoryMessage:textField.tag];
    }else if ([tipString isEqualToString:@"领料类型"]){
       
     
        DEChosMessageController * controller = [DEChosMessageController new];
        controller.chosIdx = 1000;
        controller.factoryId  =_factoryId;
        [self.navigationController pushViewController:controller animated:YES];
        KWeakSelf
        controller.passCodeMessage = ^(DeviceCodeModel * _Nonnull messageModel) {
        //领料类型
            [weakSelf.selectedMutableIdDictionary setObject:messageModel.AssociateMaintId forKey:SelectedMaterialId];//领料id
            
            [weakSelf.selectedMutableIdDictionary setObject:messageModel.RequisitionType forKey:MaterialType];//领料类型
            
            [weakSelf.selectedMutableIdDictionary setObject:messageModel.TaskCode forKey:MaterialCode];//领料单号
            
            [weakSelf.contentArray replaceObjectAtIndex:textField.tag withObject:messageModel.RequisitionTypeName];
            
            [weakSelf.datasource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:@"领料单号"]) {
                    [weakSelf.contentArray replaceObjectAtIndex:idx withObject:messageModel.TaskCode];
                }else if ([obj isEqualToString:@"设备名称"]){
                    [weakSelf.contentArray replaceObjectAtIndex:idx withObject:messageModel.FacilityName];
                }else if ([obj isEqualToString:@"所属工序"]){
                    [weakSelf.contentArray replaceObjectAtIndex:idx withObject:messageModel.DepName];
                }
            }];
            [weakSelf.tableView reloadData];
        };
    }else if ([tipString isEqualToString:@"工序名称"]){
        DEChosMessageController * controller = [DEChosMessageController new];
        controller.chosIdx = 1001;
       
        [self.navigationController pushViewController:controller animated:YES];
        KWeakSelf

        controller.passCodeMessage = ^(DeviceCodeModel * _Nonnull messageModel) {
          //  debugLog(@"-  -%@ %@%ld",messageModel.OrId,messageModel.Name,textField.tag);
            [weakSelf.contentArray replaceObjectAtIndex:textField.tag withObject:messageModel.FacilityDpartName];
            
            [weakSelf.selectedMutableIdDictionary setObject:messageModel.FacilityId forKey:ProcessName];//赋值工序id
            
            [weakSelf.tableView reloadData];
        };
    }else if ([tipString isEqualToString:@"申请物品"]){
        DEPickChosMaterialController * controller = [DEPickChosMaterialController new];
        controller.selectedMaterialArray = self.chosMatrialArray;
        [self.navigationController pushViewController:controller animated:YES];
        
        //选择物料回调
        KWeakSelf
        controller.chosMaterialBlock = ^(NSMutableArray * _Nonnull materials) {
          
            [weakSelf.chosMatrialArray removeAllObjects];
            [weakSelf.chosMatrialArray addObjectsFromArray:materials];
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        };
       
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.chosMatrialArray.count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textField.tag inSection:1];
        DEMaterialTableCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if ([textField isEqual:cell.countTextField]) {
           DEPickChosMaterialModel *model = self.chosMatrialArray[indexPath.row];
            model.applyNumber = textField.text;
        }else if ([textField isEqual:cell.remarkTextField]){
            DEPickChosMaterialModel *model = self.chosMatrialArray[indexPath.row];
            model.Remark =textField.text;
        }
    }
   
    
    NSString * tipString = self.datasource[textField.tag];
    
    if ([tipString isEqualToString:@"申请原因"]) {
        [self.contentArray replaceObjectAtIndex:textField.tag withObject:textField.text];
        [self.selectedMutableIdDictionary setObject:textField.text forKey:ApplyReason];//申请原因
    }
}

#pragma mark == = = ====获取领料工厂
-(void)loadFactoryMessage:(NSInteger)idx{
    //取出工厂
    NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
    MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
    [modleArchiver finishDecoding];
    debugLog(@" == = %@",moudleStatus.FactoryList);
    if (moudleStatus.FactoryList.count ==1) {
        [self.view endEditing:YES];
        [Units showErrorStatusWithString:@"没有工厂可供选择"];
        
        return;
    }
    UIAlertController * controller =[UIAlertController alertControllerWithTitle:@"提示" message:@"请选择工厂" preferredStyle:UIAlertControllerStyleActionSheet];
    KWeakSelf;
    for (int i =0; i<moudleStatus.FactoryList.count; i++) {
        NSString *title = moudleStatus.FactoryList[i][@"FactoryName"];
        [controller addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.factoryId  = moudleStatus.FactoryList[i][@"FactoryId"];
            [weakSelf.contentArray replaceObjectAtIndex:idx withObject:action.title];
            
            //默认工序
            for (int i =0; i<weakSelf.datasource.count; i++) {
                NSString * tipString = weakSelf.datasource[i];

                if ([tipString isEqualToString:@"工序名称"]) {
                    if ([action.title containsString:@"赣州一厂"]) {
                        [weakSelf.contentArray replaceObjectAtIndex:i withObject:@"维修部"];
                        [weakSelf.selectedMutableIdDictionary setObject:FIRSTFACTROY forKey:ProcessName];
                    }else{
                        [weakSelf.contentArray replaceObjectAtIndex:i withObject:@"维修部(SE-II)"];
                        [weakSelf.selectedMutableIdDictionary setObject:SECONDFACTORY forKey:ProcessName];
                    }
                    
                }
            }
            [weakSelf.tableView reloadData];
            
        }]];
    }
    
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:controller animated:YES completion:^{
        [weakSelf.view endEditing:YES];
    }];
//    NSDictionary * dict = [NSDictionary dictionary];
//    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
//
//    [HttpTool POST:[DevicePickFactoryURL getWholeUrl] param:dict success:^(id  _Nonnull responseObject) {
//        [Units hiddenHudWithView:weakSelf.view];
//        if ([[responseObject objectForKey:@"status"]integerValue] ==0) {
//            NSArray * arr = [Units jsonToArray:responseObject[@"data"]];
//            NSMutableArray * titlesArray = [NSMutableArray array];
//            for (NSDictionary * dict in arr) {
//                [titlesArray addObject:dict];
//            }
//            //创建Alert
//            UIAlertController * controller = [UIAlertController alertControllerWithTitle:@"请选择领料工厂" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
//            for (int i =0; i<titlesArray.count; i++) {
//                UIAlertAction * action = [UIAlertAction actionWithTitle:titlesArray[i][@"FactoryName"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [weakSelf.contentArray replaceObjectAtIndex:idx withObject:action.title];
//                    //赋值选择的工厂id
//                    [weakSelf.selectedMutableIdDictionary setObject:titlesArray[idx][@"FactoryId"] forKey:FactoryId];
//                    [weakSelf.tableView reloadData];
//                }];
//                [controller addAction:action];
//            }
//            UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                [weakSelf.view endEditing:YES];
//            }];
//            [controller addAction:action1];
//            [weakSelf presentViewController:controller animated:YES completion:nil];
//        }
//
//    } error:^(NSString * _Nonnull error) {
//        [Units hiddenHudWithView:weakSelf.view];
//        [Units showErrorStatusWithString:error];
//    }];
}


#pragma mark ==提交

-(void)commitOrder{
    [self.view endEditing:YES];
    NSMutableDictionary * parms =[NSMutableDictionary dictionary];
   //取出领料工厂 领料类型 申请原因 工序名称
//    //领料工厂
//    NSNumber * factoryNum = [self.selectedMutableIdDictionary objectForKey:FactoryId];
    NSString * factoryString =[NSString stringWithFormat:@"%@",_factoryId];
    //领料类型
    NSString * materialType = [self.selectedMutableIdDictionary objectForKey:MaterialType];
    NSString * materialId = [self.selectedMutableIdDictionary objectForKey:SelectedMaterialId];
    //工序名称
    NSString * processName = [self.selectedMutableIdDictionary objectForKey:ProcessName];
    
    NSString * materialCode = [self.selectedMutableIdDictionary objectForKey:MaterialCode];//领料单号
    //申请原因
    NSString * applyReason = [self.selectedMutableIdDictionary objectForKey:ApplyReason];
    if (factoryString.length ==0) {
        [Units showHudWithText:@"请选择领料工厂" view:self.view model:MBProgressHUDModeText];
        return;
    }if (materialType.length ==0) {
        [Units showHudWithText:@"请选择领料类型" view:self.view model:MBProgressHUDModeText];
        return;
    }if (applyReason.length ==0) {
        [Units showHudWithText:@"请输入申请原因" view:self.view model:MBProgressHUDModeText];
        return;
    }if (processName.length ==0) {
        [Units showHudWithText:@"请选择工序" view:self.view model:MBProgressHUDModeText];
        return;
    }
    if (self.chosMatrialArray.count ==0) {
        [Units showHudWithText:@"请选择申请物品" view:self.view model:MBProgressHUDModeText];
        return;
    }
    [parms setObject:_factoryId forKey:@"FactoryId"];
    [parms setObject:USERDEFAULT_object(@"orderId") forKey:@"DepId"];
    [parms setObject:[NSString stringWithFormat:@"%@-%@",applyReason,materialCode] forKey:@"Reason"];//申请原因
    [parms setObject:USERDEFAULT_object(USERID) forKey:@"RequisitionBy"];
    [parms setObject:[Units getNowDate:0] forKey:@"RequisitionOn"];//开单时间 默认当前时间
    [parms setObject:materialType forKey:@"RequisitionType"];//领料类型
    [parms setObject:@(0) forKey:@"HasPrint"];
    [parms setObject:@(0) forKey:@"PrintCount"];
    [parms setObject:processName forKey:@"ProcedureId"];//工序
    [parms setObject:materialId forKey:@"AssociateMaintId"];//单id
    NSMutableArray * materialArray =[NSMutableArray array];
    for (DEPickChosMaterialModel *model in self.chosMatrialArray) {
        NSMutableDictionary * materialParms =[NSMutableDictionary dictionary];
        [materialParms setObject:model.MaterialId forKey:@"MaterialId"];
        [materialParms setObject:model.PurchaseUnitId forKey:@"Unit"];
        
        if ([model.applyNumber integerValue]>[model.CountAll integerValue]) {
            [Units showErrorStatusWithString:@"申请数量大于库存"];
            return;
        }
        [materialParms setObject:model.applyNumber?:@"1" forKey:@"ApplyCount"];
        if (model.Remark.length) {
            [materialParms setObject:model.Remark forKey:@"Remark"];
        }
        [materialArray addObject:materialParms];
    }
    debugLog(@"==vv= =%@",parms);
    [parms setObject:materialArray forKey:@"DetailList"];
    NSMutableDictionary * childrenParms =[NSMutableDictionary dictionary];
    [childrenParms setObject:[Units dictionaryToJson:parms] forKey:@"model"];
    KWeakSelf
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    [HttpTool POST:[DeviceGetMaterialCommit getWholeUrl] param:childrenParms success:^(id  _Nonnull responseObject) {
        [Units hideView];
        [Units showHudWithText:responseObject[@"info"] view:weakSelf.view model:MBProgressHUDModeText];
        if ([[responseObject objectForKey:@"status"]intValue]==0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            });
        }
       
    } error:^(NSString * _Nonnull error) {
        [Units hideView];
        [Units showErrorStatusWithString:error];
      
    }];
    
    
    
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = RGBA(242, 242, 242, 1);
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DEPickNewOrderTableCell class]) bundle:nil] forCellReuseIdentifier:@"cellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DEMaterialTableCell" bundle:nil] forCellReuseIdentifier:@"materialCellId"];
        [_tableView registerClass:[DECommitTableCell class] forCellReuseIdentifier:@"commitCellId"];
        
    }
    return _tableView;
}
-(NSMutableArray*)datasource{
    if (!_datasource) {
        NSArray  * arr = @[@"申请人",@"领料工厂",@"领料类型",@"领料单号",@"设备名称",@"所属工序",@"申请原因",@"工序名称",@"申请物品"];
        _datasource = [NSMutableArray array];
        [_datasource addObjectsFromArray:arr];
    }
    return _datasource;
}
-(NSMutableArray*)contentArray{
    if (!_contentArray) {
        _contentArray =[[NSMutableArray alloc]initWithCapacity:self.datasource.count];
        for (int i =0; i<self.datasource.count; i++) {
            [_contentArray addObject:@""];
        }
        [_contentArray replaceObjectAtIndex:0 withObject:USERDEFAULT_object(CodeName)];
        //取出工厂
         NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
         MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
         [modleArchiver finishDecoding];
        if (moudleStatus.FactoryList.count >0) {
            [_contentArray replaceObjectAtIndex:1 withObject:moudleStatus.FactoryList[0][@"FactoryName"]];
            _factoryId  =moudleStatus.FactoryList[0][@"FactoryId"];
            NSString * factoryName = moudleStatus.FactoryList[0][@"FactoryName"];
            if ([factoryName containsString:@"G1"]) {
               //G1
                [_contentArray replaceObjectAtIndex:7 withObject:@"维修部"];
              
            }else{
              //G2.G3
                [_contentArray replaceObjectAtIndex:7 withObject:@"维修部(SE-II)"];
                
            }
            
        }
        //默认工序名称
        
    }return _contentArray;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
 
}
-(void)dealloc{
    
}
#pragma mark - 键盘' 完成按键'
- (ToolBar *)tool{
    if (!_tool) {
        _tool = [ToolBar toolBar];
        
        __weak typeof(self) weakself = self;
        _tool.finishBlock = ^(){
            [weakself.view endEditing:YES];
        };
    }
    return _tool;
}


@end
