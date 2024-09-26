//
//  DEUnfinishDetailController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/15.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEUnfinishDetailController.h"
#import "DEUnfinishDetailModel.h"
#import "DEUnfinishSectionView.h"
#import "DEMessageTelTableCell.h"


#import "YBPopupMenu.h"
#import "AppointAlertView.h"
#import "ApplyFinishAlertView.h"

#import "DEPauseRepairController.h"
#import "DEProblemMessageController.h"
#import "DECheckProblemController.h"
#import "ProgressView.h"
#import "AlertView.h"
#import "ExpectFinishTimeController.h"
#import "ApplayAcceptanceController.h"
#import "ReviseErrorController.h"
#import "DEMaintenceBYTableCell.h"

@interface DEUnfinishDetailController ()<YBPopupMenuDelegate>
{
    NSInteger _isSelected;
}
@property (nonatomic,strong)NSMutableArray * sectionHeadLineArray;
@property (nonatomic,strong)NSMutableArray *basicMessageArray;//基本信息
@property (nonatomic,strong)NSMutableArray * repairMessageArray;//维修信息
@property (nonatomic,strong)NSMutableArray * maintainDataArray;//维修数据
@property (nonatomic,strong)NSMutableArray * recordArray;//操作日志
@property (nonatomic,strong)NSMutableArray * linkArray;//单相关联系人
@property (nonatomic,strong)NSMutableArray * operationArray;//操作按钮

@property (nonatomic,strong)NSMutableArray *maintenceStepList;//保养清单

@property (nonatomic,strong)NSMutableArray * selectedItemArray;//选中人员

@property (nonatomic,strong)NSMutableDictionary * exceptionMutableDictionary;

@property (nonatomic,assign)BOOL isPop;



@end

@implementation DEUnfinishDetailController

-(void)getMessage{
    NSMutableDictionary *parames =[NSMutableDictionary dictionary];
    NSString * urlString;
    //判断参数 s
    if ([_controllerType isEqualToString:@"设备维修"]) {
        [parames setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
        [parames setObject:self.maintainId forKey:@"MaintainTaskId"];
        urlString =[DeviceUnfinishTaskDetailURL getWholeUrl];
    }else{
        [parames setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
        [parames setObject:self.maintainId forKey:@"MaintainDjbyId"];
        urlString =[DeviceDetailMsgURL getWholeUrl];
    }
    [Units showLoadStatusWithString:Loading];
    KWeakSelf
    [self.datasource removeAllObjects];
    [HttpTool POST:urlString param:parames success:^(id  _Nonnull responseObject) {
        [Units hideView];
        if ([[responseObject objectForKey:@"status"]integerValue]==0) {
            NSDictionary * dict =[Units jsonToDictionary:responseObject[@"data"]];
            DEUnfinishDetailModel * model = [DEUnfinishDetailModel mj_objectWithKeyValues:dict];
            [weakSelf.datasource addObject:model];
            //操作数据    是否显示操作按钮  对应OperateArray数组
            if (model.OperateArray&&model.OperateArray.count>0) {
                [weakSelf setrightBar];
            }else{
                weakSelf.navigationItem.rightBarButtonItem =nil;
            }
            //点检 点检复核 点检稽核 保养复核 保养稽核 未完成问题点 移交下月 已完成 移交待审核
            NSMutableArray * exceptionArray = [ExceptionModel mj_objectArrayWithKeyValuesArray:model.ExceptionArray];
            [weakSelf setupotherTitles:exceptionArray];
            //维修数据
            NSMutableArray * repairArr = [MaintainModel mj_objectArrayWithKeyValuesArray:model.MaintainArray];
            if (repairArr.count == 0) {
                [weakSelf.sectionHeadLineArray removeObject:@"维修数据"];
            }else{
               [weakSelf setupRepairData:repairArr];
            }
           
            //操作日志
            NSMutableArray * records =[UserOperateModel mj_objectArrayWithKeyValuesArray:model.UserOperateArray];
            if (records.count ==0) {
                [weakSelf.sectionHeadLineArray removeObject:@"用户操作日志"];
            }else{
               [weakSelf setupUserOperationLog:records];
            }
           
            //设置完成状态 //点检保养 跳转的不设置headView
            if ([weakSelf.controllerType isEqualToString:@"设备维修"]) {
                [weakSelf setupTableHeadVView:model];
                [weakSelf setupBasicMessage:model];//基本信息
            }else{
                if ([self->_controllerType isEqualToString:@"设备维修"]) {
                 [weakSelf setupCheckBasicMessage:model];//基本信息
                }else{
                    [weakSelf setupBasicMessage:model];
                }
                
            }
           
            //维修信息
            [weakSelf setupRepairMessage:model];
            //单相关联系人
            NSMutableArray *links = [LinkManModel mj_objectArrayWithKeyValuesArray:model.LinkmanArray];
            [weakSelf.linkArray removeAllObjects];
            [weakSelf.linkArray addObjectsFromArray:links];
            //保养项目
            debugLog(@"=== = %@",model.MaintenceStepArray);
            NSMutableArray *maintenceSteps  =[MaintenceStepListModel mj_objectArrayWithKeyValuesArray:model.MaintenceStepArray];
            [weakSelf.maintenceStepList removeAllObjects];
            [weakSelf.maintenceStepList addObjectsFromArray:maintenceSteps];
            if (model.MaintenceStepArray.count  ==0) {
                [weakSelf.sectionHeadLineArray removeObject:@"保养信息"];
            }
            debugLog(@"=== = %@",self.maintenceStepList);
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
        
    } error:^(NSString * _Nonnull error) {
        [Units showErrorStatusWithString:error];
        [Units hideView];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isPop ==YES) {
     [self.tableView.mj_header beginRefreshing];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _isPop = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"单详情";
    _isPop =NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.estimatedRowHeight = 50.0f;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"DEMessageTelTableCell" bundle:nil] forCellReuseIdentifier:@"cellReusedId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DEMaintenceBYTableCell" bundle:nil] forCellReuseIdentifier:@"byCellId"];
   [self getMessage];
    _isSelected =1;
   // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadT) name:@"refresh" object:nil];
    KWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getMessage];
    }];
    //点检和维修的单详情都放在了一个控制器处理，所以看着代码有点多， 单逻辑并不复杂
    
}
-(void)reloadT{
   // [self.tableView reloadData];
}
//右边操作按钮
-(void)setrightBar{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"操作" forState:UIControlStateNormal];
    btn.bounds = CGRectMake(0, 0, 80, 20);
    btn.backgroundColor =[UIColor blueColor];
    btn.layer.cornerRadius = 15;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font =[UIFont systemFontOfSize:15.0f];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(operationBar:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
 
}

