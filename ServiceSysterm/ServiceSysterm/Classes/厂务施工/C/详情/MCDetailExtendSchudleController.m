//
//  MCDetailExtendSchudleController.m
//  ServiceSysterm
//
//  Created by Andy on 2020/10/30.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MCDetailExtendSchudleController.h"

#import "MCDetailExtendSchudleTableCell.h"
#import "MCOperateRemarkTableCell.h"
#import "MCOperateChangeSchuleAlertView.h"

@interface MCDetailExtendSchudleController ()

@property (nonatomic,strong)NSMutableArray * sectionTitles;

@property (nonatomic,strong)MCOperateChangeSchuleAlertView * alertView;

@property (nonatomic,strong)NSMutableDictionary * contentDictionary;
@end

@implementation MCDetailExtendSchudleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  =[UIColor whiteColor];
    self.title =self.typeString;
    [self setupDatas];
    
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MCDetailExtendSchudleTableCell class]) bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MCOperateRemarkTableCell class]) bundle:nil] forCellReuseIdentifier:@"cell2"];
    
    UIBarButtonItem * right  =[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(sureMethod)];
    self.navigationItem.rightBarButtonItem  =right;
    
    
    
}

-(void)sureMethod{
    [self.view endEditing:YES];
    NSString * beginTime  = self.contentDictionary[@"预计开始"];
    NSString * endTime  = self.contentDictionary[@"预计结束"];
    
    if (beginTime.length  ==0) {
        [Units showWarningWithTitle:@"提示" andSubTitle:@"预计开始时间必填" andView:self.view];
        return;
    }if (endTime.length  ==0) {
        [Units showWarningWithTitle:@"提示" andSubTitle:@"预计结束时间必填" andView:self.view];
        return;
    }
    
    NSString * typeString =nil;
    if ([self.typeString isEqualToString:@"排期"]) {
        typeString  =@"0";
    }else if ([self.typeString  isEqualToString:@"修改排期"]){
        typeString  =@"1";
    }else{
        typeString  =@"2";
    }
    NSString * remark  = self.contentDictionary[@"备注"];
    
    if ([self.typeString isEqualToString:@"修改排期"]||[self.typeString isEqualToString:@"延长排期"]) {
        if (remark.length  ==0) {
            [Units showWarningWithTitle:@"提示" andSubTitle:@"备注必填" andView:self.view];
            return;
        }
    }
    NSString * url =@"maint/construstiontask/sgSchedule";
    NSMutableDictionary * parms  =[NSMutableDictionary dictionary];
    [parms setObject:beginTime forKey:@"PredictBeginTime"];
    
    [parms setObject:endTime forKey:@"PredictEndTime"];
    [parms setObject:self.constructionId forKey:@"ConstructionTaskId"];
    [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    [parms setObject:typeString forKey:@"Type"];
    [parms setObject:remark?:@"" forKey:@"OperateDescribe"];
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    
    KWeakSelf
    [HttpTool POST:[url getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
      
        if ([[responseObject  objectForKey:@"status"]intValue]==0) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            if (weakSelf.finishNetBlock) {
                weakSelf.finishNetBlock();
            }
        }
     
        
    } error:^(NSString * _Nonnull error) {
        
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionTitles.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString * tip  = self.sectionTitles[section];
    if ([tip isEqualToString:@"预计时间"]) {
        return self.datasource.count;
    }else{
        return 1;
    }
  
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
      NSString * sectionTitle = self.sectionTitles[indexPath.section];
      
      if ([sectionTitle isEqualToString:@"预计时间"]) {
         
        UITableViewCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cell0"];
         if (cell  ==nil) {
                cell  =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell0"];
            }
                    
         cell.accessoryType  =UITableViewCellAccessoryDisclosureIndicator;
                    
                       
         cell.selectionStyle  =UITableViewCellSelectionStyleNone;
                       
          cell.textLabel.font =[UIFont systemFontOfSize:16];
                    
          cell.textLabel.text = [NSString stringWithFormat:@"%@:",self.datasource[indexPath.row]];
                 
                 cell.detailTextLabel.font =[UIFont systemFontOfSize:15];
                 
          cell.detailTextLabel.text  = self.contentDictionary[self.datasource[indexPath.row]];
                    
                    
            return cell;
                 
          
    
      }else{
          MCOperateRemarkTableCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cell2"];
          KWeakSelf
          cell.contentBlock = ^(NSString * _Nonnull text) {
              [weakSelf.contentDictionary setObject:text forKey:@"备注"];
              
          };
          return cell;
      }

   
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *tip  = self.sectionTitles[indexPath.section];
    if ([tip  isEqualToString:@"预计时间"]) {
        return 48.0f;
    }else{
        return 76.0f;
    }
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
   
    return self.sectionTitles[section];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * sectionTitle  = self.sectionTitles[indexPath.section];
    if ([sectionTitle isEqualToString:@"预计时间"]) {
        NSString * tip  = self.datasource[indexPath.row];
        if ([tip isEqualToString:@"预计开始"]||[tip isEqualToString:@"预计结束"]) {
            [self.alertView show];
            KWeakSelf
            self.alertView .dateBlock = ^(NSString * _Nonnull dateString) {
                [weakSelf.contentDictionary setObject:dateString forKey:tip];
                [weakSelf.tableView reloadData];
                debugLog(@" = == %@",dateString);
            };
        }
    }
}

-(void)setupDatas{
    NSArray * titles =nil;
    
    titles =@[@"预计开始",@"预计结束"];
    
    [self.datasource addObjectsFromArray:titles];
    
}

-(NSMutableArray*)sectionTitles{
    if (!_sectionTitles) {
        _sectionTitles  =[NSMutableArray array];
        NSArray * arr  =@[@"预计时间",@"备注"];
        [_sectionTitles addObjectsFromArray:arr];
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
        _contentDictionary  =[NSMutableDictionary dictionary];
    }
    return _contentDictionary;
}
@end
