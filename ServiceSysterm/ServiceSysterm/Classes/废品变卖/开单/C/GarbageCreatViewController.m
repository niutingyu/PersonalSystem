//
//  GarbageCreatViewController.m
//  ServiceSysterm
//
//  Created by Andy on 2021/8/19.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "GarbageCreatViewController.h"
#import "GarbageOrderHeadTableCell.h"
#import "GarbageNameTableViewCell.h"
#import "GarbageFootAddView.h"
#import "ZHPickView.h"
#import "GarbageOrdrModel.h"
#import "GarbageRecyclerModel.h"
#import "MoudleModel.h"
@interface GarbageCreatViewController ()<ZHPickViewDelegate,UITextFieldDelegate>



@property (nonatomic,strong)NSMutableArray *orderList;

@property (nonatomic,strong)NSMutableArray *orderNameList;

/**
 回收商
 */
@property (nonatomic,strong)NSMutableArray *recycerList;

/**
 回收商ID
 */
@property (nonatomic,copy)NSString *recycleId;

/**
 备注信息
 */
@property (nonatomic,copy)NSString *remarkStr;

@property (nonatomic,strong)UITableView *listView;

@end

NSString *const garbageReusedCellId =@"garbageReusedCellId";
NSString *const garbageNameReusedCellId =@"garbageNameReusedCellId";
@implementation GarbageCreatViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"开单";
   
    
    [self.view addSubview:self.listView];
   
    self.listView.separatorStyle  =UITableViewCellSeparatorStyleSingleLine;
    [self.listView registerClass:[GarbageOrderHeadTableCell class] forCellReuseIdentifier:garbageReusedCellId];
    [self.listView registerNib:[UINib nibWithNibName:@"GarbageNameTableViewCell" bundle:nil] forCellReuseIdentifier:garbageNameReusedCellId];
    
    UIBarButtonItem * rightItem =[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commitMethod)];
    self.navigationItem.rightBarButtonItem  =rightItem;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.orderNameList.count+1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section  ==0) {
        return self.orderList.count;
    }else{
        return 1;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section  ==0) {
        GarbageOrderHeadTableCell * cell  =[tableView dequeueReusableCellWithIdentifier:garbageReusedCellId];
        [cell configHeadCellWithIdx:indexPath.row orderList:self.orderList];
        GarbageOrdrModel *model  = self.orderList[indexPath.row];
        NSString *rowStr =model.name;
        if ([rowStr isEqualToString:@"销售时间"]||[rowStr isEqualToString:@"厂商"]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.contentTextf.inputView  =[[UIView alloc]init];
        }else{
            cell.accessoryType =UITableViewCellAccessoryNone;
        }
        return cell;
    }else{
        GarbageNameTableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:garbageNameReusedCellId];
        [cell configGarbageNameCellWithIdx:indexPath.section nameList:self.orderNameList];
        cell.countTextf.delegate  =self;
        cell.countTextf.tag  =indexPath.section;
        return cell;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section  ==0) {
        return 48.f;
    }else{
        return 154.f;
    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView  =[[UIView alloc]init];
    headView.backgroundColor  =RGBA(242, 242, 242, 1);
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section  == self.orderNameList.count) {
        return 46.f;
    }else{
        return CGFLOAT_MIN;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    GarbageFootAddView *footView  =[[GarbageFootAddView alloc]init];
    KWeakSelf
    footView.addBlock = ^{
        [weakSelf.view endEditing:YES];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"GarbageName.json" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *error;
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (!error) {
            NSDictionary * jsonDict  = [dataDict objectForKey:@"orderName"];
            GarbageNameModel *model  =[GarbageNameModel mj_objectWithKeyValues:jsonDict];
            [weakSelf.orderNameList addObject:model];
            [weakSelf.listView reloadData];
            
        }
        debugLog(@"- = %@",weakSelf.orderNameList);
        
    };
    return footView;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section  ==0) {
        GarbageOrdrModel *model  = self.orderList[indexPath.row];
        NSString *rowStr =model.name;
        if ([rowStr isEqualToString:@"销售时间"]) {
            [self getSalesDateWithIdx:indexPath.row];
        }else if ([rowStr isEqualToString:@"厂商"]){
            [self getreclyerWithIdx:indexPath.row];
        }
    }else{
        
        [self getWasterInfomationWithIdx:indexPath.section];
        
        
    }
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section !=0) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
    }
    
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (self.orderNameList.count <=1) {
        [Units showErrorStatusWithString:@"不能删除了"];
        return;
    }
    [self.orderNameList removeObjectAtIndex:indexPath.section-1];
    [self.listView reloadData];
    
}

//销售时间

-(void)getSalesDateWithIdx:(NSInteger)idx{
    ZHPickView *pickView  =[[ZHPickView alloc]initDatePickWithDate:[NSDate date] datePickerMode:UIDatePickerModeDateAndTime isHaveNavControler:NO];
    pickView.delegate  =self;
    pickView.tag  =idx;
    [pickView show];
    
}

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    GarbageOrdrModel * model  = self.orderList[pickView.tag];
    
    model.content  = resultString;
    [self.listView reloadData];
}

