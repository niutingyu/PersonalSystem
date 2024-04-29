//
//  AddNewOrderController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/25.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "AddNewOrderController.h"
#import "FFAddNewOrderTableCell.h"
#import "OtherViewController.h"
@interface AddNewOrderController ()

@end

@implementation AddNewOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"开单";
//    [self.view addSubview:self.tableView];
//    self.tableView.rowHeight = 50.0f;
//
//    NSArray * arr = @[@"开单人",@"部门工序",@"设备编号",@"设备名称",@"所属部门",@"所属区域",@"设备等级",@"紧急程度",@"故障类型",@"报修数量"];
//    [self.datasource addObjectsFromArray:arr];
//    [self.tableView registerNib:[UINib nibWithNibName:@"FFAddNewOrderTableCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 200, 50, 40);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
   
}
-(void)btnClick{
    [self.navigationController pushViewController:[OtherViewController new] animated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FFAddNewOrderTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
