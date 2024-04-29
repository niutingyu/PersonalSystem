//
//  MCChoseDepartmentController.m
//  ServiceSysterm
//
//  Created by Andy on 2020/10/22.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MCChoseDepartmentController.h"

@interface MCChoseDepartmentController ()

@end

@implementation MCChoseDepartmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"选择部门";
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 48.0f;
    
    self.tableView.separatorStyle  =UITableViewCellSeparatorStyleSingleLine;
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell  =[tableView dequeueReusableCellWithIdentifier:@"cell0"];
    if (cell  ==nil) {
        cell  =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
    }
    cell.selectionStyle  =UITableViewCellSelectionStyleNone;
    
    cell.textLabel.font  =[UIFont systemFontOfSize:16];
    
    NSDictionary * dic  = self.datasource[indexPath.row];
    
   
    return cell;
}

//获取部门

-(void)getDepartment{
    NSMutableDictionary * parms  =[NSMutableDictionary dictionary];
    
    [parms setObject:_factoryId forKey:@"FactoryId"];
    
    NSString * url  =@"maint/construstiontask/getDepart";
    
    [Units showStatusWithStutas:Loading];
    KWeakSelf
    
    [HttpTool POST:[url getWholeUrl] param:parms success:^(id  _Nonnull responseObject) {
        
        [Units hideView];
        
        if ([[responseObject objectForKey:@"status"]intValue]==0) {
            [weakSelf.datasource removeAllObjects];
            NSArray * arr  = [Units jsonToArray:responseObject[@"data"]];
            
            [weakSelf.datasource addObjectsFromArray:arr];
            [weakSelf.tableView reloadData];
            
        }
        debugLog(@" - - - -%@",responseObject);
        
    } error:^(NSString * _Nonnull error) {
        [Units hideView];
        [Units showErrorStatusWithString:error];
        
    }];
    
}

@end
