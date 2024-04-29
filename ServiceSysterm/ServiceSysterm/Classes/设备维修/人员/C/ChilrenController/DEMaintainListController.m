//
//  DEMaintainListController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/24.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEMaintainListController.h"

@interface DEMaintainListController ()

@end

@implementation DEMaintainListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //保养列表
    [self filterMessage:@"保养"];
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
