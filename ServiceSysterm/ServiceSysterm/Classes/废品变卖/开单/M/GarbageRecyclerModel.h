//
//  GarbageRecyclerModel.h
//  ServiceSysterm
//
//  Created by Andy on 2021/8/19.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//回收商
@interface GarbageRecyclerModel : NSObject

@property (nonatomic,copy)NSString *Code;

@property (nonatomic,copy)NSString *CreatedBy;

@property (nonatomic,copy)NSString *CreatedOn;

@property (nonatomic,copy)NSString *DutyPerson;

@property (nonatomic,copy)NSString *FactoryId;

@property (nonatomic,copy)NSString *FlowStatus;

@property (nonatomic,copy)NSString *FlowTag;

@property (nonatomic,copy)NSString *FullName;

@property (nonatomic,copy)NSString *HasCheck;

@property (nonatomic,copy)NSString *Id;

@property (nonatomic,copy)NSString *ModifiedBy;

@property (nonatomic,copy)NSString *ModifiedOn;

@property (nonatomic,copy)NSString *Name;

@property (nonatomic,copy)NSString *PayType;

@property (nonatomic,copy)NSString *PhoneNum;

@property (nonatomic,copy)NSString *ProcessId;

@property (nonatomic,copy)NSString *ProcessInstanceId;

@property (nonatomic,copy)NSString *Recipient;

@property (nonatomic,copy)NSString *SettleType;

@property (nonatomic,copy)NSString *Status;

@property (nonatomic,copy)NSString *UnitPerson;


@end

NS_ASSUME_NONNULL_END
