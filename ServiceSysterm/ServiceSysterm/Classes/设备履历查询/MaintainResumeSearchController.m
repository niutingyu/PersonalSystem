//
//  MaintainResumeSearchController.m
//  ServiceSysterm
//
//  Created by Andy on 2020/3/24.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MaintainResumeSearchController.h"
#import "MaintainResumeKeyCell.h"
@interface MaintainResumeSearchController ()<UITextFieldDelegate>

/**
 设备编号
 */
@property (nonatomic,copy)NSString * deviceNumber;
/**
 设备名称
 */
@property (nonatomic,copy)NSString * deviceName;
@end

@implementation MaintainResumeSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 50.0f;
    [self.tableView registerNib:[UINib nibWithNibName:@"MaintainResumeKeyCell" bundle:nil] forCellReuseIdentifier:@"cell0"];
    /**
        返回按钮
        */
       UIBarButtonItem * leftItem =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backMethod)];
       self.navigationItem.leftBarButtonItem = leftItem;
       UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureMethod)];
       self.navigationItem.rightBarButtonItem = rightItem;
    
}

-(void)backMethod{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sureMethod{
    [self.view endEditing:YES];
    if (self.deviceName.length ==0||self.deviceNumber.length ==0) {
        [Units showErrorStatusWithString:@"关键词不能为空"];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.keyBlock) {
            self.keyBlock(self.deviceName, self.deviceNumber);
        }
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MaintainResumeKeyCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell0"];
    NSArray * tips = @[@"设备编号",@"设备名称"];
    cell.keyTipLabel.text = tips[indexPath.row];
    cell.keyTextField.placeholder = [NSString stringWithFormat:@"请输入%@",tips[indexPath.row]];
    cell.keyTextField.delegate = self;
    cell.keyTextField.tag = indexPath.row;
    
    return cell;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.tag ==0) {
        _deviceNumber = textField.text;
    }else{
        _deviceName = textField.text;
    }
    
    return YES;
}
@end
