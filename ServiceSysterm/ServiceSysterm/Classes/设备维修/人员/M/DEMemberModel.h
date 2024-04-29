//
//  DEMemberModel.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/8.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DEMemberModel : BaseModel
@property (nonatomic,copy) NSString *UsersExtendId;//扩展表主键ID
@property (nonatomic,copy) NSString *UserId;//用户主键ID
@property (nonatomic,copy) NSString *UserName;//工号
@property (nonatomic,copy) NSString *UserMobile;//手机号
@property (nonatomic,copy) NSString *UserShortMobile; //短号
@property (nonatomic,copy) NSString *DistrictName;//区域名称
@property (nonatomic,copy) NSString *AssignSeqDj;//点检保养轮流指派标识
@property (nonatomic,copy) NSString *TaskFlag;//状态
@property (nonatomic,copy) NSString *FName;//姓名
@property (nonatomic,copy) NSString *Classes;//班次(0调休 1 白班 2 晚班 )
@property (nonatomic,copy) NSString *ClassesName;//班次描述

@end

NS_ASSUME_NONNULL_END