#pragma mark TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionHeadLineArray.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //点检 点检复核  点检稽核 保养复核 保养稽核 未完成问题点 待复核问题点 移交下月 已完成 移交待审核
    NSString * tipString = self.sectionHeadLineArray[section];
    if ([tipString isEqualToString:@"基本信息"]) {
        return self.basicMessageArray.count;
    }else if ([tipString isEqualToString:@"点检"]){
        NSArray * arr =[self.exceptionMutableDictionary objectForKey:@(0)];
        return arr.count;
    }else if ([tipString isEqualToString:@"点检复核"]){
        NSArray * arr =self.exceptionMutableDictionary[@(1)];
        return arr.count;
    }else if ([tipString isEqualToString:@"点检稽核"]){
        NSArray * arr =self.exceptionMutableDictionary[@(2)];
        return arr.count;
    }else if ([tipString isEqualToString:@"保养复核"]){
        NSArray * arr = self.exceptionMutableDictionary[@(3)];
        return arr.count;
    }else if ([tipString isEqualToString:@"保养稽核"]){
        NSArray * arr = self.exceptionMutableDictionary[@(4)];
        return arr.count;
    }else if ([tipString isEqualToString:@"未完成问题点"]){
        NSArray * arr = self.exceptionMutableDictionary[@(5)];
        return arr.count;
    }else if ([tipString isEqualToString:@"待复核问题点"]){
        NSArray * arr = self.exceptionMutableDictionary[@(6)];
        return arr.count;
    }else if ([tipString isEqualToString:@"移交下月"]){
        NSArray * arr = self.exceptionMutableDictionary[@(7)];
        return arr.count;
    }else if ([tipString isEqualToString:@"已完成"]){
        NSArray * arr = self.exceptionMutableDictionary[@(8)];
        return arr.count;
    }else if ([tipString isEqualToString:@"移交待审核"]){
        NSArray * arr = self.exceptionMutableDictionary[@(9)];
        return arr.count;
    }
    else if ([tipString isEqualToString:@"维修信息"]){
        return self.repairMessageArray.count;
    }else if ([tipString isEqualToString:@"维修数据"]){
        return self.maintainDataArray.count;
    }else if ([tipString isEqualToString:@"保养信息"]){
        DEUnfinishDetailModel * model = [self.datasource firstObject];
        if (model.maintenceStepIsOpen==NO) {
            return 0;
        }else{
            return self.maintenceStepList.count;
        }
      //  return self.maintenceStepList.count;
    }
    else if ([tipString isEqualToString:@"用户操作日志"]){
        DEUnfinishDetailModel * model = [self.datasource firstObject];
        if (model.isopen == NO) {
            return 0;
        }else{
         return self.recordArray.count;
        }
    }else if ([tipString isEqualToString:@"单相关联系人"]){
        return self.linkArray.count;
    }
    return 3;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.numberOfLines =0;
    cell.textLabel.textColor =[UIColor blackColor];
    NSString * tipString = self.sectionHeadLineArray[indexPath.section];
    if ([tipString isEqualToString:@"基本信息"]) {
        //基本信息
        cell.textLabel.text =self.basicMessageArray[indexPath.row];
        return cell;
    }else if ([tipString isEqualToString:@"维修信息"]){
        cell.textLabel.text = self.repairMessageArray[indexPath.row];
        return cell;
        
    }
    else if ([tipString isEqualToString:@"点检"]||[tipString isEqualToString:@"点检复核"]||[tipString isEqualToString:@"点检稽核"]||[tipString isEqualToString:@"保养复核"]||[tipString isEqualToString:@"保养稽核"]||[tipString isEqualToString:@"未完成问题点"]||[tipString isEqualToString:@"待复核问题点"]||[tipString isEqualToString:@"移交下月"]||[tipString isEqualToString:@"已完成"]||[tipString isEqualToString:@"移交待审核"]){
        //点检 点检复核  点检稽核 保养复核 保养稽核 未完成问题点 待复核问题点 移交下月 已完成 移交待审核
        cell.textLabel.textColor =[UIColor blueColor];
        //分别取出 没有想起好d方法
        ExceptionModel *model;
        NSArray * modelArray;
        NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        
        if ([tipString isEqualToString:@"点检"]) {
            modelArray =self.exceptionMutableDictionary[@(0)];
            model = modelArray[indexPath.row];
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:model.ContentName attributes:attribtDic];
            cell.textLabel.attributedText = attribtStr;
        }else if ([tipString isEqualToString:@"点检复核"]){
            modelArray = self.exceptionMutableDictionary[@(1)];
            model = modelArray[indexPath.row];
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:model.ContentName attributes:attribtDic];
            cell.textLabel.attributedText = attribtStr;
            
        }else if ([tipString isEqualToString:@"点检稽核"]){
            modelArray = self.exceptionMutableDictionary[@(2)];
            model = modelArray[indexPath.row];
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:model.ContentName attributes:attribtDic];
            cell.textLabel.attributedText = attribtStr;
        }else if ([tipString isEqualToString:@"保养复核"]){
            modelArray = self.exceptionMutableDictionary[@(3)];
            model = modelArray[indexPath.row];
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:model.ContentName attributes:attribtDic];
            cell.textLabel.attributedText = attribtStr;
        }else if ([tipString isEqualToString:@"保养稽核"]){
            modelArray = self.exceptionMutableDictionary[@(4)];
            model = modelArray[indexPath.row];
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:model.ContentName attributes:attribtDic];
            cell.textLabel.attributedText = attribtStr;
            
        }else if ([tipString isEqualToString:@"未完成问题点"]){
            modelArray =self.exceptionMutableDictionary[@(5)];
            model = modelArray[indexPath.row];
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:model.ContentName attributes:attribtDic];
            cell.textLabel.attributedText = attribtStr;
        }else if ([tipString isEqualToString:@"待复核问题点"]){
            modelArray = self.exceptionMutableDictionary[@(6)];
            model = modelArray[indexPath.row];
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:model.ContentName attributes:attribtDic];
            cell.textLabel.attributedText = attribtStr;
        }else if ([tipString isEqualToString:@"移交下月"]){
            modelArray = self.exceptionMutableDictionary[@(7)];
            model = modelArray[indexPath.row];
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:model.ContentName attributes:attribtDic];
            cell.textLabel.attributedText = attribtStr;
        }else if ([tipString isEqualToString:@"已完成"]){
            modelArray = self.exceptionMutableDictionary[@(8)];
            model = modelArray[indexPath.row];
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:model.ContentName attributes:attribtDic];
            cell.textLabel.attributedText = attribtStr;
        }else if ([tipString isEqualToString:@"移交待完成"]){
            modelArray = self.exceptionMutableDictionary[@(9)];
            model = modelArray[indexPath.row];
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:model.ContentName attributes:attribtDic];
            cell.textLabel.attributedText = attribtStr;
        }
      
        return cell;
    }
    
    
    else if ([tipString isEqualToString:@"维修数据"]){
        //维修数据
        cell.textLabel.text = self.maintainDataArray[indexPath.row];
        //改变字体颜色
        if ([cell.textLabel.text containsString:@"反应时间"]||[cell.textLabel.text containsString:@"维修时间"]||[cell.textLabel.text containsString:@"验收时差"]) {
            NSArray * titleArray = [cell.textLabel.text componentsSeparatedByString:@":"];
            cell.textLabel.attributedText = [Units changeLabel:[titleArray lastObject] wholeString:cell.textLabel.text];
          
        }else{
            cell.textLabel.textColor =[UIColor blackColor];
        }
        return cell;
    }else if ([tipString isEqualToString:@"保养信息"]){
        DEMaintenceBYTableCell *cell =[tableView dequeueReusableCellWithIdentifier:@"byCellId"];
     
        MaintenceStepListModel *model  =self.maintenceStepList[indexPath.row];
        [cell configCellWithModel:model idx:indexPath.row+1];
        return  cell;
    }
    else if ([tipString isEqualToString:@"用户操作日志"]){
        cell.textLabel.text = self.recordArray[indexPath.row];
       
        if ([cell.textLabel.text containsString:@"操作内容"]) {
            NSArray * titleArray = [cell.textLabel.text componentsSeparatedByString:@":"];
            cell.textLabel.attributedText =[Units changeLabel:[titleArray lastObject] wholeString:cell.textLabel.text];
        }
        return cell;
    }else if ([tipString isEqualToString:@"单相关联系人"]){
        DEMessageTelTableCell * mcell = [tableView dequeueReusableCellWithIdentifier:@"cellReusedId"];
        LinkManModel * model =self.linkArray[indexPath.row];
        
        mcell.tipLab.text = [NSString stringWithFormat:@"%@:%@",model.Ms,model.FName];
        return mcell;
        
    }
   
    return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    DEUnfinishDetailModel * model = [self.datasource firstObject];
    DEUnfinishSectionView * headView =[[DEUnfinishSectionView alloc]init];
    headView.bounds = CGRectMake(0, 0, kScreenWidth, 45);
    headView.section =section;
    NSString * tipString = self.sectionHeadLineArray[section];
    headView.titleLab.text = self.sectionHeadLineArray[section];
    KWeakSelf
   
    if ([tipString isEqualToString:@"用户操作日志"]) {
        if (model.isopen) {
            headView.titleLab.text =@"用户操作日志(点击隐藏)";
        }else{
            headView.titleLab.text =@"用户操作日志(点击展开)";
        }
        headView.open_closeBlock = ^(UIButton * _Nonnull sender, NSInteger sectionIdx) {

            self->_isSelected = -self->_isSelected;
            if (self->_isSelected ==1) {
                model.isopen = NO;
                
               
            }if (self->_isSelected == -1) {
                model.isopen = YES;
               
            }
           
           
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIdx] withRowAnimation:UITableViewRowAnimationFade];
        };
        
    }else if ([tipString isEqualToString:@"保养信息"]){
        if (model.maintenceStepIsOpen) {
            headView.titleLab.text =@"保养信息(点击隐藏)";
        }else{
            headView.titleLab.text =@"保养信息(点击展开)";
        }
        headView.open_closeBlock = ^(UIButton * _Nonnull sender, NSInteger sectionIdx) {

            self->_isSelected = -self->_isSelected;
            if (self->_isSelected ==1) {
               
                model.maintenceStepIsOpen  =NO;
               
            }if (self->_isSelected == -1) {
              
                model.maintenceStepIsOpen  =YES;
            }
            //[weakSelf.tableView reloadData];
            debugLog(@" -- = %ld",sectionIdx);
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIdx] withRowAnimation:UITableViewRowAnimationFade];
        };
        
    }
    
    if ([tipString isEqualToString:@"用户操作日志"]||[tipString isEqualToString:@"保养信息"]) {
        
    }
    
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * tipString = self.sectionHeadLineArray[indexPath.section];
    ExceptionModel *model;
    NSArray * modelArray;
    if ([tipString isEqualToString:@"点检"]) {
        modelArray =self.exceptionMutableDictionary[@(0)];
        model = modelArray[indexPath.row];
      
        
    }else if ([tipString isEqualToString:@"点检复核"]){
        modelArray = self.exceptionMutableDictionary[@(1)];
        model = modelArray[indexPath.row];
        
        
    }else if ([tipString isEqualToString:@"点检稽核"]){
        modelArray = self.exceptionMutableDictionary[@(2)];
        model = modelArray[indexPath.row];
        
    }else if ([tipString isEqualToString:@"保养复核"]){
        modelArray = self.exceptionMutableDictionary[@(3)];
        model = modelArray[indexPath.row];
        
    }else if ([tipString isEqualToString:@"保养稽核"]){
        modelArray = self.exceptionMutableDictionary[@(4)];
        model = modelArray[indexPath.row];
       
        
    }else if ([tipString isEqualToString:@"未完成问题点"]){
        modelArray =self.exceptionMutableDictionary[@(5)];
        model = modelArray[indexPath.row];
       
    }else if ([tipString isEqualToString:@"待复核问题点"]){
        modelArray = self.exceptionMutableDictionary[@(6)];
        model = modelArray[indexPath.row];
        
    }else if ([tipString isEqualToString:@"移交下月"]){
        modelArray = self.exceptionMutableDictionary[@(7)];
        model = modelArray[indexPath.row];
        
    }else if ([tipString isEqualToString:@"已完成"]){
        modelArray = self.exceptionMutableDictionary[@(8)];
        model = modelArray[indexPath.row];
       
    }else if ([tipString isEqualToString:@"移交待完成"]){
        modelArray = self.exceptionMutableDictionary[@(9)];
        model = modelArray[indexPath.row];
        
    }
    if ([tipString isEqualToString:@"基本信息"]||[tipString isEqualToString:@"维修数据"]||[tipString isEqualToString:@"用户操作日志"]||[tipString isEqualToString:@"单相关联系人"]||[tipString isEqualToString:@"保养信息"]) {
        return;
    }
    DEProblemMessageController * controller =[DEProblemMessageController new];
    controller.problemId =model.MaintenanceProblemId;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark s设备维修 跳转的设置信息
