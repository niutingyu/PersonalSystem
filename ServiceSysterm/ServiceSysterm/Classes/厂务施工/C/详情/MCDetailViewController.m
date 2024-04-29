//
//  MCDetailViewController.m
//  ServiceSysterm
//
//  Created by Andy on 2020/10/24.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MCDetailViewController.h"

#import "MCDetailMaintainTableCell.h"
#import "MCDetailOPerationLogCell.h"
#import "MCUserOperateRemarkTableCell.h"
#import "MCDetailHeadView.h"
#import "MCBaseMsgRemarkTableCell.h"

#import "MCDetailModel.h"

#import "YBPopupMenu.h"
#import "MCOperateRemarkAlertView.h"
#import "MCDetailChoseTimeController.h"
#import "MCDetailExtendSchudleController.h"
#import "MCDetailAppointController.h"
#import "MCDetailPauseController.h"
#import "MCDetailWorkLogController.h"

@interface MCDetailViewController ()<YBPopupMenuDelegate>

@property (nonatomic,strong)NSMutableArray * sectionTitleArray;

@property (nonatomic,strong)NSMutableArray *bMessageArray;//基本信息

@property (nonatomic,strong)NSMutableArray * maitainArray;

@property (nonatomic,strong)NSMutableArray * operateTypeArray;//操作类型


@end

@implementation MCDetailViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getDatas];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"单详情";
    [self.view addSubview:self.tableView];
    
    self.tableView.estimatedRowHeight  =230.0f;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[MCDetailMaintainTableCell class] forCellReuseIdentifier:@"cell0"];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MCDetailOPerationLogCell class]) bundle:nil] forCellReuseIdentifier:@"cell2"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MCUserOperateRemarkTableCell" bundle:nil] forCellReuseIdentifier:@"cell4"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MCBaseMsgRemarkTableCell" bundle:nil] forCellReuseIdentifier:@"baseCellId"];
    
    
    self.tableView.separatorStyle  =UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.mj_header  =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDatas];
    }];
    
    
   
    
    
    
    
   
}


