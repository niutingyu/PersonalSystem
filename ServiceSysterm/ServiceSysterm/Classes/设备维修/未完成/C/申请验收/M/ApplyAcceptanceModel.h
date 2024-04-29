//
//  ApplyAcceptanceModel.h
//  ServiceSysterm
//
//  Created by Andy on 2019/8/9.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApplyAcceptanceModel : NSObject


@end

// 设备故障
@interface DeviceErrorsModel : NSObject
@property (nonatomic,copy)NSString *FaultReasonName;
@property (nonatomic,copy)NSString *FaultReasonId;

@end

//设备配件
@interface DevicePartsModel : NSObject
@property (nonatomic,copy)NSString * MaintainFacilityPartsId;
@property (nonatomic,copy)NSString * PartsDetailName;
@end

//配件类型
@interface TypeOfPartModel : NSObject
@property (nonatomic,copy)NSString *PartsTypeName;
@property (nonatomic,copy)NSString *PartsTypeId;

@end
NS_ASSUME_NONNULL_END