//回收商
-(void)getreclyerWithIdx:(NSInteger)idx{
    NSString * urlStr  =@"app/WasteRecycler/findAllRecycler";
    NSMutableDictionary *parms  =[NSMutableDictionary dictionary];
    
    [Units showLoadStatusWithString:Loading];
    KWeakSelf
    [HttpTool POST:[urlStr getWholeUrl] param:parms success:^(NSMutableDictionary*  _Nonnull responseObject) {
        [Units hideView];
        if ([[responseObject objectForKey:@"status"]intValue]==0 ) {
            NSArray * jsonArray  =[Units jsonToArray:responseObject[@"data"]];
            NSMutableArray * modelArray  =[GarbageRecyclerModel mj_objectArrayWithKeyValuesArray:jsonArray];
            [weakSelf.recycerList removeAllObjects];
            [weakSelf.recycerList addObjectsFromArray:modelArray];
            [weakSelf recyclerAlertControllerWithList:modelArray idx:idx];
        }
        
    } error:^(NSString * _Nonnull error) {
        [Units hideView];
    }];
}

//回收商
-(void)recyclerAlertControllerWithList:(NSMutableArray*)recycleList idx:(NSInteger)idx{
    UIAlertController *controller  =[UIAlertController alertControllerWithTitle:@"提示" message:@"请选择厂商" preferredStyle:UIAlertControllerStyleActionSheet];
    KWeakSelf
    for (GarbageRecyclerModel *model in recycleList) {
        UIAlertAction *action  =[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@-%@-%@",model.Name,model.SettleType,model.PayType] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            GarbageOrdrModel *orderModel  = self.orderList[idx];
            orderModel.content  =model.Name;
            //回收商ID
            weakSelf.recycleId  =model.Id;
            GarbageOrdrModel *orderModel1  =self.orderList[idx+1];
            orderModel1.content =model.Recipient;
            GarbageOrdrModel *orderModel2  =self.orderList[idx+2];
            orderModel2.content  = model.PhoneNum;
            [self.listView reloadData];
        }];
        [controller addAction:action];
    }
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:controller animated:YES completion:nil];
}

//废品名称

-(void)getWasterInfomationWithIdx:(NSInteger)idx{
    NSString * urlStr  =@"app/WasteSale/getWasteInformationByRecycler";
    if (self.recycleId.length  ==0) {
        [Units showErrorStatusWithString:@"请选择厂商"];
        return;
    }
    NSMutableDictionary * parms  =[NSMutableDictionary dictionary];
    [parms setObject:self.recycleId forKey:@"WasteRecyclerId"];
    KWeakSelf
    [HttpTool POST:[urlStr getWholeUrl] param:parms success:^(NSMutableDictionary*  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"status"]intValue]==0) {
            NSArray *jsonArray  =[Units jsonToArray:responseObject[@"data"]];
            NSMutableArray *modelArray  =[WasterInformationModel mj_objectArrayWithKeyValuesArray:jsonArray];
            [weakSelf getWasterInformationWithList:modelArray idx:idx];
        }
        debugLog(@"---%@",responseObject);
    } error:^(NSString * _Nonnull error) {
        debugLog(@"error %@",error);
    }];
}

//废品信息

-(void)getWasterInformationWithList:(NSMutableArray*)wasteList idx:(NSInteger)idx{
    UIAlertController *controller  =[UIAlertController alertControllerWithTitle:@"提示" message:@"请选择物品信息" preferredStyle:UIAlertControllerStyleActionSheet];
    KWeakSelf
    for (WasterInformationModel *model in wasteList) {
        [controller addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@(%@)",model.Name,model.Pieces] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            GarbageNameModel *nameModel  = self.orderNameList[idx-1];
            nameModel.nameContent  =model.Name;
            nameModel.ID  =model.Id;
            nameModel.matalContent  =[NSString stringWithFormat:@"%@(单位:%@)",model.Metals?:@"暂无",model.Pieces];
            [weakSelf.listView reloadData];
            
            
        }]];
    }
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:controller animated:YES completion:nil];
}
//数量

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    GarbageNameModel *model  = self.orderNameList[textField.tag-1];
    model.countContent  =textField.text;
    
    return YES;
}