-(void)operateMethod:(UIButton*)sender{
    NSArray * titles  = @[@"通过",@"驳回",@"排期",@"修改排期",@"指派",@"改单",@"增援指派",@"接单",@"填写工作日志",@"申请验收",@"解除暂停",@"暂停",@"延长排期",@"移除指派",@"确认验收",@"驳回返工",@"同意改期",@"驳回改期",@"同意延期",@"驳回延期",@"作废",@"问题记录"];
       MCDetailModel * model  = [self.datasource firstObject];
       
       NSArray * arr  =model.OperateArray;
    if (!_operateTypeArray) {
        _operateTypeArray  =[NSMutableArray array];
    }
    [_operateTypeArray removeAllObjects];
    
   
       
       for (MCDetailOperateModel *operateModel in arr) {
           [_operateTypeArray addObject:[titles objectAtIndex:operateModel.PassFlag]];
       }
       
       [YBPopupMenu showRelyOnView:sender titles:_operateTypeArray icons:nil menuWidth:150 otherSettings:^(YBPopupMenu *popupMenu) {
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
    
    [ybPopupMenu dismiss];
    
    NSString * tip  = self.operateTypeArray[index];
    if ([tip isEqualToString:@"通过"]||[tip isEqualToString:@"驳回"]) {
        [self passOrRejectWithTitle:tip];
    }else if ([tip isEqualToString:@"排期"]||[tip isEqualToString:@"修改排期"]||[tip isEqualToString:@"延长排期"]){
        [self schudleWithTitle:tip];
    }else if ([tip isEqualToString:@"指派"]||[tip isEqualToString:@"增援指派"]||[tip isEqualToString:@"移除指派"]){
        [self appointWithTitle:tip];
    }else if ([tip isEqualToString:@"接单"]||[tip isEqualToString:@"解除暂停"]){
        [self accepTaskWithTitle:tip];
        
    }else if ([tip isEqualToString:@"暂停"]||[tip isEqualToString:@"作废"]||[tip isEqualToString:@"问题记录"]){
        [self pauseTaskWithTitle:tip];
    }else if ([tip isEqualToString:@"申请验收"]||[tip isEqualToString:@"填写工作日志"]){
        [self workLogWithTitle:tip];
    }else if ([tip isEqualToString:@"同意改期"]||[tip isEqualToString:@"驳回改期"]||[tip isEqualToString:@"同意延期"]||[tip isEqualToString:@"驳回延期"]){
        [self schudleCheckWithTitle:tip];
    }else if ([tip isEqualToString:@"确认验收"]||[tip isEqualToString:@"驳回返工"]){
        [self sureCheckAndAcceptWithTitle:tip];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionTitleArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MCDetailModel * model  = [self.datasource firstObject];
    NSString * tip  = self.sectionTitleArray[section];
    if ([tip isEqualToString:@"基本信息"]) {
        return self.bMessageArray.count;
    }else if ([tip isEqualToString:@"维修数据"]){
        return 1;
    }else if ([tip isEqualToString:@"用户操作日志"]){
        return model.UserOperateArray.count;
    }else{
        return model.LinkmanArray.count;
    }
 
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * tip  =self.sectionTitleArray[indexPath.section];
    MCDetailModel * model  =[self.datasource firstObject];
    
    if ([tip isEqualToString:@"基本信息"]) {
        NSString  * tipStr  = self.bMessageArray[indexPath.row];
        if ([tipStr containsString:@"备注"]) {
            return 48+model.remarkheight;
        }else{
            return  48.0f;
        }
        
    }else if ([tip isEqualToString:@"维修数据"]){
        MCDetailMaintainArrayModel * maintainModel  = model.MaintainArray[indexPath.row];
      
        if (maintainModel.logHeight >0) {
          
            return maintainModel.logHeight+self.maitainArray.count *48-20;
        }else{
            return self.maitainArray.count *48;
        }
        
    }else if ([tip isEqualToString:@"用户操作日志"]){
        MCDetailUserOperateArrayModel *oModel  =model.UserOperateArray[indexPath.row];
        if (oModel.SignRemark.length >0) {
            return 128+oModel.cellHeight;
        }else{
            return 80;
        }
       
     
    }else  {
        return 48.0f;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * tip  = self.sectionTitleArray[indexPath.section];
    
    MCDetailModel * model  = [self.datasource firstObject];
    if ([tip isEqualToString:@"基本信息"]) {
        NSString * cellStr  = self.bMessageArray[indexPath.row];
        if ([cellStr containsString:@"备注"]) {
            MCBaseMsgRemarkTableCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"baseCellId"];
            NSArray * titles  = [self.bMessageArray[indexPath.row] componentsSeparatedByString:@":"];
            
            cell.remarkLab.text  = [titles lastObject];
            
            return cell;
        }else{
            UITableViewCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if (cell  ==nil) {
                cell  =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
                
            }
            
            cell.selectionStyle  =UITableViewCellSelectionStyleNone;
            
            cell.textLabel.numberOfLines  =0;
            cell.textLabel.font  =[UIFont systemFontOfSize:15];
            cell.textLabel.text  = self.bMessageArray[indexPath.row];
            
            
            return cell;

        }
    }else if ([tip isEqualToString:@"维修数据"]){
      //  MCDetailMaintainTableCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
        MCDetailMaintainTableCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cell0"];

        
    //    MCDetailMaintainArrayModel * maintainModel  = model.MaintainArray[indexPath.row];
     //   [cell setupMaintainCellWithModel:maintainModel];
        
        cell.maintainArray  =model.MaintainArray;
        
        return cell;
    }else if ([tip isEqualToString:@"用户操作日志"]){
        
//        UITableViewCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cell2"];
//        if (cell  ==nil) {
//            cell  =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell2"];
//
//        }
//        MCDetailUserOperateArrayModel *oModel  = model.UserOperateArray[indexPath.row];
//
//
//        cell.textLabel.font  =[UIFont systemFontOfSize:15];
//
//        cell.textLabel.text  = [NSString stringWithFormat:@"%@(%@)   %@",oModel.PassFlag,oModel.FName,oModel.SignTime];
//
//        cell.detailTextLabel.text  = [NSString stringWithFormat:@"操作备注:%@",oModel.SignRemark?:@"无"];
//        cell.detailTextLabel.numberOfLines  =0;
        


        MCDetailUserOperateArrayModel * oModel  = model.UserOperateArray[indexPath.row];
        
        if (oModel.SignRemark.length ==0) {
            MCDetailOPerationLogCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cell2"];
            
            [cell setupCellWithModel:oModel];
            
            return cell;
        }else{
            MCUserOperateRemarkTableCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cell4"];
            [cell setupremarkcellWithModel:oModel];
            
            return cell;
        }
      
    }else{
        UITableViewCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (cell  ==nil) {
            cell  =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
            
        }
        
        cell.selectionStyle  =UITableViewCellSelectionStyleNone;
        
        MCDeatilLinkmanArrayModel *lModel  = model.LinkmanArray[indexPath.row];
        
        cell.textLabel.font  =[UIFont systemFontOfSize:15];
        
        cell.textLabel.text  =[NSString stringWithFormat:@"%@:%@",lModel.Ms,lModel.FName];
        
        cell.imageView.image  =[UIImage imageNamed:@"tel"];
        
        return cell;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MCDetailHeadView * headView  =[[MCDetailHeadView alloc]init];
    
    headView.titleLab.text  = self.sectionTitleArray[section];
    
    return headView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 48.0f;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * sectionString  = self.sectionTitleArray[indexPath.section];
    if ([sectionString isEqualToString:@"单相关联系人"]) {
        MCDetailModel * dModel  = [self.datasource firstObject];
        
        MCDeatilLinkmanArrayModel * model  =dModel.LinkmanArray[indexPath.row];
        
        [self callWithModel:model];
    }
}

-(void)callWithModel:(MCDeatilLinkmanArrayModel*)model{
    if ([model.UserMobile isEqualToString:@""]&&[model.UserShortMobile isEqualToString:@""]) {
           [Units showErrorStatusWithString:[NSString stringWithFormat:@"%@未绑定手机号",model.FName]];
           return ;
       }
       UIAlertController * controller= [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"给%@打电话",model.FName] message:@"" preferredStyle:UIAlertControllerStyleAlert];
       UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"长号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
           [self callWithNumber:model.UserMobile andView:self.view];
           
       }];
       UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"短号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           [self callWithNumber:model.UserShortMobile?:model.UserMobile andView:self.view];
       }];
       UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           
       }];
       [controller addAction:action1];
       [controller addAction:action2];
       [controller addAction:action3];
       [self presentViewController:controller animated:YES completion:nil];
}