#pragma mark == = = = = = = = = = = ====基本信息

-(void)setupBasicMessage:(DEUnfinishDetailModel*)model{
    [self.basicMessageArray removeAllObjects];
    NSArray * basicArr = @[[self initstring:@"维修单号" content:model.TaskCode],[self initstring:@"开单人员" content:[NSString stringWithFormat:@"%@-%@",model.DepName,model.OperCreateUserName]],[self initstring:@"开单时间" content:model.IssueTime],[self initstring:@"设备名称" content:model.FacilityName],[self initstring:@"设备编号" content:model.FacilityCode],[self initstring:@"设备等级" content:model.Lev],[self initstring:@"设备状态" content:model.FacilityStatus],[self initstring:@"部门工序" content:model.FacilityDpartName],[self initstring:@"所在区域" content:model.DistrictName],[self initstring:@"单状态" content:model.TaskStatusName]];
   
       [self.basicMessageArray addObjectsFromArray:basicArr];
    
   
    //配件明细
    if (model.PartsDetailName.length) {
        NSString * str =[self initstring:@"配件明细" content:model.PartsDetailName];
        [self.basicMessageArray addObject:str];
    }if (model.PartsTypeName.length) {
        NSString * str =[self initstring:@"配件类型" content:model.PartsTypeName];
        [self.basicMessageArray addObject:str];
    }if (model.Remark.length) {
        NSString * str =[self initstring:@"开单备注" content:model.Remark];
        [self.basicMessageArray addObject:str];
    }
}
#pragma mark == = = = =维修信息
-(void)setupRepairMessage:(DEUnfinishDetailModel*)model{
    [self.repairMessageArray removeAllObjects];
    if (model.MaintainFaultName.length) {
        NSString * str1 = [self initstring:@"故障名称" content:model.MaintainFaultName];
        [self.repairMessageArray addObject:str1];
    }if (model.FaultReasonName.length) {
        NSString * str = [self initstring:@"故障原因" content:model.FaultReasonName];
        [self.repairMessageArray addObject:str];
    }if (model.LastChangeTime.length) {
        NSString * str = [self initstring:@"上次更换" content:model.LastChangeTime];
        [self.repairMessageArray addObject:str];
    }if (model.PartsLife.length) {
        NSString * str =[self initstring:@"配件寿命" content:model.PartsLife];
        [self.repairMessageArray addObject:str];
    }if (model.PlanStartTime.length) {
        NSString * str =[self initstring:@"预计恢复" content:model.PlanStartTime];
        [self.repairMessageArray addObject:str];
    }if (model.OccupyCapacity.length) {
        NSString * str =[self initstring:@"是否占厂" content:model.OccupyCapacity];
        [self.repairMessageArray addObject:str];
    }if (model.HumanFlag.length) {
        NSString * str =[self initstring:@"是否人为" content:model.HumanFlag];
        [self.repairMessageArray addObject:str];
    }if (model.LossFlag.length) {
        NSString * str =[self initstring:@"点检漏失" content:model.LossFlag];
        [self.repairMessageArray addObject:str];
    }if (model.IsReplace.length) {
        NSString * str =[self initstring:@"更换配件" content:model.IsReplace];
        [self.repairMessageArray addObject:str];
    }if (model.TreatmentProcess.length) {
        NSString * str =[self initstring:@"处理过程" content:model.TreatmentProcess];
        [self.repairMessageArray addObject:str];
    }
   
}
#pragma mark ==== == = = = = = = =====维修数据
-(void)setupRepairData:(NSMutableArray*)repairArray{
    [self.maintainDataArray removeAllObjects];
    NSString * str1 =nil;
    for (MaintainModel * model in repairArray) {
        if (model.OperCreateUserName.length) {
         [self.maintainDataArray addObject:[self initstring:@"开单时间" content:[NSString stringWithFormat:@"%@(%@)",model.IssueTime,model.OperCreateUserName]]];
        }if (model.AssignUserName.length) {
        [self.maintainDataArray addObject:[self initstring:@"指派时间" content:[NSString stringWithFormat:@"%@(%@)",model.AssignTime,model.AssignUserName]]];
        }if (model.AcceptUserName.length &&model.AcceptTime.length == 0) {
          [self.maintainDataArray addObject:[self initstring:@"接单时间" content:[NSString stringWithFormat:@"%@(%@)",model.AcceptTime?:@"暂未接单",model.AcceptUserName]]];
        }if (model.AcceptUserName.length &&model.AcceptTime.length) {
            if (model.Status.length) {
                NSString * str = [self initstring:@"接单时间" content:[NSString stringWithFormat:@"%@(%@)-%@",model.AcceptTime,model.AcceptUserName,model.Status]];
                [self.maintainDataArray addObject:str];
            }else{
                NSString * str =  [self initstring:@"接单时间" content:[NSString stringWithFormat:@"%@(%@)",model.AcceptTime,model.AcceptUserName]];
                [self.maintainDataArray addObject:str];
            }
        }if (model.OperApplyUserName.length&&model.ApplyFinishTime.length) {
            NSString * str = [self initstring:@"申请验收" content:[NSString stringWithFormat:@"%@(%@)",model.ApplyFinishTime,model.OperApplyUserName]];
            [self.maintainDataArray addObject:str];
        }if(model.QualityConfirmTime.length && model.QualityConfirmUser){
            NSString *str =[self initstring:@"品质确认" content:[NSString stringWithFormat:@"%@(%@)",model.QualityConfirmTime,model.QualityConfirmUser]];
            [self.maintainDataArray addObject:str];
        }
        if (model.OperFinishUserName.length) {
            NSString * str = [self initstring:@"确认验收" content:[NSString stringWithFormat:@"%@(%@)",model.FinishTime,model.OperFinishUserName]];
            [self.maintainDataArray addObject:str];
        }if (model.ReactTime.length) {
            NSString * str =[self initstring:@"反应时间" content:[NSString stringWithFormat:@"%@(%@)",[Units delayTime:model.ReactTime andEndTime:str1],model.AcceptUserName]];
            [self.maintainDataArray addObject:str];
        }
        NSString * maintimeStr  =[NSString stringWithFormat:@"%@",model.Maintime];
        if (maintimeStr.length) {
            //点检页面
            NSString * str2 =nil;
            if (model.MaintainFaultName.length) {
                NSString * checkStr =nil;
                if ([model.MaintainFaultName isEqualToString:@"点检"]) {
                    checkStr = @"点检耗时";
                }else{
                    checkStr = @"保养耗时";
                }
                str2 = [self initstring:checkStr content:[NSString stringWithFormat:@"%@(%@)",model.Maintime,model.AcceptUserName]];
            }else{
                //维修页面
             str2 = [self initstring:@"维修时间" content:[NSString stringWithFormat:@"%@(%@)",[Units delayTime:model.Maintime andEndTime:str1 ],model.AcceptUserName]];
            }
           
            
            [self.maintainDataArray addObject:str2];
        }if (model.ConfirmTime.length) {
            NSString * str =[self initstring:@"验收时差" content:[NSString stringWithFormat:@"%@(%@)",[Units delayTime:model.ConfirmTime andEndTime:str1],model.AcceptUserName]];
            [self.maintainDataArray addObject:str];
        }if (model.PauseTime.length) {
            NSString * str = [self initstring:@"暂停时间" content:[NSString stringWithFormat:@"%@(%@)",[Units delayTime:model.PauseTime andEndTime:str1],model.AcceptUserName]];
            [self.maintainDataArray addObject:str];
        }
        
    }
}

