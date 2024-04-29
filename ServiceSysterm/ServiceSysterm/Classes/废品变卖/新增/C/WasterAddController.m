//
//  WasterAddController.m
//  ServiceSysterm
//
//  Created by Andy on 2021/8/20.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "WasterAddController.h"
#import "WasterInformationTableCell.h"
#import "WasterAddInforModel.h"
@interface WasterAddController ()<UITextFieldDelegate>

@property (nonatomic,strong)UITableView *listView;

@property (nonatomic,strong)NSMutableArray *wasterInformationList;

@property (nonatomic,strong)NSMutableArray *recyclerList;

@property (nonatomic,copy)NSString *selectIdx;

@end

NSString *const InformationReuseId =@"InformationReuseId";

@implementation WasterAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self segmentControl];
    
    UIBarButtonItem * rightItem =[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commitMethod)];
    self.navigationItem.rightBarButtonItem  =rightItem;
}

//选择条
-(void)segmentControl
{
    self.selectIdx  =@"0";
    //选择条
    NSArray * titles  = @[@"物品清单",@"厂商清单"];
    UISegmentedControl * segmentControl =[[UISegmentedControl alloc]initWithItems:titles];
    segmentControl.selectedSegmentIndex =0;
    segmentControl.layer.borderColor  =[UIColor darkGrayColor].CGColor;
    segmentControl.layer.borderWidth  =0.5;
    segmentControl.bounds  = CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width, 30);
    

    [segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateSelected];
    [segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
   
    [segmentControl setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segmentControl setBackgroundImage:[self imageWithColor:RGBA(0, 143, 182, 1)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [segmentControl addTarget:self action:@selector(chosItem:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView  =segmentControl;
//    [segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_offset(0);
//        make.centerX.mas_equalTo(self.view);
//        make.width.mas_equalTo(kScreenWidth*0.45);
//        make.height.mas_equalTo(30);
//    }];
    
    [self.view addSubview:self.listView];
    
    
    [self.listView registerNib:[UINib nibWithNibName:@"WasterInformationTableCell" bundle:nil] forCellReuseIdentifier:InformationReuseId];
    
}

-(void)chosItem:(UISegmentedControl*)segment{
    [self.view endEditing:YES];
    self.selectIdx  =[NSString stringWithFormat:@"%ld",segment.selectedSegmentIndex];
    [self.listView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.selectIdx isEqualToString:@"0"]) {
        return self.wasterInformationList.count;
    }else{
        return self.recyclerList.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WasterInformationTableCell *cell  =[tableView dequeueReusableCellWithIdentifier:InformationReuseId];
    if ([self.selectIdx isEqualToString:@"0"]) {
        WasterAddInforModel *model  = self.wasterInformationList[indexPath.row];
        
        [cell configureCellWithIdx:self.selectIdx list:self.wasterInformationList row:indexPath.row];
        if ([model.type isEqualToString:@"物品类别"]||[model.type isEqualToString:@"参考金属"]) {
            cell.accessoryType  =UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType  =UITableViewCellAccessoryNone;
        }
        cell.contentTextf.delegate  =self;
        cell.contentTextf.tag  =indexPath.row;
    }else{
        WasterAddInforModel *model  =self.recyclerList[indexPath.row];
        [cell configureCellWithIdx:self.selectIdx list:self.recyclerList row:indexPath.row];
        if ([model.type isEqualToString:@"结算方式"]||[model.type isEqualToString:@"付款方式"]||[model.type isEqualToString:@"是否管控"]) {
            cell.accessoryType  =UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType  =UITableViewCellAccessoryNone;
        }
        cell.contentTextf.delegate  =self;
        cell.contentTextf.tag  = indexPath.row;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.f;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    if ([self.selectIdx isEqualToString:@"0"]) {
        WasterAddInforModel *model  =self.wasterInformationList[indexPath.row];
        if ([model.type isEqualToString:@"物品类别"]) {
            [self getWasterTypeWithIdx:indexPath.row];
        }else if ([model.type isEqualToString:@"参考金属"]){
            [self getMatalWithIdx:indexPath.row];
        }
    }else{
        WasterAddInforModel *model  = self.recyclerList[indexPath.row];
        if ([model.type isEqualToString:@"结算方式"]||[model.type isEqualToString:@"付款方式"]||[model.type isEqualToString:@"是否管控"]) {
            [self settleTypeAlertViewWithIdx:indexPath.row type:model.type];
        }
    }
}


//textfield

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if ([self.selectIdx isEqualToString:@"0"]) {
        WasterAddInforModel *model =self.wasterInformationList[textField.tag];
        model.content  = textField.text;
    }else{
        WasterAddInforModel *model  =self.recyclerList[textField.tag];
        model.content  =textField.text;
    }
    
    return YES;
}
//废品类别

-(void)getWasterTypeWithIdx:(NSInteger)idx{
    NSString *url =@"app/WasteInformation/findAllWasteType";
    NSMutableDictionary *parms  =[NSMutableDictionary dictionary];
    [Units showLoadStatusWithString:Loading];
    KWeakSelf
    [HttpTool POST:[url getWholeUrl] param:parms success:^(NSDictionary  *_Nonnull responseObject) {
        [Units hideView];
        if ([[responseObject objectForKey:@"status"]intValue]==0) {
            NSArray *jsonArray  =[Units jsonToArray:responseObject[@"data"]];
            NSMutableArray *modelArray  =[WasterTypeModel mj_objectArrayWithKeyValuesArray:jsonArray];
            [weakSelf wasterTypeAlertViewWithList:modelArray idx:idx];
            
        }
        debugLog(@"-- -- %@",responseObject);
    } error:^(NSString * _Nonnull error) {
        debugLog(@"error %@",error);
    }];
}

//废品类别

-(void)wasterTypeAlertViewWithList:(NSMutableArray*)typeList idx:(NSInteger)idx{
    UIAlertController *controller  =[UIAlertController alertControllerWithTitle:@"提示" message:@"请选择物品类别" preferredStyle:UIAlertControllerStyleActionSheet];
    KWeakSelf
    for (WasterTypeModel *model in typeList) {
        [controller addAction:[UIAlertAction actionWithTitle:model.Name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            WasterAddInforModel *inforModel  =weakSelf.wasterInformationList[idx];
            inforModel.content  =model.Name;
            inforModel.code  =model.Code;
            [weakSelf.listView reloadData];
        }]];
    }
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:controller animated:YES completion:nil];
}

//参考金属

-(void)getMatalWithIdx:(NSInteger)idx{
    NSString *url =@"app/MetalPrice/findAllMetals";
    NSMutableDictionary *parms  =[NSMutableDictionary dictionary];
    [Units showLoadStatusWithString:Loading];
    KWeakSelf
    [HttpTool POST:[url getWholeUrl] param:parms success:^(NSDictionary  *_Nonnull responseObject) {
        [Units hideView];
        if ([[responseObject objectForKey:@"status"]intValue]==0) {
            NSArray * jsonArray  =[Units jsonToArray:responseObject[@"data"]];
            NSMutableArray *modelArray  =[WasterMatalModel mj_objectArrayWithKeyValuesArray:jsonArray];
            [weakSelf matalAlertViewWithList:modelArray idx:idx];
        }
        
        debugLog(@"=== %@",responseObject);
    } error:^(NSString * _Nonnull error) {
        [Units hideView];
        debugLog(@"error %@",error);
    }];
}
//参考金属
-(void)matalAlertViewWithList:(NSMutableArray*)matalList idx:(NSInteger)idx{
    UIAlertController *controller  =[UIAlertController alertControllerWithTitle:@"提示" message:@"请选择参考金属" preferredStyle:UIAlertControllerStyleActionSheet];
    KWeakSelf
    for (WasterMatalModel *model in matalList) {
        [controller addAction:[UIAlertAction actionWithTitle:model.Name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            WasterAddInforModel *inforModel  =weakSelf.wasterInformationList[idx];
            inforModel.content  =model.Name;
            inforModel.code  =model.Code;
            [weakSelf.listView reloadData];
        }]];
    }
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:controller animated:YES completion:nil];
    
}

