//
//  MCNewOrderController.m
//  ServiceSysterm
//
//  Created by Andy on 2020/10/14.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MCNewOrderController.h"
#import "MCNewOrderRemarkTableCell.h"
#import "MoudleModel.h"

#import "MCChoseDepartmentAlrtView.h"

@interface MCNewOrderController ()


@property (nonatomic,strong)NSMutableArray * bMessageArray;

@property (nonatomic,strong)NSMutableDictionary * contentDictionary;

@property (nonatomic,strong)NSMutableArray *factoryMutableArray;


@end

@implementation MCNewOrderController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"开单";
    
    self.view.backgroundColor  =[UIColor whiteColor];
    
   
    
    [self.view addSubview:self.tableView];
    
    self.tableView.separatorStyle  =UITableViewCellSeparatorStyleSingleLine;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MCNewOrderRemarkTableCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    
    [self.contentDictionary setObject:USERDEFAULT_object(CodeName) forKey:@"开单人"];
    
    [self.contentDictionary setObject:USERDEFAULT_object(@"DEPARTMENT") forKey:@"施工部门"];
    [self.contentDictionary setObject:USERDEFAULT_object(@"DEPARTMENT") forKey:@"所属部门"];
    [self.contentDictionary setObject:USERDEFAULT_object(@"orderId") forKey:@"departNo"];
    
    //取出工厂
    NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
    MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
    [modleArchiver finishDecoding];
    if (!_factoryMutableArray) {
        _factoryMutableArray  =[NSMutableArray array];
    }
    [_factoryMutableArray removeAllObjects];
    [_factoryMutableArray addObjectsFromArray:moudleStatus.FactoryList];
    //默认选择第一个工厂
    if (moudleStatus.FactoryList.count >0) {
        [self.contentDictionary setObject:moudleStatus.FactoryList[0][@"FactoryName"] forKey:@"所属工厂"];
        [self.contentDictionary setObject:moudleStatus.FactoryList[0][@"FactoryId"] forKey:@"factoryId"];
    }
   
    
    UIButton * but  =[UIButton buttonWithType:UIButtonTypeCustom];
    [but setTitle:@"提交" forState:UIControlStateNormal];
    but.titleLabel.font  =[UIFont systemFontOfSize:15];
    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(commitMethod) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem  =[[UIBarButtonItem alloc]initWithCustomView:but];
    self.navigationItem.rightBarButtonItem  = rightItem;
    
    
    
}


-(void)commitMethod{
    //判断条件
    //施工类型
    
    [self.view endEditing:YES];
    
    NSString * sgType  = self.contentDictionary[@"sgType"];
    
    //备注
    NSString * remark = self.contentDictionary[@"remark"];
    if (sgType.length ==0) {
        [Units showErrorStatusWithString:@"施工类型必填"];
        return;
    }if (remark.length  ==0) {
        [Units showErrorStatusWithString:@"备注必填"];
        return;
    }
    
    //开单部门
    NSString * departNo  = self.contentDictionary[@"departNo"];
    //施工部门
    NSString * constructionId  = self.contentDictionary[@"orId"];
    //所属工厂
    NSString * factoryId  = self.contentDictionary[@"factoryId"];
    
    NSMutableDictionary * modelParms  =[NSMutableDictionary dictionary];
    [modelParms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    [modelParms setObject:USERDEFAULT_object(USERID) forKey:@"operCreateUser"];
    [modelParms setObject:departNo forKey:@"OrId"];
    [modelParms setObject:constructionId?:departNo forKey:@"constructionOrId"];
    [modelParms setObject:remark forKey:@"remark"];
    [modelParms setObject:sgType forKey:@"sgType"];
    
    NSString * modelStr  = [Units dictionaryToJson:modelParms];
    
    
    NSMutableDictionary * parms  =[NSMutableDictionary dictionary];
    [parms setObject:factoryId forKey:@"FactoryId"];
    [parms setObject:modelStr forKey:@"model"];
    
    
    NSString * url = @"maint/construstiontask/createOrUpdate";
    [Units showLoadStatusWithString:Loading];
    
    KWeakSelf
    [HttpTool POST:[url getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hideView];
        if ([responseObject[@"status"]intValue]==0) {
            [Units showStatusWithStutas:responseObject[@"info"]];
            [weakSelf.contentDictionary removeObjectForKey:@"施工类型"];
            [weakSelf.contentDictionary removeObjectForKey:@"remark"];
            [weakSelf.tableView reloadData];
//             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [weakSelf.tabBarController.navigationController popToRootViewControllerAnimated:YES];
//                           //[weakSelf.navigationController popViewControllerAnimated:YES];
//            });
        }
        debugLog(@" == = =%@",responseObject);
    } error:^(NSString * _Nonnull error) {
        [Units hideView];
        
        debugLog(@"error = = %@",error);
    }];
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section  ==0) {
        return self.bMessageArray.count;
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section  ==0) {
        UITableViewCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cell0"];
        if (cell  ==nil) {
            cell  =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell0"];
        }
        
        cell.selectionStyle  =UITableViewCellSelectionStyleNone;
        
        cell.textLabel.font  =[UIFont systemFontOfSize:16];
        
        cell.textLabel.text  = [NSString stringWithFormat:@"%@:",self.bMessageArray[indexPath.row]];
        
        cell.detailTextLabel.font  =[UIFont systemFontOfSize:15];
        
        cell.detailTextLabel.text  = self.contentDictionary[self.bMessageArray[indexPath.row]]?:@"";
        
        
        NSString * tip = self.bMessageArray[indexPath.row];
        
        
        if ([tip isEqualToString:@"施工部门"]||[tip isEqualToString:@"所属工厂"]||[tip isEqualToString:@"施工类型"]) {
            cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
            NSString * str  = self.contentDictionary[tip];
            if (str.length ==0) {
                cell.detailTextLabel.text  = [NSString stringWithFormat:@"请选择%@",tip];
            }
        }else{
            cell.accessoryType  = UITableViewCellAccessoryNone;
        }
        
        
        return cell;
    }else{
        MCNewOrderRemarkTableCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        
        cell.contentTextView.text  =self.contentDictionary[@"remark"]?:@"";
        KWeakSelf
        cell.textViewBlock = ^(NSString * _Nonnull text) {
            [weakSelf.contentDictionary setObject:text forKey:@"remark"];
        };
        return cell;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section  ==0) {
        return 48.0f;
    }else{
        return 66.0f;
    }
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *titles  = @[@"基本信息",@"备注信息"];
    return titles[section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 48.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section  ==0) {
        NSString * tip  = self.bMessageArray[indexPath.row];
        if ([tip isEqualToString:@"施工部门"]) {
            [self getDepartment];
        }else if ([tip isEqualToString:@"所属工厂"]){
            [self choseFactory];
        }else if ([tip isEqualToString:@"施工类型"]){
            [self constructionType];
            
        }
    }
}