#pragma mark === = = = = =======用户操作日志
-(void)setupUserOperationLog:(NSMutableArray*)logArray{
    [self.recordArray removeAllObjects];
    for (UserOperateModel * model in logArray) {
        [self.recordArray addObject:[self initstring:@"操作内容" content:[NSString stringWithFormat:@"%@%@(%@)",model.SignDpart,model.PassFlag,model.FName]]];
        [self.recordArray addObject:[self initstring:@"操作时间" content:model.SignTime]];
        [self.recordArray addObject:[self initstring:@"操作备注" content:model.SignRemark]];
    }
}
#pragma mark 进度图片
-(void)setupTableHeadVView:(DEUnfinishDetailModel*)model{
    NSString * imageString;
    NSInteger tag = 0;
    if ([model.TaskStatusName isEqualToString:@"待料暂停"]||[model.TaskStatusName isEqualToString:@"待配件暂停"]) {
        imageString = @"暂停中";
        tag =3;
        
    }if ([model.TaskStatusName isEqualToString:@"待接单"]) {
        imageString =@"待接单";
        tag =1;
    }if ([model.TaskStatusName isEqualToString:@"维修中"]) {
        imageString =@"维修中";
        tag =2;
    }if ([model.TaskStatusName isEqualToString:@"待指派"]) {
        imageString =@"待指派";
        tag =0;
    }if ([model.TaskStatusName isEqualToString:@"待验收"]) {
        imageString =@"待验收";
        tag =4;
    }if ([model.TaskStatusName isEqualToString:@"已结单"]) {
        imageString =@"已结单";
        tag =5;
    }
    if (imageString.length == 0) {
        return;
    }
    NSArray * titles =@[@"待指派",@"待接单",@"维修中",@"暂停中",@"待验收",@"已结单"];
    ProgressView * tableHeadView = [[ProgressView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80) titlesArr:titles];
    tableHeadView.index =tag;
    self.tableView.tableHeaderView = tableHeadView;
    
}
//标题
-(NSMutableArray*)sectionHeadLineArray{
    if (!_sectionHeadLineArray) {
        _sectionHeadLineArray =[NSMutableArray array];
        NSArray * titles =nil;
        if ([_controllerType isEqualToString:@"设备维修"]) {
         titles =@[@"基本信息",@"维修信息",@"维修数据",@"用户操作日志",@"单相关联系人"];
        }else{
           // titles =@[@"基本信息",@"维修数据",@"用户操作日志",@"单相关联系人"];
            titles =nil;
        }
    
        [_sectionHeadLineArray addObjectsFromArray:titles];
        
    }return _sectionHeadLineArray;
}


#pragma mark 设备点检保养

//基本信息
-(void)setupCheckBasicMessage:(DEUnfinishDetailModel*)model{
    [self.basicMessageArray removeAllObjects];
    NSArray * basicArray = @[[self initstring:@"维修单号" content:model.TaskCode],[self initstring:@"维修人员" content:[NSString stringWithFormat:@"%@-%@",model.DepName,model.OperCreateUserName]],[self initstring:@"开单时间" content:model.IssueTime],[self initstring:@"单状态" content:model.TaskStatusName],[self initstring:@"设备名称" content:model.FacilityName],[self initstring:@"设备编号" content:model.FacilityCode],[self initstring:@"设备等级" content:model.Lev],[self initstring:@"部门工序" content:model.FacilityDpartName],[self initstring:@"所在区域" content:model.DistrictName]];
    [self.basicMessageArray addObjectsFromArray:basicArray];
    if (model.MaintainFaultName.length) {
        NSString * str = [self initstring:@"故障名称" content:model.MaintainFaultName];
        [self.basicMessageArray addObject:str];
    }
    if (model.PlanStartTime.length) {
        NSString * str = [self initstring:@"预计恢复" content:model.PlanStartTime];
        [self.basicMessageArray addObject:str];
    }if (model.CountGoal.length &&![model.MaintainFaultName isEqualToString:@"点检"]) {
        NSString * str = [self initstring:@"目标单数" content:[NSString stringWithFormat:@"一个保养周期内维修单数目标值:%@",model.CountGoal]];
        [self.basicMessageArray addObject:str];
    }if (model.SumMain.length &&![model.MaintainFaultName isEqualToString:@"点检"]) {
        NSString * str = [self initstring:@"一个保养周期内维修单数实际值" content:model.SumMain];
        [self.basicMessageArray addObject:str];
    }if (model.RecentlyTaskCode.length) {
        NSString * str = [self initstring:@"点检详情" content:[NSString stringWithFormat:@"%@(点击查看)",model.RecentlyTaskCode]];
        [self.basicMessageArray addObject:str];
    }if (model.ByFinishTime.length) {
        NSString * str = [self initstring:@"规定完成" content:[NSString stringWithFormat:@"时间%@",model.ByFinishTime]];
        [self.basicMessageArray addObject:str];
    }if (model.Remark.length) {
        NSString * str = [self initstring:@"开单备注" content:model.Remark];
        [self.basicMessageArray addObject:str];
    }
}
//点检 点检复核  点检稽核 保养复核 保养稽核 未完成问题点 待复核问题点 移交下月 已完成 移交待审核

-(void)setupotherTitles:(NSMutableArray*)exceptionArray{
    if (![self.sectionHeadLineArray containsObject:@"基本信息"]) {
     [self.sectionHeadLineArray addObject:@"基本信息"];
    }
    
    
 
    NSMutableArray * checkArray =[NSMutableArray array];//点检
    NSMutableArray * checkReviewArray =[NSMutableArray array];//复核
    NSMutableArray * checkExamArray =[NSMutableArray array];//稽核
    NSMutableArray * maintinReviewArray =[NSMutableArray array];//保养复核
    NSMutableArray * maintainExamArray =[NSMutableArray array];//保养稽核
    NSMutableArray * unfinishArray =[NSMutableArray array];//未完成问题
    NSMutableArray * unfinishProblemArray =[NSMutableArray array];//待复核问题点
    NSMutableArray * transferArray = [NSMutableArray array];//移交下月
    NSMutableArray * finishArray =[NSMutableArray array];//已完成
    NSMutableArray * transferCheckArray =[NSMutableArray array];//移交待审核
    for (ExceptionModel *model in exceptionArray) {
        if (![self.sectionHeadLineArray containsObject:model.Flag]) {
          [self.sectionHeadLineArray addObject:model.Flag];
        }
        if ([model.Flag isEqualToString:@"点检"]) {
            if (![checkArray containsObject:model]) {
                [checkArray addObject:model];
            }
            [self.exceptionMutableDictionary setObject:checkArray forKey:@(0)];
        }else if ([model.Flag isEqualToString:@"点检复核"]){
            [checkReviewArray addObject:model];
            [self.exceptionMutableDictionary setObject:checkReviewArray forKey:@(1)];
        }else if ([model.Flag isEqualToString:@"点检稽核"]){
            [checkExamArray addObject:model];
            [self.exceptionMutableDictionary setObject:checkExamArray forKey:@(2)];
        }else if ([model.Flag isEqualToString:@"保养复核"]){
            [maintinReviewArray addObject:model];
            [self.exceptionMutableDictionary setObject:maintinReviewArray forKey:@(3)];
        }else if ([model.Flag isEqualToString:@"保养稽核"]){
            [maintainExamArray addObject:model];
            [self.exceptionMutableDictionary setObject:maintainExamArray forKey:@(4)];
        }else if ([model.Flag isEqualToString:@"未完成问题点"]){
            [unfinishArray addObject:model];
            [self.exceptionMutableDictionary setObject:unfinishArray forKey:@(5)];
        }else if ([model.Flag isEqualToString:@"待复核问题点"]){
            [unfinishProblemArray addObject:model];
            [self.exceptionMutableDictionary setObject:unfinishProblemArray forKey:@(6)];
        }else if ([model.Flag isEqualToString:@"移交下月"]){
            [transferArray addObject:model];
            [self.exceptionMutableDictionary setObject:transferArray forKey:@(7)];
        }else if ([model.Flag isEqualToString:@"已完成"]){
            [finishArray addObject:model];
            [self.exceptionMutableDictionary setObject:finishArray forKey:@(8)];
        }else if ([model.Flag isEqualToString:@"移交待审核"]){
            [transferCheckArray addObject:model];
            [self.exceptionMutableDictionary setObject:transferCheckArray forKey:@(9)];
        }
    }
   
    NSArray * arr  =@[@"维修数据",@"保养信息",@"用户操作日志",@"单相关联系人"];
    for (NSString * string in arr) {
        if (![self.sectionHeadLineArray containsObject:string]) {
          [self.sectionHeadLineArray addObject:string];
        }
    }
    
}

