//
//  MCDetailAppointController.m
//  ServiceSysterm
//
//  Created by Andy on 2020/10/30.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MCDetailAppointController.h"
#import "MoudleModel.h"
#import "SelectedMemberTableCell.h"
#import "MCOperateRemarkAlertView.h"
@interface MCDetailAppointController ()

@property (nonatomic,strong)NSMutableDictionary * selectedItemDictionary;

@end

@implementation MCDetailAppointController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  =self.constructionType;
    self.view.backgroundColor  =[UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle  =UITableViewCellSeparatorStyleSingleLine;


    [self.tableView registerNib:[UINib nibWithNibName:@"SelectedMemberTableCell" bundle:nil] forCellReuseIdentifier:@"cell0"];
    self.tableView.rowHeight  = 48.0f;
    
    [self setupDatas];
    
    UIBarButtonItem * right  =[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(sureMethod)];
    self.navigationItem.rightBarButtonItem  = right;
    
    
    
    
}


-(void)sureMethod{
    
    NSString * url =@"maint/construstiontask/assignOrReinforce";
    
    NSString * typeString  =nil;
    
    if ([self.constructionType isEqualToString:@"指派"]) {
        typeString =@"0";
    }else if ([self.constructionType isEqualToString:@"增援指派"]){
        typeString  =@"1";
    }else{
        typeString =@"2";
    }
    KWeakSelf
    [MCOperateRemarkAlertView showAlerMCRemarkAlertViewWithHeadString:self.constructionType commitBlock:^(NSString * _Nonnull text) {
      NSArray * selectedArray  = [self.selectedItemDictionary allValues];
      if (selectedArray.count  ==0) {
          [Units showWarningWithTitle:@"提示" andSubTitle:@"请选择人员" andView:self.view];
          return;
      }
      NSMutableArray * engineerIds  = [NSMutableArray array];
        
      [engineerIds removeAllObjects];
      
      for (NSString * idxString in selectedArray) {
          NSMutableDictionary * dict  =[NSMutableDictionary dictionary];
          
          NSDictionary * dic  = [self.datasource objectAtIndex:[idxString intValue]];
          
          [dict setObject:dic[@"UserId"] forKey:@"UserId"];
          
          [engineerIds addObject:dict];
      }
      NSString * userIdString = [Units arrayToJson:engineerIds];
      NSMutableDictionary * parms  =[NSMutableDictionary dictionary];
        
      [parms setObject:self.constructionId forKey:@"ConstructionTaskId"];
        
      [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
        
      [parms setObject:userIdString forKey:@"engineerArray"];
        
      [parms setObject:typeString forKey:@"type"];
        
      [parms setObject:text?:@"" forKey:@"OperateDescribe"];
        [Units showHudWithText:Loading view:weakSelf.view model:MBProgressHUDModeIndeterminate];
        
        [HttpTool POST:[url getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
            [Units hiddenHudWithView:weakSelf.view];
            
            if ([[responseObject objectForKey:@"status"]intValue]==0) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            }
            debugLog(@"== = = = %@",responseObject);
        } error:^(NSString * _Nonnull error) {
            [Units hiddenHudWithView:weakSelf.view];
            [Units showErrorStatusWithString:error];
        }];
        
        
    }];
    
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectedMemberTableCell *cell  =[tableView dequeueReusableCellWithIdentifier:@"cell0"];
    
    
    
    NSDictionary * dic  = self.datasource[indexPath.row];
    cell.tipLab.text  = [NSString stringWithFormat:@"%@(%@)",dic[@"FName"],dic[@"UserName"]];
    
    //多选
    NSArray * selectedItems = [self.selectedItemDictionary allValues];
    for (NSString * str  in selectedItems) {
        if ([str integerValue]== indexPath.row) {
            cell.selectedButton.selected = YES;
        }else{
            cell.selectedButton.selected =NO;
        }
    }
    
    KWeakSelf
    cell.selectedItemBlock = ^(UIButton * _Nonnull sender) {
        if (!weakSelf.selectedItemDictionary) {
            weakSelf.selectedItemDictionary =[NSMutableDictionary dictionary];
                   
       }
        
        //多选
            sender.selected =! sender.selected;
            if (sender.selected) {
                [self.selectedItemDictionary setObject:[NSString stringWithFormat:@"%ld",sender.tag] forKey: @(indexPath.row)];
                }else{
                [self.selectedItemDictionary removeObjectForKey:@(indexPath.row)];
        }
    };
    return cell;
}

-(void)setupDatas{
    NSString * url =@"maint/construstiontask/getConstructionEngineer";
    NSMutableDictionary * parms  =[NSMutableDictionary dictionary];
    
    NSString * typeStr  =nil;
    if ([self.constructionType isEqualToString:@"指派"]) {
        typeStr  =@"0";
    }else if ([self.constructionType isEqualToString:@"增援指派"]){
        typeStr  =@"1";
    }else{
        typeStr =@"2";
    }
    [parms setObject:typeStr forKey:@"Type"];
    
    //取出工厂
    NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
    MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
    [modleArchiver finishDecoding];
    NSArray * factoryList = moudleStatus.FactoryList;
    NSDictionary * dic = [factoryList firstObject];
    
    [parms setObject:dic[@"FactoryId"] forKey:@"FactoryId"];
    [parms setObject:self.constructionId forKey:@"ConstructionTaskId"];
    [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    KWeakSelf
    [HttpTool POST:[url getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
      
        [Units hiddenHudWithView:weakSelf.view];
        if ([[responseObject objectForKey:@"status"]intValue]==0) {
            NSArray * arr = [Units jsonToArray:responseObject[@"data"]];
            [weakSelf.datasource removeAllObjects];
            [weakSelf.datasource addObjectsFromArray:arr];
            
        }
        [weakSelf.tableView reloadData];
        debugLog(@" == = = =%@",responseObject);
    } error:^(NSString * _Nonnull error) {
        [Units hiddenHudWithView:weakSelf.view];
        [Units showErrorStatusWithString:error];
    }];
    
}

@end
