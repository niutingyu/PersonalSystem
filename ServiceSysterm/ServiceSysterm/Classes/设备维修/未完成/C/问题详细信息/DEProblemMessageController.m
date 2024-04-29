//
//  DEProblemMessageController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/6/17.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEProblemMessageController.h"
#import "DEProblemModel.h"
@interface DEProblemMessageController ()
@property (nonatomic,strong)NSMutableArray * contentArray;
@end

@implementation DEProblemMessageController


-(void)getMessage{
    NSDictionary * parms = @{@"MaintenanceProblemId":_problemId};
    KWeakSelf
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    [HttpTool POST:[ProblemMessageURL getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        [Units hiddenHudWithView:weakSelf.view];
        if ([[responseObject objectForKey:@"status"]integerValue]==0) {
            NSDictionary * dict = [Units jsonToDictionary:responseObject[@"data"]];
            DEProblemModel *model = [DEProblemModel mj_objectWithKeyValues:dict];
            [weakSelf setupTableviewCell:model];
        }
        [weakSelf.tableView reloadData];
       
    } error:^(NSString * _Nonnull error) {
        
    }];
}


-(void)setupTableviewCell:(DEProblemModel*)model{
    if (model.MaintenanceProjectName.length) {
        [self.datasource addObject:[self initstring:@"检查项目" content:model.MaintenanceProjectName]];
    }if (model.ContentName.length) {
        [self.datasource addObject:[self initstring:@"检查内容" content:model.ContentName]];
    }if (model.MaintenanceResult.length) {
        [self.datasource addObject:[self initstring:@"检查结果" content:model.MaintenanceResult]];
    }if (model.ExceptionExplain.length) {
        [self.datasource addObject:[self initstring:@"异常说明" content:model.ExceptionExplain]];
    }if (model.ImplementationPlan.length) {
        [self.datasource addObject:[self initstring:@"实施方案" content:model.ExceptionExplain]];
    }if (model.PartsCode.length) {
        [self.datasource addObject:[self initstring:@"物料编码" content:model.PartsCode]];
    }if (model.PartsName.length) {
        [self.datasource addObject:[self initstring:@"配件名称" content:model.PartsName]];
    }if (model.PartsRules.length) {
        [self.datasource addObject:[self initstring:@"配件规格" content:model.PartsRules]];
    }if (model.PartsBrand.length) {
        [self.datasource addObject:[self initstring:@"配件品牌" content:model.PartsBrand]];
    }if (model.PartsLife.length) {
        [self.datasource addObject:[self initstring:@"配件寿命" content:model.PartsLife]];
    }if (model.PartsType.length) {
        [self.datasource addObject:[self initstring:@"配件类型" content:model.PartsType]];
    }if (model.QuantityDemanded.length) {
        [self.datasource addObject:[self initstring:@"需求数量" content:model.QuantityDemanded]];
    }if (model.PredictFinishTime.length) {
        [self.datasource addObject:[self initstring:@"预计完成" content:model.PredictFinishTime]];
    }if (model.ActualFinishTime.length) {
        [self.datasource addObject:[self initstring:@"实际完成" content:model.ActualFinishTime]];
    }if (model.ReasonType.length) {
        [self.datasource addObject:[self initstring:@"原因类别" content:model.ReasonType]];
    }if (model.Verification.length) {
        [self.datasource addObject:[self initstring:@"效果确认" content:model.Verification]];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"异常信息";
    [self getMessage];
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 50.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cellId"];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.textLabel.font =[UIFont systemFontOfSize:15];
    cell.textLabel.numberOfLines = 3;
    cell.textLabel.text = self.datasource[indexPath.row];
    
    return cell;
}
-(NSString *)initstring:(NSString*)tipString content:(NSString*)content{
    return [NSString stringWithFormat:@"%@:%@",tipString,content?:@""];
}
@end
