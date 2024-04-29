//
//  FilterModel.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/16.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FilterModel : BaseModel
@property (nonatomic,copy)NSString * districtId;//区域id
@property (nonatomic,copy)NSString *engineerId;//维修工程师
@property (nonatomic,copy)NSString *departmentId;//维修部门
@property (nonatomic,copy)NSString *deviceId;//设备id
@property (nonatomic,copy)NSString * startTime;//开始时间
@property (nonatomic,copy)NSString * endTime;//结束时间
@property (nonatomic,copy)NSString *orderNumber;//维修单号
@property (nonatomic,copy)NSString *orderName;//开单人



@end
//区域
@interface DistrictModel : BaseModel
@property (nonatomic,copy)NSString *MaintainDistrictId;
@property (nonatomic,copy)NSString *DistrictName;

@end

//维修工程师
@interface EngineerModel : BaseModel
@property (nonatomic,copy)NSString *FName;
@property (nonatomic,copy)NSString *UserName;
@property (nonatomic,copy)NSString *UserId;

@end

//部门
@interface DepartMentModel : BaseModel
@property (nonatomic,copy)NSString *DepName;
@property (nonatomic,copy)NSString *OrId;

@end


NS_ASSUME_NONNULL_END