//结算方式
-(void)settleTypeAlertViewWithIdx:(NSInteger)idx type:(NSString*)typeStr{
    UIAlertController *controller  =[UIAlertController alertControllerWithTitle:@"提示" message:@"请选择结算方式" preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *titles  ;
    if ([typeStr isEqualToString:@"结算方式"]) {
        titles  =@[@"月结",@"批结"];
    }else if ([typeStr isEqualToString:@"是否管控"]){
        titles =@[@"是",@"否"];
    }
    else{
        titles =@[@"转账",@"现金"];
    }
   KWeakSelf
    for (int i =0; i<titles.count; i++) {
        [controller addAction:[UIAlertAction actionWithTitle:titles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            WasterAddInforModel *inforModel  = self.recyclerList[idx];
            inforModel.content  =action.title;
            [weakSelf.listView reloadData];
            
        }]];
    }
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:controller animated:YES completion:nil];
    
}

-(void)commitMethod{
    [self.view endEditing:YES];
    NSString *url;
    
    NSMutableDictionary *totalParms  =[NSMutableDictionary dictionary];
    if ([self.selectIdx isEqualToString:@"0"]) {
        //废品类别
        NSString *typeStr;
        NSString *nameStr;
        NSString *unitStr;
        NSString *matalStr;
        for (WasterAddInforModel *model in self.wasterInformationList) {
            if (![model.type isEqualToString:@"参考金属"]) {
                if (model.content.length ==0) {
                    [Units showErrorStatusWithString:[NSString stringWithFormat:@"%@必填",model.type]];
                    return;
                }else{
                    if ([model.type  isEqualToString:@"物品类别"]) {
                        typeStr  = model.code;
                    }else if ([model.type isEqualToString:@"物品名称"]){
                        nameStr  =model.content;
                    }else if ([model.type isEqualToString:@"物品单位"]){
                        unitStr  =model.content;
                    }
                }
            }else{
                matalStr  =model.code;
            }
        }
        NSMutableDictionary *wasterParms  =[NSMutableDictionary dictionary];
        [wasterParms setObject:@([typeStr intValue]) forKey:@"Type"];
        [wasterParms setObject:nameStr forKey:@"Name"];
        [wasterParms setObject:unitStr forKey:@"Pieces"];
        if (matalStr.length >0) {
            [wasterParms setObject:matalStr forKey:@"MetalCode"];
        }
        url =@"app/WasteInformation/createSave";
        [totalParms setObject:[Units dictionaryToJson:wasterParms] forKey:@"model"];
        debugLog(@" -= = %@",wasterParms);
    }else{
        //回收商名称
        NSString *recylcerStr;
        //接收人
        NSString *receiverStr;
        //结算方式
        NSString *settleStr;
        //付款方式
        NSString *payTypeStr;
        //联系方式
        NSString *phoneStr;
        //是否管控
        NSString *isContractStr;
        
        for (WasterAddInforModel *model in self.recyclerList) {
            if (![model.type isEqualToString:@"是否管控"]) {
                if (model.content.length  ==0) {
                    [Units showErrorStatusWithString:[NSString stringWithFormat:@"%@必填",model.type]];
                    return;
                }else{
                    if ([model.type isEqualToString:@"厂商名称"]) {
                        recylcerStr  =model.content;
                    }else if ([model.type isEqualToString:@"接收人"]){
                        receiverStr  =model.content;
                    }else if ([model.type isEqualToString:@"结算方式"]){
                        settleStr  =model.content;
                    }else if ([model.type isEqualToString:@"付款方式"]){
                        payTypeStr  =model.content;
                    }else if ([model.type isEqualToString:@"联系方式"]){
                        phoneStr  =model.content;
                    }
                }
            }else{
                
                isContractStr  =[model.content isEqualToString:@"是"]?@"0":@"1";
            }
        }
        
        NSMutableDictionary *recycleParms  =[NSMutableDictionary dictionary];
        [recycleParms setObject:recylcerStr forKey:@"Name"];
        [recycleParms setObject:settleStr forKey:@"SettleType"];
        [recycleParms setObject:payTypeStr forKey:@"PayType"];
        [recycleParms setObject:phoneStr forKey:@"PhoneNum"];
        [recycleParms setObject:receiverStr forKey:@"Recipient"];
        debugLog(@" = =%@",isContractStr);
        if (isContractStr.length  ==0) {
            [recycleParms setObject:@(0) forKey:@"FlowTag"];
        }else{
            [recycleParms setObject:isContractStr forKey:@"FlowTag"];
        }
        debugLog(@" -- - -%@",recycleParms);
        url =@"app/WasteRecycler/createSave";
        [totalParms setObject:[Units dictionaryToJson:recycleParms] forKey:@"model"];
    }
    
    [Units showLoadStatusWithString:Loading];
    [HttpTool POST:[url getWholeUrl] param:totalParms success:^(NSDictionary  *_Nonnull responseObject) {
        [Units hideView];
        [Units showStatusWithStutas:responseObject[@"info"]];
        debugLog(@" -- -%@",responseObject);
    } error:^(NSString * _Nonnull error) {
        [Units hideView];
        debugLog(@"error %@",error);
    }];
    
    
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

-(NSMutableArray*)wasterInformationList{
    if (!_wasterInformationList) {
        _wasterInformationList  =[NSMutableArray array];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"WasterAddInformation.json" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *error;
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (!error) {
            NSDictionary * jsonDict  = [dataDict objectForKey:@"wasterInformation"];
            NSMutableArray *modelArray  =[WasterAddInforModel mj_objectArrayWithKeyValuesArray:jsonDict];
            WasterAddInforModel *model  = [modelArray firstObject];
            model.content  =USERDEFAULT_object(CodeName);
            [_wasterInformationList addObjectsFromArray:modelArray];
            
        }
    }return _wasterInformationList;
}



-(NSMutableArray*)recyclerList{
    if (!_recyclerList) {
        _recyclerList =[NSMutableArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"WasterAddInformation.json" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *error;
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (!error) {
            NSDictionary * jsonDict  = [dataDict objectForKey:@"recycler"];
            NSMutableArray *modelArray  =[WasterAddInforModel mj_objectArrayWithKeyValuesArray:jsonDict];
            WasterAddInforModel *model  = [modelArray firstObject];
            model.content  =USERDEFAULT_object(CodeName);
            [_recyclerList addObjectsFromArray:modelArray];
            
        }
    }return _recyclerList;
}
- (UIImage *)imageWithColor: (UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
@end
