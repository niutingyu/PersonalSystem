//
//  RevisePasswordController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "RevisePasswordController.h"
#import "RevisePassWordTableCell.h"
@interface RevisePasswordController ()
@property (nonatomic,strong)NSMutableArray * contentArray;
@end

@implementation RevisePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    NSArray * arr = @[@"工号",@"原密码",@"新密码",@"确认密码"];
    [self.datasource addObjectsFromArray:arr];
    [self.tableView registerClass:[RevisePassWordTableCell class] forCellReuseIdentifier:@"cellId"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RevisePassWordTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    cell.tipLab.text  =[NSString stringWithFormat:@"%@:",self.datasource[indexPath.row]];
    NSArray * placeHolds =@[@"请输入工号",@"请输入原密码",@"请输入新密码",@"请再次输入密码"];
    cell.inputTextField.placeholder = placeHolds[indexPath.row];
    cell.inputTextField.text =self.contentArray[indexPath.row];
    NSString * tipString = self.datasource[indexPath.row];
    if ([tipString isEqualToString:@"工号"]) {
        if ([USERDEFAULT_object(JOBNUM)length]) {
          cell.inputTextField.enabled = NO;
        }else{
          cell.inputTextField.enabled = YES;
        }
       
    }else{
        cell.inputTextField.enabled = YES;
    }
    return cell;
}

-(NSMutableArray*)contentArray{
    if (!_contentArray) {
        _contentArray = [[NSMutableArray alloc]initWithCapacity:self.datasource.count];
        for (int i =0; i<self.datasource.count; i++) {
            [_contentArray addObject:@""];
        }
        [_contentArray replaceObjectAtIndex:0 withObject:USERDEFAULT_object(JOBNUM)?:@""];
    }return _contentArray;
}
@end