#pragma mark 设置操作按钮 UIBarButtonItem
-(void)operationBar:(UIButton*)barItem{
    NSArray *btnTitleArray = @[@"指派",@"接单",@"移除指派",@"暂停维修",@"退单",@"修改故障",@"申请验收",@"增援指派",@"解除暂停",@"确认验收",@"驳回返修",@"有误修改",@"确认无误"];
    
    NSArray * checkeArray = @[@"指派",@"接单",@"接单复核",@"接单稽核",@"移除指派",@"暂停点检",@"解除暂停",@"申请完成",@"保养完成",@"增援指派",@"暂停保养",@"保养复核",@"复核问题点",@"转移审核",@"驳回转移",@"点检完成",@"保养申请复核",@"重新保养",@"稽核通过",@"开始处理问题",@"处理问题点",@"填写完成时间",@"外包保养结单",@"替换工程师",@"确认无误"];
    DEUnfinishDetailModel * model = [self.datasource firstObject];
    if (!_operationArray) {
        _operationArray =[NSMutableArray array];
    }
    [_operationArray removeAllObjects];
    for (NSDictionary * dict in model.OperateArray) {
        NSInteger  flag = [dict[@"PassFlag"]integerValue];
        NSString * string =nil;
        if ([_controllerType isEqualToString:@"设备维修"]) {
          string = [btnTitleArray objectAtIndex:flag];
        }else{
            string  = [checkeArray objectAtIndex:flag];
        }
       
        [_operationArray addObject:string];
        
    }
    //下拉选择框
    [YBPopupMenu showRelyOnView:barItem titles:_operationArray icons:nil menuWidth:140 otherSettings:^(YBPopupMenu *popupMenu) {
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

#pragma mark popMenuDelegate
-(void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    [ybPopupMenu dismiss];
    NSString * tipString = self.operationArray[index];
    NSMutableDictionary * parms =[NSMutableDictionary dictionary];
    DEUnfinishDetailModel * model = [self.datasource firstObject];
   
    if ([_controllerType isEqualToString:@"设备维修"]) {
        if ([tipString isEqualToString:@"指派"]) {
            [parms setObject:@"3" forKey:@"Type"];
            [parms setObject:model.MaintainDistrictId forKey:@"MaintainDistrictId"];
            [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
            [self getAppointMessage:parms tipString:@"指派" typeCheckString:@"维修"];
        }else if ([tipString isEqualToString:@"增援指派"]){
            
            [parms setObject:@"4" forKey:@"Type"];
            [parms setObject:model.MaintainDistrictId forKey:@"MaintainDistrictId"];
            [parms setObject:model.MaintainTaskId forKey:@"MaintainTaskId"];
            [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
            [self getAppointMessage:parms tipString:@"增援指派" typeCheckString:@"维修"];
        }else if ([tipString isEqualToString:@"移除指派"]){
            [parms setObject:@"5" forKey:@"Type"];
            [parms setObject:model.MaintainTaskId forKey:@"MaintainTaskId"];
            [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
            [self getAppointMessage:parms tipString:@"移除指派" typeCheckString:@"维修"];
        }else if ([tipString isEqualToString:@"暂停维修"]||[tipString isEqualToString:@"退单"]){
            DEPauseRepairController * controller =[DEPauseRepairController new];
            controller.maintainId = model.MaintainTaskId;
            controller.comeFromController = tipString;
           
            [self.navigationController pushViewController:controller animated:YES];
            KWeakSelf
            controller.passSecetedMutableParmsBlock = ^(NSMutableDictionary * _Nonnull mutableParms) {
                NSMutableDictionary * parms = [NSMutableDictionary dictionary];
                if ([tipString isEqualToString:@"暂停维修"]) {
                    [parms setObject:@"0" forKey:@"Type"];
                }else{
                    [parms setObject:@"1" forKey:@"Type"];
                }
                [parms setObject:[mutableParms objectForKey:@"Remark"] forKey:@"OperateDescribe"];
                [parms setObject:model.MaintainTaskId forKey:@"MaintainTaskId"];
                [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
                [parms setObject:[mutableParms objectForKey:@"engineer"] forKey:@"EngineerArray"];
                NSString *finishtime = [mutableParms objectForKey:@"预计恢复时间"];
                if (finishtime.length) {
                 [parms setObject:finishtime forKey:@"PlanStartTime"];
                }
                [weakSelf pauseMaintainWithParms:parms url:[MaintainPauseUrl getWholeUrl]];
            };
            
            return;
        }else if ([tipString isEqualToString:@"确认验收"]||[tipString isEqualToString:@"驳回返修"]){
            [self sureVertifyAndReMaintainByTip:tipString model:model];
        }else if ([tipString isEqualToString:@"接单"]||[tipString isEqualToString:@"修改故障"]){
            [self maintainAcceptanceByTip:tipString model:model];
        }else if ([tipString isEqualToString:@"解除暂停"]){
            [self maintainCalloffPauseBymodel:model];
        }else if ([tipString isEqualToString:@"申请验收"]){
            [self applyAcceptanceWithModel:model];
        }else if ([tipString isEqualToString:@"有误修改"]){
            ReviseErrorController * controller = [[ReviseErrorController alloc]init];
            controller.model =model;
            [self.navigationController pushViewController:controller animated:YES];
        
        }else if ([tipString isEqualToString:@"确认无误"]){
            [self deviceMaintainConfirmNoErrorWithModel:model];
        }
    }else{
        //设备点检
        if ([tipString isEqualToString:@"指派"]) {
            [parms setObject:@"3" forKey:@"Type"];
            [parms setObject:model.MaintainDistrictId forKey:@"MaintainDistrictId"];
            [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
            [self getAppointMessage:parms tipString:@"指派" typeCheckString:@"点检"];
        }else if ([tipString isEqualToString:@"增援指派"]){
            [parms setObject:@"8" forKey:@"Type"];
            [parms setObject:model.MaintainDistrictId forKey:@"MaintainDistrictId"];
            [parms setObject:model.MaintainDjbyId forKey:@"MaintainTaskId"];
            [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
            [self getAppointMessage:parms tipString:@"增援指派"typeCheckString:@"点检"];
        }else if ([tipString isEqualToString:@"移除指派"]){
            [parms setObject:@"9" forKey:@"Type"];
            [parms setObject:model.MaintainDjbyId forKey:@"MaintainTaskId"];
            [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
            [self getAppointMessage:parms tipString:@"移除指派" typeCheckString:@"点检"];
        }else if ([tipString isEqualToString:@"暂停点检"]||[tipString isEqualToString:@"暂停保养"]){
            DEPauseRepairController * controller =[DEPauseRepairController new];
            controller.maintainType =@"点检";
            controller.maintainId =model.MaintainDjbyId;
            
            controller.comeFromController =tipString;
            [self.navigationController pushViewController:controller animated:YES];
            KWeakSelf
            controller.passSecetedMutableParmsBlock = ^(NSMutableDictionary * _Nonnull mutableParms) {
                
                NSMutableDictionary * parms = [NSMutableDictionary dictionary];
                [parms setObject:model.MaintainDjbyId forKey:@"MaintainDjbyId"];
                [parms setObject:@"0" forKey:@"Type"];
                [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
                [parms setObject:[mutableParms objectForKey:@"engineer"] forKey:@"EngineerArray"];
                [parms setObject:[mutableParms objectForKey:@"Remark"] forKey:@"OperateDescribe"];
                NSString * finishTime = [mutableParms objectForKey:@"预计恢复时间"];
                if (finishTime.length) {
                    [parms setObject:finishTime forKey:@"PlanStartTime"];
                }
                
               
                [weakSelf pauseMaintainWithParms:parms url:[CheckPauseMaintainUrl getWholeUrl]];
            };
            return;
        }else if ([tipString isEqualToString:@"接单"]||[tipString isEqualToString:@"接单复核"]||[tipString isEqualToString:@"接单稽核"]){
            [self acceptanceTaskByTip:tipString model:model];
        }else if ([tipString isEqualToString:@"解除暂停"]||[tipString isEqualToString:@"开始处理问题"]){
            [self callOffPauseOrResloveProblemByModel:model tip:tipString];
        }else if ([tipString isEqualToString:@"复核问题点"]||[tipString isEqualToString:@"重新保养"]||[tipString isEqualToString:@"稽核通过"]){
            [self checkProblem:model tipString:@"复核问题点"];
        }else if ([tipString isEqualToString:@"替换工程师"]){
            [self changeEngineerByModel:model];
        }else if ([tipString isEqualToString:@"填写完成时间"]||[tipString isEqualToString:@"外包保养结单"]){
            [self finishTimeandOrdersFinishByModel:model tip:tipString];
        }else if ([tipString isEqualToString:@"申请完成"]||[tipString isEqualToString:@"保养申请复核"]||[tipString isEqualToString:@"处理问题点"]){
            [self checkApplyFinishAndApplyrecheckAndSloveProblemWithTip:tipString model:model];
        }else if ([tipString isEqualToString:@"点检完成"]||[tipString isEqualToString:@"保养完成"] ||[tipString isEqualToString:@"确认无误"]){
            [self checkAndMaintainFinishByTip:tipString model:model];
        }
    }
   
    
    
    
}


#pragma mark---维修 申请验收
-(void)applyAcceptanceWithModel:(DEUnfinishDetailModel*)model{
    ApplayAcceptanceController * controller = [ApplayAcceptanceController new];
    controller.facilityId = model.FacilityId;
    controller.taskId =model.MaintainTaskId;
    
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark --维修 解除暂停

-(void)maintainCalloffPauseBymodel:(DEUnfinishDetailModel*)model{
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:@"解除暂停" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入操作备注(选填)";
    }];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField * textfield = controller.textFields.firstObject;
        NSMutableDictionary * parms = [NSMutableDictionary dictionary];
        [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
        [parms setObject:model.MaintainTaskId forKey:@"MaintainTaskId"];
        [parms setObject:textfield.text?:@"" forKey:@"OperateDescribe"];
        [Units showLoadStatusWithString:Loading];
        KWeakSelf
        [HttpTool POST:[MaintainCalloffPauseURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
            [Units hideView];
            [Units showStatusWithStutas:responseObject[@"info"]];
            if ([responseObject[@"status"]integerValue]==0) {
                [weakSelf.tableView.mj_header beginRefreshing];
            }
        } error:^(NSString * _Nonnull error) {
            [Units hideView];
            [Units showErrorStatusWithString:error];
        }];
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:controller animated:YES completion:nil];
    
}
#pragma mark ---接单 修改故障 维修 维修

-(void)maintainAcceptanceByTip:(NSString*)tip model:(DEUnfinishDetailModel*)model{
 
        //请求网络
        NSMutableDictionary * parms = [NSMutableDictionary dictionary];
        [parms setObject:model.FacilityId forKey:@"FacilityId"];
       KWeakSelf
        [HttpTool POST:[CheckDeviceTypeURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"status"]integerValue]==0) {
                NSArray * resopse = [Units jsonToArray:responseObject[@"data"]];
                
                [AlertView showAlertWithDatasource:resopse maintainId:^(NSString * _Nonnull maintainId, NSString * _Nonnull maintainName) {
                    [weakSelf maintainAcceptAlertViewByTip:tip model:model maintainId:maintainId maintianName:maintainName];
                }];
            }
        } error:^(NSString * _Nonnull error) {
            
        }];
        
    
}

//接单弹出框
-(void)maintainAcceptAlertViewByTip:(NSString*)tip model:(DEUnfinishDetailModel*)model maintainId:(NSString*)maintainId maintianName:(NSString*)maintainName{
      KWeakSelf
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:maintainName?:tip message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        if ([tip isEqualToString:@"接单"]) {
            textField.placeholder = @"备注(选填)";
        }else{
            textField.placeholder = @"备注(必填)";
        }
    }];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField * textfield = controller.textFields.firstObject;
        
        if ([tip isEqualToString:@"修改故障"]) {
            if (textfield.text.length ==0) {
                [Units showErrorStatusWithString:@"必填项不能为空"];
                [weakSelf presentViewController:controller animated:YES completion:nil];
                return ;
            }
        }
        NSMutableDictionary * parms = [NSMutableDictionary dictionary];
        [parms setObject:[tip isEqualToString:@"接单"]?@"0":@"1" forKey:@"Type"];
        [parms setObject:model.MaintainTaskId forKey:@"MaintainTaskId"];
        [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
        [parms setObject:maintainId forKey:@"MaintainFaultId"];
        [parms setObject:textfield.text?:@"" forKey:@"OperateDescribe"];
        [Units showLoadStatusWithString:Loading];
      
        [HttpTool POST:[MaintainAcceptnceTaskURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
            [Units hideView];
            [Units showStatusWithStutas:responseObject[@"info"]];
            if ([[responseObject objectForKey:@"status"]integerValue]==0) {
                [weakSelf.tableView.mj_header beginRefreshing];
            }
        } error:^(NSString * _Nonnull error) {
            [Units hideView];
            [Units showErrorStatusWithString:error];
        }];
        
        
        
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark --- 维修 确认无误
-(void)deviceMaintainConfirmNoErrorWithModel:(DEUnfinishDetailModel*)model{
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:@"确认无误" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入操作备注(选填)";
    }];
    [controller addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField * textfield = controller.textFields.firstObject;
        NSMutableDictionary * parms = [NSMutableDictionary dictionary];
        [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
        [parms setObject:[self->_controllerType isEqualToString:@"维修保修"]?@"0":@"2" forKey:@"Type"];
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:model.MaintainTaskId forKey:@"MaintainTaskId"];
        [parms setObject:[Units dictionaryToJson:dict] forKey:@"Model"];
        if (textfield.text.length == 0) {
            [parms setObject:textfield.text forKey:@"OperateDescribe"];
        }
        [Units showLoadStatusWithString:Loading];
        KWeakSelf
        [HttpTool POST:[DeviceReviseErrorUrl getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
            [Units hideView];
            [Units showStatusWithStutas:responseObject[@"info"]];
            if ([[responseObject objectForKey:@"status"]integerValue]== 0) {
                [weakSelf.tableView.mj_header beginRefreshing];
            }
        } error:^(NSString * _Nonnull error) {
            [Units hideView];
            [Units showErrorStatusWithString:error];
        }];
        
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:controller animated:YES completion:nil];
    
}
#pragma mark --- 暂停维修 暂停保养
-(void)pauseMaintainWithParms:(NSMutableDictionary*)parms url:(NSString*)url{
    KWeakSelf
    [Units showLoadStatusWithString:Loading];
    [HttpTool POST:url param:parms success:^(id  _Nonnull responseObject) {
        [Units hideView];
        [Units showStatusWithStutas:responseObject[@"info"]];
        if ([[responseObject objectForKey:@"status"]integerValue]==0) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }
      
    } error:^(NSString * _Nonnull error) {
        [Units hideView];
        [Units showErrorStatusWithString:error];
    }];
}
#pragma mark -- 解除暂停 开始处理问题
//解除暂停 开始处理问题
-(void)callOffPauseOrResloveProblemByModel:(DEUnfinishDetailModel*)model tip:(NSString*)tip{
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setObject:[tip isEqualToString:@"解除暂停"]?@"1":@"2" forKey:@"Type"];
    [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    [parms setObject:model.MaintainDjbyId forKey:@"MaintainDjbyId"];
    
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:tip message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"备注(选填)";
    }];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField * textfield = controller.textFields.firstObject;
        [parms setObject:textfield.text?:@"" forKey:@"OperateDescribe"];
        //请求网络
        [Units showLoadStatusWithString:Loading];
        KWeakSelf
        [HttpTool POST:[CallOffPauseorSloveProblemURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
            [Units hideView];
            if ([responseObject[@"status"]integerValue]==0) {
                [weakSelf.tableView.mj_header beginRefreshing];
                
            }
            [Units showStatusWithStutas:responseObject[@"info"]];
        } error:^(NSString * _Nonnull error) {
            [Units hideView];
            [Units showStatusWithStutas:error];
        }];
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark ---接单 接单复核 接单稽核 点检
-(void)acceptanceTaskByTip:(NSString*)tip model:(DEUnfinishDetailModel*)model {
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    if ([tip isEqualToString:@"接单"]) {
        [parms setObject:@"0" forKey:@"Type"];
    }else if ([tip isEqualToString:@"接单复核"]){
        [parms setObject:@"1" forKey:@"Type"];
    }else{
        [parms setObject:@"2" forKey:@"Type"];
    }
    
    KWeakSelf
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:tip message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder =@"备注(选填)";
    }];
    [controller addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField * textfield = controller.textFields.firstObject;
        [parms setObject:model.MaintainDjbyId forKey:@"MaintainDjbyId"];
        [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
        [parms setObject:textfield.text?:@"" forKey:@"OperateDescribe"];
        //请求网络
        debugLog(@" - -- - -%@",parms);
        [Units showLoadStatusWithString:Loading];
        [HttpTool POST:[AcceptanceURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
            [Units hideView];
            [Units showStatusWithStutas:responseObject[@"info"]];
            [weakSelf.tableView.mj_header beginRefreshing];
            
            
        } error:^(NSString * _Nonnull error) {
            [Units hideView];
            [Units showStatusWithStutas:error];
        }];
        
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark --点检。替换工程师
//点检 替换工程师
-(void)changeEngineerByModel:(DEUnfinishDetailModel*)model{
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    [parms setObject:@"3" forKey:@"Type"];
    [parms setObject:model.MaintainDistrictId forKey:@"MaintainDistrictId"];
    [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    KWeakSelf
    [HttpTool POST:[DeviceEngineerURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"status"]integerValue]== 0) {
            NSArray * responses = [Units jsonToArray:responseObject[@"data"]];
            NSMutableArray * objs = [DetailMemberModel mj_objectArrayWithKeyValuesArray:responses];
            
            for (DetailMemberModel *mModel in objs) {
                mModel.selectedType = @"单选";
            }

            [AppointAlertView showAlertWithDatasource:objs itemCallbackBlock:^(DetailMemberModel * _Nullable memberModel, NSMutableArray * _Nullable sources) {
                //请求网络
                NSMutableDictionary * mutableParms = [NSMutableDictionary dictionary];
                [mutableParms setObject:USERDEFAULT_object(USERID) forKey:@"UserId" ];
                [mutableParms setObject:model.MaintainDjbyId forKey:@"MaintainDjbyId"];
                [mutableParms setObject:memberModel.UserId forKey:@"ReplaceUserId"];
                [mutableParms setObject:@"0" forKey:@"Type"];
                [Units showLoadStatusWithString:Loading];
                [HttpTool POST:[ChansgeEngineerURL getWholeUrl] param:mutableParms success:^(id  _Nonnull responseObject) {
                    [Units hideView];
                    [Units showStatusWithStutas:responseObject[@"info"]];
                    if ([[responseObject objectForKey:@"status"]integerValue]== 0) {
                        [weakSelf.tableView.mj_header beginRefreshing];
                        if (weakSelf.sucessInternetBlock) {
                            weakSelf.sucessInternetBlock();
                        }
                    }
                    
                } error:^(NSString * _Nonnull error) {
                    [Units hideView];
                    [Units showErrorStatusWithString:error];
                }];
            } dismissBlock:^{
                [weakSelf.view endEditing:YES];
            }];
        }
       
    } error:^(NSString * _Nonnull error) {
        
    }];
}

#pragma mark---点检 申请完成 保养申请复核 处理问题点

-(void)checkApplyFinishAndApplyrecheckAndSloveProblemWithTip:(NSString*)tip model:(DEUnfinishDetailModel*)model{
    if ([tip isEqualToString:@"保养申请复核"]) {
        UIAlertController * controller = [UIAlertController alertControllerWithTitle:tip message:@"" preferredStyle:UIAlertControllerStyleAlert];
        KWeakSelf
        [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入操作备注(必填)";
        }];
        [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField * textfield = controller.textFields.firstObject;
            if (textfield.text.length == 0) {
                [Units showErrorStatusWithString:@"操作备注不能为空"];
                [weakSelf presentViewController:controller animated:YES completion:nil];
                return ;
            }
            NSMutableDictionary * parms = [NSMutableDictionary dictionary];
            [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
            [parms setObject:model.MaintainDjbyId forKey:@"MaintainDjbyId"];
            [parms setObject:textfield.text forKey:@"OperateDescribe"];
            [parms setObject:@"1" forKey:@"Type"];
            [weakSelf loadNetworkWithParms:parms];
        }]];
        [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        KWeakSelf
        NSMutableDictionary * parms = [NSMutableDictionary dictionary];
        [parms setObject:@"1" forKey:@"Type"];
        [parms setObject:model.MaintainDjbyId forKey:@"MaintainDjbyId"];
        [HttpTool POST:[CheckProblemUrl getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"status"]integerValue]==0) {
                NSArray * responses = [responseObject objectForKey:@"data"];
                //转为model
                NSMutableArray * models = [DetailMemberModel mj_objectArrayWithKeyValuesArray:responses];
                for (DetailMemberModel *detaiModel in models) {
                    detaiModel.selectedType =@"多选";
                }
                [ApplyFinishAlertView showAlertWithSource:models maintainBlock:^(DetailMemberModel * _Nullable mModel, NSMutableArray * _Nullable sources) {
                    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
                    NSMutableArray * mutableArray = [NSMutableArray array];
                    for (DetailMemberModel *selectdModel in sources) {
                        NSMutableDictionary * mutableDictionary = [NSMutableDictionary dictionary];
                        [mutableDictionary setObject:selectdModel.MaintenanceProblemId forKey:@"MaintenanceProblemId"];
                        [mutableArray addObject:mutableDictionary];
                    }
                    //转为jison
                    NSString * json = [Units arrayToJson:mutableArray];
                    [parms setObject:json forKey:@"ProblemArray"];
                    [parms setObject:[tip isEqualToString:@"申请完成"]?@"0":@"2" forKey:@"Type"];
                    [parms setObject:model.MaintainDjbyId forKey:@"MaintainDjbyId"];
                    [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
                    [weakSelf loadNetworkWithParms:parms];
                }];
            }
        } error:^(NSString * _Nonnull error) {
            
        }];
    }
}

