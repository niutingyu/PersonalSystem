//
//  MCDetailPauseController.m
//  ServiceSysterm
//
//  Created by Andy on 2020/10/30.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MCDetailPauseController.h"
#import "SelectedMemberTableCell.h"

#import "MoudleModel.h"

#import "MCOperateChangeSchuleAlertView.h"
#import "MCOperateRemarkAlertView.h"
@interface MCDetailPauseController ()

@property (nonatomic,strong)NSMutableDictionary * selectedItemDictionary;

@property (nonatomic,strong)NSMutableArray * sectionTitles;

@property (nonatomic,strong)MCOperateChangeSchuleAlertView * alertView;

@property (nonatomic,strong)NSMutableDictionary * contentDictionary;

@end

@implementation MCDetailPauseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  =[UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"SelectedMemberTableCell" bundle:nil] forCellReuseIdentifier:@"cell0"];
    self.tableView.rowHeight = 48.0f;
    
    [self setupDatas];
    [self getDatas];
    
    UIBarButtonItem * right  =[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commitMethod)];
    self.navigationItem.rightBarButtonItem  = right;
    
    
    
    
}


-(void)commitMethod{
    
    NSString * url =@"maint/construstiontask/pasueOrCancel";
    
    //恢复时间
    NSString * startTime  = self.contentDictionary[@"选择时间"];
    if (startTime.length  ==0) {
        [Units showWarningWithTitle:@"提示" andSubTitle:@"请选择预计恢复时间" andView:self.view];
        return;
    }
    
    
    KWeakSelf
    [MCOperateRemarkAlertView showAlerMCRemarkAlertViewWithHeadString:@"" commitBlock:^(NSString * _Nonnull text) {
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
       
     [parms setObject:@"0" forKey:@"Type"];
     [parms setObject:startTime forKey:@"PlanStartTime"];
       
     [parms setObject:text?:@"test" forKey:@"OperateDescribe"];
    [Units showHudWithText:Loading view:weakSelf.view model:MBProgressHUDModeIndeterminate];
        [HttpTool POST:[url getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
           
            debugLog(@" - -- - %@",responseObject);
        } error:^(NSString * _Nonnull error) {
            
        }];
        
    }];
    
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionTitles.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString * tip  = self.sectionTitles[section];
    if ([tip  isEqualToString:@"选择人员"]) {
        return self.datasource.count;
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *tip  = self.sectionTitles[indexPath.section];
    if ([tip isEqualToString:@"选择人员"]) {
        SelectedMemberTableCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cell0"];
        
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
    }else{
        UITableViewCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (cell  ==nil) {
            cell  =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
        }
        
        cell.selectionStyle  =UITableViewCellSelectionStyleNone;
        
        cell.textLabel.font  =[UIFont systemFontOfSize:17];
        
        cell.textLabel.text =@"预计恢复时间";
        
        cell.accessoryType  =UITableViewCellAccessoryDisclosureIndicator;
        
        cell.detailTextLabel.font  =[UIFont systemFontOfSize:15];
        cell.detailTextLabel.text  = self.contentDictionary[@"选择时间"]?:@"";
        
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    NSString * sectionTitle  = self.sectionTitles[indexPath.section];
    if ([sectionTitle isEqualToString:@"选择时间"]) {
        [self.alertView show];
        KWeakSelf
        self.alertView.dateBlock = ^(NSString * _Nonnull dateString) {
            [weakSelf.contentDictionary setObject:dateString forKey:@"选择时间"];
            [weakSelf.tableView reloadData];
        };
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sectionTitles[section];
}



-(void)setupDatas{
    NSArray * arr  = @[@"选择人员",@"选择时间"];
    [self.sectionTitles addObjectsFromArray:arr];
    
}


-(void)getDatas{
    NSMutableDictionary * parms  =[NSMutableDictionary dictionary];
    //取出工厂
    NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
    MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
    [modleArchiver finishDecoding];
    NSArray * factoryList = moudleStatus.FactoryList;
    NSDictionary * dic = [factoryList firstObject];
    
    [parms setObject:dic[@"FactoryId"] forKey:@"FactoryId"];
    
    [parms setObject:self.constructionId forKey:@"ConstructionTaskId"];
    
    [parms setObject:@"3" forKey:@"Type"];
    [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    NSString * url =@"maint/construstiontask/getConstructionEngineer";
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    
    KWeakSelf
    [HttpTool POST:[url getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
      
        [Units hiddenHudWithView:weakSelf.view];
        if ([[responseObject objectForKey:@"status"]intValue]==0) {
            NSArray * arr  =[Units jsonToArray:responseObject[@"data"]];
            [weakSelf.datasource removeAllObjects];
            [weakSelf.datasource addObjectsFromArray:arr];
        }
        [weakSelf.tableView reloadData];
        
    } error:^(NSString * _Nonnull error) {
        [Units hiddenHudWithView:weakSelf.view];
        [Units showErrorStatusWithString:error];
    }];
}

-(NSMutableArray*)sectionTitles{
    if (!_sectionTitles) {
        _sectionTitles  =[NSMutableArray array];
    }
    return _sectionTitles;
}

-(MCOperateChangeSchuleAlertView*)alertView{
    if (!_alertView) {
        _alertView  =[[MCOperateChangeSchuleAlertView alloc]init];
        [self.view.window addSubview:_alertView];
    }
    return _alertView;
}

-(NSMutableDictionary*)contentDictionary{
    if (!_contentDictionary) {
        _contentDictionary =[NSMutableDictionary dictionary];
    }return _contentDictionary;
}
@end
