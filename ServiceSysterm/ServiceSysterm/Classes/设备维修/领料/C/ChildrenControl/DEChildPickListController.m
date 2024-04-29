//
//  DEChildPickListController.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/13.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEChildPickListController.h"

@interface DEChildPickListController ()

@end

@implementation DEChildPickListController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //领料单
    
    [self reloadMessageWithUrl:[DevicePickListURL getWholeUrl] parms:[self getMutableParms:nil endTime:nil] flag:100];
   
}

-(void)getTime:(NSNotification*)notification{
    NSDictionary * dict = [notification object];
    if ([[dict objectForKey:@"textFieldTag"] isEqualToString:@"100"]) {
      //开始时间
        NSDate *currentDate = [self.formatter dateFromString:[Units getNowDate:0]];
        NSString * time = [Units timeWithTime:[dict objectForKey:@"result"] beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"yyyy-MM-dd"];
        NSDate *selectDate = [self.formatter dateFromString:time];
        NSComparisonResult result = [selectDate compare:currentDate];
        if (result == NSOrderedDescending) {
            [Units showErrorStatusWithString:@"开始时间不能大于当前时间"];
            return;
        }
        
        [self reloadMessageWithUrl:[DevicePickListURL getWholeUrl] parms:[self getMutableParms:[dict objectForKey:@"result"] endTime:nil] flag:100];
        
    }else{
        //开始时间
        NSDate *currentDate = [self.formatter dateFromString:[Units getNowDate:0]];
        NSString * time = [Units timeWithTime:[dict objectForKey:@"result"] beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"yyyy-MM-dd"];
        NSDate *selectDate = [self.formatter dateFromString:time];
        NSComparisonResult result = [selectDate compare:currentDate];
        if (result == NSOrderedDescending) {
            [Units showErrorStatusWithString:@"结束时间不能大于当前时间"];
            return;
        }
        ;
        [self reloadMessageWithUrl:[DevicePickListURL getWholeUrl] parms:[self getMutableParms:nil endTime:[dict objectForKey:@"result"]] flag:100];
    }
}
-(NSMutableDictionary*)getMutableParms:(NSString*)beginString endTime:(NSString*)endString{
    
    
    NSMutableDictionary * parms = [NSMutableDictionary dictionary];
    NSMutableArray *sorts =[NSMutableArray array];
    NSDictionary *dict1 = @{@"Column":@"RequisitionOn",@"Direction":@"Desc"};
    [sorts addObject:dict1];
    [parms setObject:[Units arrayToJson:sorts] forKey:@"sorts"];
    
    
    NSMutableArray *wheres =[NSMutableArray array];
    NSDictionary *dict2 = @{@"Column":@"DepInfo",@"Values":@"维修"};
    NSDictionary *dict3 = @{@"Column":@"StartTime",@"Values":beginString?:[self getNowDate:-1]};
    NSDictionary *dict4 = @{@"Column":@"EndTime",@"Values":endString?:[self getNowDate:0]};
    [wheres addObject:dict2];[wheres addObject:dict3];[wheres addObject:dict4];
    [parms setObject:[Units arrayToJson:wheres] forKey:@"wheres"];
    return parms;
}
@end
