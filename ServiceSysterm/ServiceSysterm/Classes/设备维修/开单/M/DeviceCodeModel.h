//
//  DeviceCodeModel.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/6.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeviceCodeModel : BaseModel<NSCoding>

@property (nonatomic,copy)NSString *FacilityName;
@property (nonatomic,copy)NSString *FacilityCode;
@property (nonatomic,copy)NSString * DistrictName;
@property (nonatomic,copy)NSString *FacilityId;
@property (nonatomic,copy)NSString *FacilityDpartName;
@property (nonatomic,copy)NSString *Lev;
@property (nonatomic,copy)NSString *AssociateMaintId;
@property (nonatomic,copy)NSString *DepName;
@property (nonatomic,copy)NSString *TaskCode;
@property (nonatomic,copy)NSString *RequisitionTypeName;
@property (nonatomic,copy)NSString *RequisitionType;

@property (nonatomic,copy)NSString *ActiveFlag;
@property (nonatomic,copy)NSString *AssistantId;
@property (nonatomic,copy)NSString *AssistantNames;
@property (nonatomic,copy)NSString *CreatedBy;
@property (nonatomic,copy)NSString *CreatedByName;
@property (nonatomic,copy)NSString *CreatedOn;
@property (nonatomic,copy)NSString *DepCode;
@property (nonatomic,copy)NSString *Description;
@property (nonatomic,copy)NSString *FType;
@property (nonatomic,copy)NSString *FactoryName;
@property (nonatomic,copy)NSString *ManagerCode;
@property (nonatomic,copy)NSString *ManagerId;
@property (nonatomic,copy)NSString *ManagerName;
@property (nonatomic,copy)NSString *Name;
@property (nonatomic,copy)NSString *OrId;

@end

NS_ASSUME_NONNULL_END
