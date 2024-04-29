//
//  MTMaintainNewOrderController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "MTMaintainNewOrderController.h"
#import "MTNewOrderTableCell.h"
#import "MTToolTypeTableCell.h"
#import "MTFootAddView.h"

@interface MTMaintainNewOrderController ()<UITextFieldDelegate>
{
    NSInteger _addSection;
    NSMutableArray * _sectionArray;
    
}
@end

@implementation MTMaintainNewOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sectionArray = [NSMutableArray array];
    [_sectionArray addObject:@"维修工具"];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = RGBA(242, 242, 242, 1);
    self.tableView.rowHeight = 50.0f;
    NSArray * arr = @[@"申请人",@"申请时间",@"原因"];
    [self.datasource addObjectsFromArray:arr];
    [self.tableView registerNib:[UINib nibWithNibName:@"MTToolTypeTableCell" bundle:nil] forCellReuseIdentifier:@"typeReusedId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MTNewOrderTableCell" bundle:nil] forCellReuseIdentifier:@"orderReusedId"];
  
    
    
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.datasource.count;
    }
    return _sectionArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50.0f;
    }else{
        return 88.0f;
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section ==0) {
        return nil;
    }else{
        UIView * footView =[UIView new];
        footView.bounds = CGRectMake(0, 0, kScreenWidth, 40);
        MTFootAddView * addView = [[NSBundle mainBundle]loadNibNamed:@"MTFootAddView" owner:self options:nil].firstObject;
        [footView addSubview:addView];
        KWeakSelf
        addView.addMaterialBlock = ^{
            [self->_sectionArray addObject:@"维修工具"];
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        };
        return footView;
    }
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section ==0) {
        return CGFLOAT_MIN;
    }else{
      return 48.0f;
    }
   
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        MTToolTypeTableCell * cell =[tableView dequeueReusableCellWithIdentifier:@"typeReusedId"];
        cell.tipLab.text = [NSString stringWithFormat:@"%@:",self.datasource[indexPath.row]];
        cell.inputTextField.delegate = self;
        NSString * tipString = self.datasource[indexPath.row];
        if ([tipString isEqualToString:@"申请人"]||[tipString isEqualToString:@"申请时间"]) {
            cell.inputTextField.enabled = NO;
        }else{
            cell.inputTextField.enabled = YES;
        }
        
        return cell;
    }else{
        MTNewOrderTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"orderReusedId"];
        return cell;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==1) {
        return YES;
    }return NO;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==1) {
        if (_sectionArray.count ==1) {
            [Units showErrorStatusWithString:@"已是最小数量"];
            return;
        }
        [_sectionArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
}
@end