//提交
-(void)commitMethod{
    [self.view endEditing:YES];

    NSString *dateStr=nil;
    for (GarbageOrdrModel *orderModel in self.orderList) {
        if ([orderModel.name  isEqualToString:@"销售时间"]) {
            if (orderModel.content.length  ==0) {
                [Units showErrorStatusWithString:@"销售时间必填"];
                return;
            }else{
                dateStr  = orderModel.content;
            }
        }if ([orderModel.name  isEqualToString:@"厂商"]) {
            if (orderModel.content.length  ==0) {
                [Units showErrorStatusWithString:@"厂商必填"];
                return;
            }
        }
    }
    for (int i =0; i<self.orderNameList.count; i++) {
        GarbageNameModel *model  = self.orderNameList[i];
        if (model.nameContent.length ==0) {
            [Units showErrorStatusWithString:[NSString stringWithFormat:@"第%d行物品名称必填",i+2]];
            return;
        }if (model.countContent.length ==0) {
            [Units showErrorStatusWithString:[NSString stringWithFormat:@"第%d行数量必填",i+2]];
            return;
        }
    }
    
    //备注
    [self remarkAlertView];
    
    //废品信息
    NSMutableArray *wasterList  =[NSMutableArray array];
    
    [wasterList removeAllObjects];
    for (GarbageNameModel *nameModel in self.orderNameList) {
        NSMutableDictionary *dict  =[NSMutableDictionary dictionary];
        [dict setObject:nameModel.ID forKey:@"WasteInformationId"];
        [dict setObject:nameModel.countContent forKey:@"Count"];
        [wasterList addObject:dict];
    }
    
    //废品名称
    NSMutableArray *wasterNameList  =[NSMutableArray array];
    [wasterNameList removeAllObjects];
    
    //取出工厂
   
    NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
    MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
    [modleArchiver finishDecoding];
    NSString *factoryId  =moudleStatus.FactoryList[0][@"FactoryId"];
    
    for (GarbageNameModel *nameModel in self.orderNameList) {
        NSMutableDictionary *dict  =[NSMutableDictionary dictionary];
        [dict setObject:nameModel.nameContent forKey:@"Name"];
        [dict setObject:nameModel.matalContent?:@"" forKey:@"Pieces"];
        [dict setObject:factoryId forKey:@"FactoryId"];
        [dict setObject:@(1) forKey:@"ListOperation"];
        [wasterNameList addObject:dict];
    }
    
    //回收商
    NSMutableDictionary * recyclerDict  =[NSMutableDictionary dictionary];
    [recyclerDict setObject:self.recycleId forKey:@"RecyclerId"];
    [recyclerDict setObject:USERDEFAULT_object(USERID) forKey:@"CreatedBy"];
    [recyclerDict setObject:dateStr forKey:@"SalesDate"];
    if (self.remarkStr.length >0) {
        [recyclerDict setObject:_remarkStr forKey:@"Remark"];
    }
    
    NSMutableDictionary *totalParms  =[NSMutableDictionary dictionary];
    [totalParms setObject:[Units dictionaryToJson:recyclerDict] forKey:@"model"];
    [totalParms setObject:[Units arrayToJson:wasterList] forKey:@"GarbageLinkArray"];
    [totalParms setObject:[Units arrayToJson:wasterNameList] forKey:@"WasteInformations"];
    [totalParms setObject:@"752f3298c5314a6c8fb90233f44899f8" forKey:@"moduleId"];
    NSString *url =@"app/WasteSale/submit";
    [Units showLoadStatusWithString:Loading];
    KWeakSelf
    [HttpTool POST:[url getWholeUrl] param:totalParms success:^(NSDictionary *  _Nonnull responseObject) {
        [Units hideView];
        [Units showStatusWithStutas:responseObject[@"info"]];
        if ([[responseObject objectForKey:@"status"]intValue]==0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
                           
            });
        }
       
    } error:^(NSString * _Nonnull error) {
        [Units hideView];
    }];
}

//备注信息

-(void)remarkAlertView{
    UIAlertController *controller =[UIAlertController alertControllerWithTitle:@"提示" message:@"请输入备注信息" preferredStyle:UIAlertControllerStyleAlert];
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder  =@"选填";
    }];
    KWeakSelf;
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       UITextField *textf   =[controller.textFields firstObject];
        weakSelf.remarkStr  =textf.text;
        
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:controller animated:YES completion:nil];
}

-(NSMutableArray*)orderList{
    if (!_orderList) {
        _orderList  =[NSMutableArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"GarbageOrder.json" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *error;
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (!error) {
            NSArray * dataArray  = [dataDict objectForKey:@"orderList"];
            NSMutableArray *modelList  =[GarbageOrdrModel mj_objectArrayWithKeyValuesArray:dataArray];
            GarbageOrdrModel *model  =[modelList firstObject];
            model.content  = USERDEFAULT_object(CodeName);
            [_orderList addObjectsFromArray:modelList];
           // [_sectionList addObject:modelList];
        }
    }return _orderList;
}

-(NSMutableArray*)orderNameList{
    if (!_orderNameList) {
        _orderNameList  =[NSMutableArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"GarbageName.json" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *error;
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (!error) {
            NSDictionary * jsonDict  = [dataDict objectForKey:@"orderName"];
            GarbageNameModel *model  =[GarbageNameModel mj_objectWithKeyValues:jsonDict];
            [_orderNameList addObject:model];
            
        }
    }return _orderNameList;
}

-(NSMutableArray*)recycerList{
    if (!_recycerList) {
        _recycerList  =[NSMutableArray array];
    }return _recycerList;
}

-(UITableView*)listView{
    if (!_listView) {
        _listView  =[[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
        _listView.autoresizingMask  =UIViewAutoresizingFlexibleHeight;
        _listView.delegate  =self;
        _listView.dataSource  =self;
        _listView.separatorStyle  =UITableViewCellSeparatorStyleSingleLine;
        _listView.tableFooterView  =[[UIView alloc]init];
        
    }
    return _listView;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
@end
