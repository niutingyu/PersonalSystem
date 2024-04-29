//
//  NetMoudleListArray.m
//  ServiceSysterm
//
//  Created by Andy on 2020/11/16.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "NetMoudleListArray.h"


@interface NetMoudleListArray()

@property (nonatomic,strong)NSMutableArray *moudleMutableArray;
@end
@implementation NetMoudleListArray


-(instancetype)init{
    if (self =[super init]) {
        _moudleMutableArray  =[NSMutableArray array];
        
    }
    return self;
}
-(void)initMoudleWithMoudleArray:(NSArray *)moudleArray{
    NSString * pathStr  =[[NSBundle mainBundle]pathForResource:@"ModuleListArray" ofType:@"plist"];
    NSArray * moudleArr  = [[NSArray alloc]initWithContentsOfFile:pathStr];
    for (NSDictionary * localDict in moudleArr) {
        for (NSDictionary * moudleDict in moudleArray) {
            NSString * localMoudleString  =  localDict[@"moduleName"];
            NSString * netMoudleString  = moudleDict[@"ModuleName"];
            if ([netMoudleString isEqualToString:@"设备维修"]&&[localMoudleString isEqualToString:@"设备维修"]) {
                [_moudleMutableArray addObject:localDict];
            }else if ([netMoudleString isEqualToString:@"设备点检保养"]&&[localMoudleString isEqualToString:@"设备点检保养"]){
                [_moudleMutableArray addObject:localDict];
            }else if ([netMoudleString isEqualToString:@"设备履历查询"]&&[localMoudleString isEqualToString:@"设备履历查询"]){
                [_moudleMutableArray addObject:localDict];
            }else if ([netMoudleString isEqualToString:@"厂务施工"]&&[localMoudleString isEqualToString:@"厂务施工"]){
                [_moudleMutableArray addObject:localDict];
            }else if ([netMoudleString isEqualToString:@"IQC检验"]&&[localMoudleString isEqualToString:@"IQC检验"]){
                [_moudleMutableArray addObject:localDict];
            }else if ([netMoudleString isEqualToString:@"废品变卖"]&&[localMoudleString isEqualToString:@"废品变卖"]){
                [_moudleMutableArray addObject:localDict];
            }else if ([netMoudleString isEqualToString:@"年度校正设备管理"]&&[localMoudleString isEqualToString:@"设备校正"]){
                [_moudleMutableArray addObject:localDict];
            }else if ([netMoudleString isEqualToString:@"设备点检保养"]&&[localMoudleString isEqualToString:@"关键配件管理"]){
                [_moudleMutableArray addObject:localDict];
            }
        }
    }
    
    //保存
    [Units writeDataTodiskWithKeyStr:@"moudle" path:@"keypath" idObj:_moudleMutableArray];
    
}
@end