//申请完成 保养申请复核 处理问题点
-(void)loadNetworkWithParms:(NSMutableDictionary*)parms{
    [Units showLoadStatusWithString:Loading];
    KWeakSelf
    [HttpTool POST:[ApplayFinishUrl getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hideView];
        [Units showStatusWithStutas:responseObject[@"info"]];
        if ([[responseObject objectForKey:@"status"]integerValue] == 0) {
            [weakSelf.tableView.mj_header beginRefreshing];
            if (weakSelf.sucessInternetBlock) {
                weakSelf.sucessInternetBlock();
            }
        }
    } error:^(NSString * _Nonnull error) {
        [Units hideView];
        [Units showErrorStatusWithString:error];
    }];
}
#pragma mark --点检 点检完成 保养完成
//点检完成 保养完成
-(void)checkAndMaintainFinishByTip:(NSString*)tip model:(DEUnfinishDetailModel*)model{
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:tip message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入操作备注(必填)";
    }];
    KWeakSelf
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.view endEditing:YES];
        UITextField * textfield = controller.textFields.firstObject;
        if (textfield.text.length ==0) {
            [Units showErrorStatusWithString:@"操作备注必填"];
            return ;
        }
        
        NSMutableDictionary * parms = [NSMutableDictionary dictionary];
        [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
        [parms setObject:model.MaintainDjbyId forKey:@"MaintainDjbyId"];
        NSString *typeStr;
        if ([tip isEqualToString:@"点检完成"]) {
            typeStr  =@"1";
        }else{
            typeStr  =@"2";
        }
        [parms setObject:typeStr forKey:@"Type"];
        [parms setObject:textfield.text forKey:@"OperateDescribe"];
        [Units showLoadStatusWithString:Loading];
        
        [HttpTool POST:[CheckAndMaintainFinishURL getWholeUrl] param:parms success:^(NSDictionary*  _Nonnull responseObject) {
  //          [Units hideView];
            [Units showStatusWithStutas:responseObject[@"info"]];
            NSString *statusStr  = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];

            if ([statusStr containsString:@"0"]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (weakSelf.sucessInternetBlock) {
                        weakSelf.sucessInternetBlock();
                    }
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });

//
////                [weakSelf.tableView.mj_header beginRefreshing];
////                if (weakSelf.sucessInternetBlock) {
////                    weakSelf.sucessInternetBlock();
////                }
            }
            debugLog(@" == = %@",responseObject);
        } error:^(NSString * _Nonnull error) {
            
            [Units showErrorStatusWithString:error];
        }];
        
        
        
        
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self.navigationController presentViewController:controller animated:YES completion:nil];
    
}
#pragma mark --填写完成时间 外包保养i结单
//填写完成时间 外包保养结单
-(void)finishTimeandOrdersFinishByModel:(DEUnfinishDetailModel*)model tip:(NSString*)tip{
    ExpectFinishTimeController * controller = [ExpectFinishTimeController new];
    controller.detailModel = model;
    NSString * objTitle = [tip isEqualToString:@"填写完成时间"]?@"保养要求完成时间":@"供应商保养完成时间";
    controller.title = objTitle;
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark alertView
//指派 加载数据
-(void)getAppointMessage:(NSMutableDictionary*)parms tipString:(NSString*)tipString typeCheckString:(NSString*)typeCheck{
    if (!_selectedItemArray) {
        _selectedItemArray =[NSMutableArray array];
    }
    [_selectedItemArray removeAllObjects];
    [Units showLoadStatusWithString:Loading];
    KWeakSelf
    [HttpTool POST:[DeviceEngineerURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hideView];
        if ([[responseObject objectForKey:@"status"]integerValue]==0) {
            NSArray * arr =[Units jsonToArray:responseObject[@"data"]];
            NSMutableArray * arr1 =[DetailMemberModel mj_objectArrayWithKeyValuesArray:arr];
            //传值 是否是单多选 保存到model
            for (DetailMemberModel *model in arr1) {
                if ([tipString isEqualToString:@"指派"]||[tipString isEqualToString:@"移除指派"]) {
                    model.selectedType = @"单选";
                }else if ([tipString isEqualToString:@"增援指派"]){
                    model.selectedType = @"多选";
                }
            }

            [AppointAlertView showAlertWithDatasource:arr1 itemCallbackBlock:^(DetailMemberModel * _Nullable model, NSMutableArray * _Nullable selectedArray) {
                //回调得到人员id
                if ([model.selectedType isEqualToString:@"单选"]) {
                    [weakSelf.selectedItemArray addObject:model.UserId];
                    
                }else{
                    //多选
                    for (DetailMemberModel *model in selectedArray) {
                        if (![weakSelf.selectedItemArray containsObject:model.UserId]) {
                            [weakSelf.selectedItemArray addObject:model.UserId];
                        }
                    }
                }
                NSMutableArray * selectePepleArray =[NSMutableArray array];
                //提示框
                for (int i =0; i<weakSelf.selectedItemArray.count; i++) {
                  
                    NSMutableDictionary * parmsDictionary = [NSMutableDictionary dictionary];
                    [parmsDictionary setObject:weakSelf.selectedItemArray[i] forKey:@"UserId"];
                    [selectePepleArray addObject:parmsDictionary];
                    
                    
                }
                NSString * jsonString = [Units arrayToJson:selectePepleArray];
                [weakSelf alertView:tipString selectedMemberId:jsonString typeCheck:typeCheck];
            } dismissBlock:^{
                [weakSelf.view endEditing:YES];
            }];
        }else{
            [Units showErrorStatusWithString:responseObject[@"info"]];
        }
    } error:^(NSString * _Nonnull error) {
        [Units hideView];
        [Units showErrorStatusWithString:error];
    }];
}
-(void)alertView:(NSString*)tipString selectedMemberId:(NSString*)memberId typeCheck:(NSString*)typeCheck{
    DEUnfinishDetailModel * model = [self.datasource firstObject];
    NSString * necessaryString =nil;
    if ([tipString isEqualToString:@"移除指派"]) {
        necessaryString = @"必填";
    }else{
        necessaryString = @"选填";
    }
    UIAlertController * controller =[UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@操作备注(%@)",tipString,necessaryString] message:nil preferredStyle:UIAlertControllerStyleAlert];
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    UIAlertAction * sureAction =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //请求网络
        NSMutableDictionary * parms = [NSMutableDictionary dictionary];
        NSString * inputText =nil;
        for (UITextField * textF in controller.textFields) {
            inputText = textF.text;
        }
        if ([tipString isEqualToString:@"指派"]) {
            [parms setObject:@"0" forKey:@"Type"];
            
        }else if ([tipString isEqualToString:@"增援指派"]){
            [parms setObject:@"1" forKey:@"Type"];
        }else if ([tipString isEqualToString:@"移除指派"]){
            if (inputText.length ==0) {
                [Units showErrorStatusWithString:@"备注不能为空"];
                return ;
            }
            [parms setObject:inputText forKey:@"OperateDescribe"];
            [parms setObject:@"2" forKey:@"Type"];
        }
        [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
        [parms setObject:memberId forKey:@"EngineerArray"];
        if ([typeCheck isEqualToString:@"维修"]) {
            //维修。指派 增援指派 移除指派
         [parms setObject:model.MaintainTaskId forKey:@"MaintainTaskId"];
         [self postRequest:parms urlString:DeviceAppointURL];
        }else{
            //点检 指派 增援指派 移除指派
            [parms setObject:model.MaintainDjbyId forKey:@"MaintainDjbyId"];
            [self postRequest:parms urlString:CheckAppointWorkURL];
        }
    
    }];
    UIAlertAction * cancelAction =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:sureAction];
    [controller addAction:cancelAction];
    [self.navigationController presentViewController:controller animated:YES completion:nil];
    
}
#pragma mark  z网络请求  指派 增援指派 移除指派

