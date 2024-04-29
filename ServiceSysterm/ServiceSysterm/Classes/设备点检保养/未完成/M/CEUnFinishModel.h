//
//  CEUnFinishModel.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/25.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CEUnFinishModel : BaseModel
@property (nonatomic,copy)NSString *DepName;
@property (nonatomic,copy)NSString *MaintainDjbyId;
@property (nonatomic,copy)NSString *TaskStatusName;
@property (nonatomic,copy)NSString *MaintainFaultName;
@property (nonatomic,copy)NSString *TaskCode;
@property (nonatomic,copy)NSString *FacilityName;
@property (nonatomic,copy)NSString *IssueTime;
@property (nonatomic,copy)NSString *OperCreateUserName;

@end

@interface CEConditionModel : BaseModel
@property (nonatomic,copy)NSString *MaintainDistrictId;
@property (nonatomic,copy)NSString *DistrictName;
@property (nonatomic,copy)NSString *FName;
@property (nonatomic,copy)NSString *UserName;
@property (nonatomic,copy)NSString *UserId;
@property (nonatomic,copy)NSString *DepName;
@property (nonatomic,copy)NSString *OrId;
@end


@interface CEChosTypeModel : BaseModel

@property (nonatomic,copy)NSString *startTime;
@property (nonatomic,copy)NSString *endTime;
@property (nonatomic,copy)NSString *districtId;
@property (nonatomic,copy)NSString *maintainEngineerId;
@property (nonatomic,copy)NSString *departmentId;
@property (nonatomic,copy)NSString *deviceId;
@property (nonatomic,copy)NSString *maintainCode;



@end
NS_ASSUME_NONNULL_END