//选择工厂
-(void)choseFactory{
    if (self.factoryMutableArray.count >1) {
        UIAlertController * controller  =[UIAlertController alertControllerWithTitle:@"提示" message:@"请选择工厂" preferredStyle:UIAlertControllerStyleActionSheet];
        KWeakSelf
        for (NSDictionary * dic in self.factoryMutableArray) {
            NSString * title  = dic[@"FactoryName"];
            [controller addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.contentDictionary setObject:action.title forKey:@"所属工厂"];
                [weakSelf.contentDictionary setObject:dic[@"FactoryId"] forKey:@"factoryId"];
                [weakSelf.tableView reloadData];
            }]];
        }
        [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:controller animated:YES completion:nil];
        
    }

}

//施工类型

-(void)constructionType{
    //取出部门
    NSArray * types ;
    NSString * department  = USERDEFAULT_object(@"DEPARTMENT");
    if ([department isEqualToString:@"工艺工程部"]) {
        types =@[@"改造",@"维修工具制作"];
    }else{
        types =@[@"改造"];
    }
    
    UIAlertController * controller  =[UIAlertController alertControllerWithTitle:@"提示" message:@"请选择施工类型" preferredStyle:UIAlertControllerStyleActionSheet];
    KWeakSelf
   
    for (NSString * title  in types) {
        [controller addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.contentDictionary setObject:action.title forKey:@"施工类型"];
            [weakSelf.contentDictionary setObject:[action.title isEqualToString:@"改造"]?@"1":@"2" forKey:@"sgType"];
            
            [weakSelf.tableView reloadData];
            
        }]];
    }
    
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:controller animated:YES completion:nil];
    
    
}

 //获取部门
-(void)getDepartment{
    NSMutableDictionary * parms  =[NSMutableDictionary dictionary];
    NSString * factoryId  = self.contentDictionary[@"factoryId"];
    
    [parms setObject:factoryId forKey:@"FactoryId"];
    
    NSString * url  =@"maint/construstiontask/getDepart";
    
    [Units showStatusWithStutas:Loading];
    
    KWeakSelf
    [HttpTool POST:[url getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        
        debugLog(@" = == %@",responseObject);
        [Units hideView];
        if ([[responseObject objectForKey:@"status"]intValue]==0) {
            NSArray * arr  = [Units jsonToArray:responseObject[@"data"]];
            [MCChoseDepartmentAlrtView showMKBusinessHistoryAlertViewWithDatasource:arr department:^(NSDictionary * _Nonnull department) {
                [weakSelf.contentDictionary setObject:department[@"DepName"] forKey:@"施工部门"];
                [weakSelf.contentDictionary setObject:department[@"OrId"] forKey:@"orId"];
                [weakSelf.tableView reloadData];
                
            }];
            
        }
        
    } error:^(NSString * _Nonnull error) {
        [Units hideView];
        [Units showErrorStatusWithString:error];
        
    }];
}


-(NSMutableDictionary*)contentDictionary{
    if (!_contentDictionary) {
        _contentDictionary  =[NSMutableDictionary dictionary];
    }return _contentDictionary;
}
-(NSMutableArray*)bMessageArray{
    if (!_bMessageArray) {
        _bMessageArray  =[NSMutableArray array];
        NSArray * arr  = @[@"开单人",@"所属部门",@"施工部门",@"施工类型",@"所属工厂"];
        [_bMessageArray addObjectsFromArray:arr];
    }
    return _bMessageArray;
}
@end
