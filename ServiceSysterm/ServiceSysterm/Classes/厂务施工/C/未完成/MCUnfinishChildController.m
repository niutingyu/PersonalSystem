//
//  MCUnfinishChildController.m
//  ServiceSysterm
//
//  Created by Andy on 2020/10/24.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MCUnfinishChildController.h"
#import "MCListModel.h"
#import "MCMyTaskTableViewCell.h"

#import "MCDetailViewController.h"
@interface MCUnfinishChildController ()

@property (nonatomic,strong)NSMutableArray * filterArray;
@end

@implementation MCUnfinishChildController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"未完成";
    
    for (MCListModel * model in self.moudleArray) {
        if ([_selectedTypeString isEqualToString:model.taskStatus]) {
            if (![self.filterArray containsObject:model]) {
                [self.filterArray addObject:model];
            }
        }if ([_selectedTypeString isEqualToString:@"所有"]) {
            self.filterArray  = self.moudleArray;
        }
        
    }
    
    [self.view addSubview:self.tableView];
    
    self.tableView.separatorStyle  =UITableViewCellSeparatorStyleSingleLine;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MCMyTaskTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell0"];
    self.tableView.estimatedRowHeight = 130.0f;
    

    
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filterArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MCMyTaskTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
    
    NSString * idxStr  = [NSString stringWithFormat:@"%ld/%ld",indexPath.row+1,self.filterArray.count];
    [cell setupCellWithModel:self.filterArray[indexPath.row] idx:idxStr];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 3;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MCListModel * model  = self.filterArray[indexPath.row];
    MCDetailViewController * controller  =[MCDetailViewController new];
    controller.constructionId  =model.constructionTaskId;
    [self.navigationController pushViewController:controller animated:YES];
}
-(NSMutableArray*)filterArray{
    if (!_filterArray) {
        _filterArray  =[NSMutableArray array];
    }return _filterArray;
}
@end
