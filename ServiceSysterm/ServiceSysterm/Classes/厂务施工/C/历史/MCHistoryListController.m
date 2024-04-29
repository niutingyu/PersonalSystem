//
//  MCHistoryListController.m
//  ServiceSysterm
//
//  Created by Andy on 2020/10/14.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MCHistoryListController.h"

#import "MCListModel.h"

#import "MCHistoryTableCell.h"

#import "MCDetailViewController.h"
@interface MCHistoryListController ()

@end

@implementation MCHistoryListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"历史";
    [self.view addSubview:self.tableView];
    
    self.tableView.estimatedRowHeight  =120.0f;
    
    self.tableView.separatorStyle  =UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:@"MCHistoryTableCell" bundle:nil] forCellReuseIdentifier:@"cell0"];
    
    
    [self getDatas];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MCHistoryTableCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cell0"];
    MCListModel * model  =self.datasource[indexPath.row];
    
    [cell setupCellWithModel:model idx:[NSString stringWithFormat:@"%ld/%ld",indexPath.row+1,self.datasource.count]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MCDetailViewController * controller  =[MCDetailViewController new];
    MCListModel * model  = self.datasource[indexPath.row];
    controller.constructionId  =model.constructionTaskId;
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)getDatas{
    NSMutableDictionary * parms  =[NSMutableDictionary dictionary];
    [parms setObject:USERDEFAULT_object(USERID) forKey:@"UserId"];
    
    [parms setObject:@"1" forKey:@"ListType"];
    
   NSString * beginTimeString = [NSString stringWithFormat:@"%@ 00:00:00",[Units getNowDate:-29]];
    NSString * endTimeString =[NSString stringWithFormat:@"%@ 23:59:59",[Units getNowDate:0]];
    
    [parms setObject:beginTimeString forKey:@"StartTime"];
    
    [parms setObject:endTimeString forKey:@"EndTime"];
    
    NSString * url =@"maint/construstiontask/applyLists";
    [Units showHudWithText:Loading view:self.view model:MBProgressHUDModeIndeterminate];
    KWeakSelf
    [HttpTool POST:[url getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
       
        [Units hiddenHudWithView:weakSelf.view];
        
        if ([[responseObject  objectForKey:@"status"]intValue]==0) {
            NSArray * arr  = [Units jsonToArray:responseObject[@"data"]];
            NSMutableArray * arr1  =[MCListModel mj_objectArrayWithKeyValuesArray:arr];
            [weakSelf.datasource removeAllObjects];
            [weakSelf.datasource addObjectsFromArray:arr1];
            
        }
        
        [weakSelf.tableView reloadData];
        
        debugLog(@" -- - - --%@",responseObject);
        
    } error:^(NSString * _Nonnull error) {
        
    }];
    
}

@end