-(void)postRequest:(NSMutableDictionary*)parms urlString:(NSString*)urlString{
   
    [Units showLoadStatusWithString:Loading];
    KWeakSelf
   
    [HttpTool POST:[urlString getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hideView];
        [Units showStatusWithStutas:responseObject[@"info"]];
        if ([[responseObject objectForKey:@"status"]integerValue]==0) {
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                           [weakSelf.navigationController popViewControllerAnimated:YES];
                       });
        }
        debugLog(@"- - -%@",responseObject);
    } error:^(NSString * _Nonnull error) {
        [Units hideView];
        [Units showErrorStatusWithString:error];
        debugLog(@"-- - -%@",error);
    }];
}


//复核问题点
-(void)checkProblem:(DEUnfinishDetailModel*)model tipString:(NSString*)tipString{
    if ([tipString isEqualToString:@"复核问题点"]) {
        DECheckProblemController * controller = [DECheckProblemController new];
        controller.maintainTaskId = model.MaintainDjbyId;
        [self.navigationController pushViewController:controller animated:YES];
    }
}
#pragma mark ==确认验收 驳回返修
//确认验收和驳回返修
-(void)sureVertifyAndReMaintainByTip:(NSString*)tip model:(DEUnfinishDetailModel*)model{
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:tip message:@"" preferredStyle:UIAlertControllerStyleAlert];
    KWeakSelf
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = [NSString stringWithFormat:@"备注(%@)",[tip isEqualToString:@"确认验收"]?@"选填":@"必填"];
    }];
    [controller addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //获取textfield
        UITextField * textfield = controller.textFields.firstObject;
        if ([tip isEqualToString:@"驳回返修"]) {
            if (textfield.text.length ==0) {
                [Units showErrorStatusWithString:@"必填项不能为空"];
                [weakSelf presentViewController:controller
                                       animated:YES completion:nil];
                return ;
            }
        }
        //请求网络
        NSString * type = [tip isEqualToString:@"确认验收"]?@"0":@"1";
        NSMutableDictionary * parms = [NSMutableDictionary dictionary];
        [parms setObject:model.MaintainTaskId forKey:@"MaintainTaskId"];
        [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
        [parms setObject:type forKey:@"Type"];
        [parms setObject:textfield.text?:@"" forKey:@"OperateDescribe"];
        [Units showLoadStatusWithString:Loading];
        [HttpTool  POST:[DeviceMaintainSureAcceptanceURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
            [Units hideView];
            [Units showStatusWithStutas:responseObject[@"info"]];
            if ([[responseObject objectForKey:@"status"]integerValue]==0) {
                [weakSelf.tableView.mj_header beginRefreshing];
                if (weakSelf.sucessInternetBlock) {
                    weakSelf.sucessInternetBlock();
                }
            }
        } error:^(NSString * _Nonnull error) {
            [Units showErrorStatusWithString:error];
            [Units hideView];
        }];
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];

    [self presentViewController:controller animated:YES completion:nil];
}
//点检维修数据
-(void)setupMaintainMessage:(NSMutableArray*)maintainArray{
    for (DEUnfinishDetailModel *model in maintainArray) {
        if (model.OperCreateUserName) {
            
        }
    }
}


