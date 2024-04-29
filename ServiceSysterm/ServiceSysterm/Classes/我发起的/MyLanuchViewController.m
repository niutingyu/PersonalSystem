//
//  MyLanuchViewController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/27.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "MyLanuchViewController.h"

@interface MyLanuchViewController ()

@end

@implementation MyLanuchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self getMessage];
}

-(void)getMessage{
    NSString * url = [NSString stringWithFormat:@"%@userManger/userTasks?jobNum=%@",USERDEFAULT_object(@"url"),USERDEFAULT_object(JOBNUM)];
    debugLog(@"url ==%@",url);
    NSMutableDictionary * parms =[NSMutableDictionary dictionary];
    [HttpTool get:url parms:parms sucess:^(id  _Nonnull responseObject) {
        debugLog(@"- - - -%@",responseObject);
    } error:^(NSString * _Nonnull error) {
        debugLog(@" - - -- error %@",error);
    }];
}

@end
