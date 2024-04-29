//
//  DECheckListController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/24.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DECheckListController.h"

@interface DECheckListController ()

@end

@implementation DECheckListController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
   //点检列表
    [self filterMessage:@"点检"];
    
   
    
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
