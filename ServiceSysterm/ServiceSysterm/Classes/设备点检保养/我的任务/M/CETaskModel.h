//
//  CETaskModel.h
//  ServiceSysterm
//
//  Created by Andy on 2019/6/11.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CETaskModel : BaseModel
@property (nonatomic,copy)NSString *DepName;
@property (nonatomic,copy)NSString *MaintainDjbyId;
@property (nonatomic,copy)NSString *TaskStatusName;
@property (nonatomic,copy)NSString *MaintainFaultName;
@property (nonatomic,copy)NSString *TaskCode;
@property (nonatomic,copy)NSString *FacilityName;
@property (nonatomic,copy)NSString *IssueTime;
@property (nonatomic,copy)NSString *OperCreateUserName;
@end

NS_ASSUME_NONNULL_END