//基本信息
-(NSMutableArray*)basicMessageArray{
    if (!_basicMessageArray) {
        _basicMessageArray =[NSMutableArray array];
    }return _basicMessageArray;
}
//维修信息
-(NSMutableArray*)repairMessageArray{
    if (!_repairMessageArray) {
        _repairMessageArray = [NSMutableArray array];
    }return _repairMessageArray;
}
//维修数据
-(NSMutableArray*)maintainDataArray{
    if (!_maintainDataArray) {
        _maintainDataArray =[NSMutableArray array];
    }return _maintainDataArray;
}
//操作日志
-(NSMutableArray*)recordArray{
    if (!_recordArray) {
        _recordArray =[NSMutableArray array];
    }return _recordArray;
}
-(NSMutableArray*)linkArray{
    if (!_linkArray) {
        _linkArray =[NSMutableArray array];
    }
    return _linkArray;
}

-(NSMutableArray*)maintenceStepList{
    if (!_maintenceStepList) {
        _maintenceStepList  =[NSMutableArray array];
    }
    return _maintenceStepList;
}
-(NSMutableDictionary*)exceptionMutableDictionary{
    if (!_exceptionMutableDictionary) {
        _exceptionMutableDictionary =[NSMutableDictionary dictionary];
    }return _exceptionMutableDictionary;
}
-(NSString *)initstring:(NSString*)tipString content:(NSString*)content{
    return [NSString stringWithFormat:@"%@:%@",tipString,content?:@""];
}
@end
