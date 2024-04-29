//
//  DEUnfinishModel.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/7.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DEUnfinishModel : BaseModel
@property (nonatomic,copy)NSString *DepName;
@property (nonatomic,copy)NSString *FacilityName;
@property (nonatomic,copy)NSString *IssueTime;
@property (nonatomic,copy)NSString *MaintainFaultName;
@property (nonatomic,copy)NSString *MaintainTaskId;
@property (nonatomic,copy)NSString *OperCreateUserName;
@property (nonatomic,copy)NSString *TaskCode;
@property (nonatomic,copy)NSString *TaskStatusName;

@end

NS_ASSUME_NONNULL_END