- (void)callWithNumber:(NSString *)num andView:(UIView *)view {
  //  UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",num]];//
    [[UIApplication sharedApplication]openURL:telURL];
   // [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
   // [view addSubview:callWebview];
}
-(void)getDatas{
    NSMutableDictionary * parms  =[NSMutableDictionary dictionary];
    [parms setObject:self.constructionId forKey:@"ConstructionTaskId"];
    [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    NSString * url  = @"maint/construstiontask/detailMsg";
    
    KWeakSelf
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    
    [HttpTool POST:[url getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:weakSelf.view];
        
        if ([[responseObject objectForKey:@"status"]intValue]==0) {
            NSDictionary * dic  = [Units jsonToDictionary:responseObject[@"data"]];
            debugLog(@" == = == = %@",dic);
            MCDetailModel * model  = [MCDetailModel mj_objectWithKeyValues:dic];
            [weakSelf.datasource removeAllObjects];
            [weakSelf.datasource addObject:model];
            
            //基本信息
            [weakSelf setupBMessageWithModel:model];
            
            //操作按钮
           
             [weakSelf setupOperateButtonWithModel:model];
            
            //维续数据
            [weakSelf setupMaintainArrayWithModel:model];
            
         
            
            
        
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
  
        
    } error:^(NSString * _Nonnull error) {
        [Units hiddenHudWithView:weakSelf.view];
        [Units showErrorStatusWithString:error];
        
    }];
}
//设置操作按钮

-(void)setupOperateButtonWithModel:(MCDetailModel*)model{
    
    
    UIButton * but  =[UIButton buttonWithType:UIButtonTypeCustom];
    [but setTitle:@"操作" forState:UIControlStateNormal];
    but.titleLabel.font  =[UIFont systemFontOfSize:15];
    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(operateMethod:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem =[[UIBarButtonItem alloc]initWithCustomView:but];
    
    if (model.OperateArray.count >0) {
     self.navigationItem.rightBarButtonItem  = rightItem;
    }else{
        self.navigationItem.rightBarButtonItem  =nil;
    }
    
}

-(void)setupBMessageWithModel:(MCDetailModel*)model{
    [self.bMessageArray removeAllObjects];
    
    [self.bMessageArray addObject:[NSString stringWithFormat:@"维修单号:%@",model.taskCode]];
    [self.bMessageArray addObject:[NSString stringWithFormat:@"开单人员:%@-%@",model.dpartName,model.operCreateUser]];
    [self.bMessageArray addObject:[NSString stringWithFormat:@"开单时间:%@",model.issueTime]];
    [self.bMessageArray addObject:[NSString stringWithFormat:@"单状态:%@",model.taskStatus]];
    [self.bMessageArray addObject:[NSString stringWithFormat:@"施工部门:%@",model.consDepartName]];
    [self.bMessageArray addObject:[NSString stringWithFormat:@"施工类型:%@",model.sgType?:@""]];
   
    if (model.planStartTime.length >0) {
      [self.bMessageArray addObject:[NSString stringWithFormat:@"预计恢复时间:%@",model.planStartTime?:@""]];
    }
    if (model.predictBeginTime.length >0) {
        [self.bMessageArray addObject:[NSString stringWithFormat:@"预计开始施工:%@",model.predictBeginTime?:@""]];
    }
    if (model.predictEndTime.length >0) {
      [self.bMessageArray addObject:[NSString stringWithFormat:@"预计结束施工:%@",model.predictEndTime?:@""]];
    }if (model.remark.length >0) {
      [self.bMessageArray addObject:[NSString stringWithFormat:@"备注:%@",model.remark]];
    }
    
}


//维修数据

-(void)setupMaintainArrayWithModel:(MCDetailModel*)mModel{
    
    [self.maitainArray removeAllObjects];
    
    NSArray * arr  = mModel.MaintainArray;
    
 
    for (MCDetailMaintainArrayModel* model in arr) {
        NSMutableArray * setupArray  = [NSMutableArray array];
        [setupArray removeAllObjects];
        NSMutableDictionary * dict  =[NSMutableDictionary dictionary];
        [dict removeAllObjects];
        
        if (model.issueTime.length >0) {
            [self.maitainArray addObject:model];
        }if (model.assignTime.length >0) {
            [self.maitainArray addObject:model];
        }if (model.acceptTime.length >0) {
            [self.maitainArray addObject:model];
        }if (model.applyFinishTime.length >0) {
            [self.maitainArray addObject:model];
        }if (model.finishTime.length >0) {
            [self.maitainArray addObject:model];
        }if (model.maintime.length >0) {
            [self.maitainArray addObject:model];
            
        }if (model.ReactTime.length >0) {
            [self.maitainArray addObject:model];
        }if (model.pauseTime.length >0) {
            [self.maitainArray addObject:model];
        }if (model.workLog.length >0) {
            [self.maitainArray addObject:model];
        }
    }
}

#pragma mark  = = = == = == = = = = = == = = == = = = = = = = 操作

//通过 驳回

-(void)passOrRejectWithTitle:(NSString*)title{
    KWeakSelf
    
    NSString * url =@"maint/construstiontask/examineTask";
    
    [MCOperateRemarkAlertView showAlerMCRemarkAlertViewWithHeadString:title commitBlock:^(NSString * _Nonnull text) {
      
        NSMutableDictionary * parms  =[NSMutableDictionary dictionary];
        [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
        [parms setObject:weakSelf.constructionId forKey:@"ConstructionTaskId"];
        [parms setObject:[title isEqualToString:@"通过"]?@"1":@"0" forKey:@"Type"];
        [parms setObject:text?:@"" forKey:@"OperateDescribe"];
        
        [Units showHudWithText:Loading view:weakSelf.view model:MBProgressHUDModeIndeterminate];
        
        [HttpTool POST:[url getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
           
            [Units  hiddenHudWithView:weakSelf.view];
            [Units showStatusWithStutas:responseObject[@"info"]];
            if ([[responseObject objectForKey:@"status"]intValue]==0) {
                [weakSelf getDatas];
                
                //
               
            }
            
            debugLog(@" -- - -%@",responseObject);
           
        } error:^(NSString * _Nonnull error) {
            [Units hiddenHudWithView:weakSelf.view];
            [Units showErrorStatusWithString:error];
            
        }];
        
        
       
    }];
}





//排期 修改排期 延长排期

-(void)schudleWithTitle:(NSString*)title{
    MCDetailExtendSchudleController * controller  =[MCDetailExtendSchudleController new];
    controller.typeString  = title;
    controller.constructionId  = self.constructionId;
    [self.navigationController pushViewController:controller animated:YES];
    KWeakSelf
    controller.finishNetBlock = ^{
        [weakSelf getDatas];
    };
}

//指派 增援指派 移除指派

-(void)appointWithTitle:(NSString*)title{
    MCDetailAppointController * controller  =[[MCDetailAppointController alloc]init];
    controller.constructionId  =self.constructionId;
    controller.constructionType  = title;
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

//接单 接触暂停

-(void)accepTaskWithTitle:(NSString *)title{
    NSString * url =@"maint/construstiontask/acceptTask";
    
    KWeakSelf
    NSString * typeString =nil;
    if ([title isEqualToString:@"接单"]) {
        typeString  = @"0";
    }else{
        typeString =@"1";
    }
    [MCOperateRemarkAlertView showAlerMCRemarkAlertViewWithHeadString:title commitBlock:^(NSString * _Nonnull text) {
        NSMutableDictionary * parms  =[NSMutableDictionary dictionary];
        [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
        [parms setObject:weakSelf.constructionId forKey:@"ConstructionTaskId"];
        [parms setObject:typeString forKey:@"Type"];
        [parms setObject:text?:@"" forKey:@"OperateDescribe"];
        [Units showHudWithText:Loading view:weakSelf.view model:MBProgressHUDModeIndeterminate];
        
        [HttpTool POST:[url getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
            [Units hiddenHudWithView:weakSelf.view];
            [Units showStatusWithStutas:responseObject[@"info"]];
            
            if ([[responseObject objectForKey:@"status"]intValue]==0) {
                [weakSelf getDatas];
            }
            debugLog(@" -= == = %@",responseObject[@"info"]);
        } error:^(NSString * _Nonnull error) {
            [Units hiddenHudWithView:weakSelf.view];
            [Units showErrorStatusWithString:error];
            
        }];
    }];
}

//暂停 作废 问题记录

-(void)pauseTaskWithTitle:(NSString*)title{
    if ([title  isEqualToString:@"暂停"]) {
        MCDetailPauseController * controller  =[[MCDetailPauseController alloc]init];
        controller.constructionId  = self.constructionId;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        KWeakSelf
        NSString * url =@"maint/construstiontask/pasueOrCancel";
        [MCOperateRemarkAlertView showAlerMCRemarkAlertViewWithHeadString:title commitBlock:^(NSString * _Nonnull text) {
            NSMutableDictionary *parms  =[NSMutableDictionary dictionary];
            [parms setObject:weakSelf.constructionId forKey:@"ConstructionTaskId"];
            [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
            [parms setObject:[title isEqualToString:@"作废"]?@"1":@"2" forKey:@"Type"];
            [parms setObject:text forKey:@"operateDescribe"];
            [Units showHudWithText:Loading view:weakSelf.view model:MBProgressHUDModeIndeterminate];
            
            [HttpTool POST:[url getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
                [Units hiddenHudWithView:weakSelf.view];
                [Units showStatusWithStutas:responseObject[@"info"]];
                if ([[responseObject objectForKey:@"status"]intValue]==0) {
                    [weakSelf getDatas];
                }
            } error:^(NSString * _Nonnull error) {
                [Units hiddenHudWithView:weakSelf.view];
                [Units showErrorStatusWithString:error];
            }];
        }];
    }

    
}

//申请验收  填写日志

-(void)workLogWithTitle:(NSString*)title{
    
    NSString * url =@"maint/construstiontask/applyFinish";
  KWeakSelf
    if ([title isEqualToString:@"申请验收"]) {
        [MCOperateRemarkAlertView showAlerMCRemarkAlertViewWithHeadString:title commitBlock:^(NSString * _Nonnull text) {
            NSMutableDictionary * parms  =[NSMutableDictionary dictionary];
            [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
            
            [parms setObject:@"0" forKey:@"type"];
            [parms setObject:text?:@"" forKey:@"operateDescribe"];
            [parms setObject:weakSelf.constructionId forKey:@"ConstructionTaskId"];
            
            [Units showHudWithText:Loading view:weakSelf.view model:MBProgressHUDModeIndeterminate];
            
            [HttpTool POST:[url getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
                [Units hiddenHudWithView:weakSelf.view];
                
                debugLog(@" = ==%@",responseObject[@"info"]);
            } error:^(NSString * _Nonnull error) {
                [Units hiddenHudWithView:weakSelf.view];
            }];
        }];
    }else{
        MCDetailWorkLogController * controller  =[[MCDetailWorkLogController alloc]init];
        controller.constructionId  =self.constructionId;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}


//改期审核

-(void)schudleCheckWithTitle:(NSString*)title{
    NSString * typeStr =nil;
    if ([title isEqualToString:@"同意改期"]) {
        typeStr =@"0";
    }else if ([title  isEqualToString:@"驳回改期"]){
        typeStr  =@"1";
    }else if ([title  isEqualToString:@"同意延期"]){
        typeStr  =@"2";
    }else if ([title isEqualToString:@"驳回延期"]){
        typeStr  =@"3";
        
    }
    
    NSString *url =@"maint/construstiontask/sgScheduleExamine";
   
    KWeakSelf
    
    [MCOperateRemarkAlertView showAlerMCRemarkAlertViewWithHeadString:title commitBlock:^(NSString * _Nonnull text) {
        NSMutableDictionary * parms  =[NSMutableDictionary dictionary];
        [parms setObject:typeStr forKey:@"Type"];
        [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
        [parms setObject:self.constructionId forKey:@"ConstructionTaskId"];
        [parms setObject:text?:@"" forKey:@"OperateDescribe"];
        [Units showHudWithText:Loading view:weakSelf.view model:MBProgressHUDModeIndeterminate];
        
        [HttpTool POST:[url getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
            [Units hiddenHudWithView:weakSelf.view];
            [Units showStatusWithStutas:responseObject[@"info"]];
            
            if ([[responseObject objectForKey:@"status"]intValue]==0) {
                [weakSelf getDatas];
            }
        } error:^(NSString * _Nonnull error) {
            [Units hiddenHudWithView:weakSelf.view];
            [Units showErrorStatusWithString:error];
        }];
        
    }];
}

//确认验收 驳回返工

-(void)sureCheckAndAcceptWithTitle:(NSString*)title{
    NSString *url  =@"maint/construstiontask/confirmFinish";
    KWeakSelf
    [MCOperateRemarkAlertView showAlerMCRemarkAlertViewWithHeadString:title commitBlock:^(NSString * _Nonnull text) {
        NSMutableDictionary * parms  =[NSMutableDictionary dictionary];
        [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
        [parms setObject:weakSelf.constructionId forKey:@"ConstructionTaskId"];
        [parms setObject:[title isEqualToString:@"确认验收"]?@"0":@"1" forKey:@"type"];
        [parms setObject:text?:@"" forKey:@"operateDescribe"];
        
        [Units showHudWithText:Loading view:weakSelf.view model:MBProgressHUDModeIndeterminate];
        
        [HttpTool POST:[url getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
            
            [Units hiddenHudWithView:weakSelf.view];
            
            [Units showStatusWithStutas:responseObject[@"info"]];
            if ([[responseObject objectForKey:@"status"]intValue]==0) {
                [weakSelf getDatas];
            }
        } error:^(NSString * _Nonnull error) {
            [Units hiddenHudWithView:weakSelf.view];
            [Units showErrorStatusWithString:error];
        }];
    }];
}
-(NSMutableArray*)sectionTitleArray{
    if (!_sectionTitleArray) {
        _sectionTitleArray  =[NSMutableArray array];
        
        NSArray * arr  = @[@"基本信息",@"维修数据",@"用户操作日志",@"单相关联系人"];
        [_sectionTitleArray addObjectsFromArray:arr];
    }
    return _sectionTitleArray;
}


-(NSMutableArray*)bMessageArray{
    if (!_bMessageArray) {
        _bMessageArray  =[NSMutableArray array];
    }
    return _bMessageArray;
}

-(NSMutableArray*)maitainArray{
    if (!_maitainArray) {
        _maitainArray  =[NSMutableArray array];
    }return _maitainArray;
}
@end
