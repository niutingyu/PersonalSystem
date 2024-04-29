//
//  RecordEventModel.h
//  ServiceSysterm
//
//  Created by Andy on 2021/8/23.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecordEventModel : NSObject

@property (nonatomic,copy)NSString *Code;

@property (nonatomic,copy)NSString *CreatedOn;

@property (nonatomic,copy)NSString *FName;

@property (nonatomic,copy)NSString *FlowStatus;

@property (nonatomic,copy)NSString *flowStautsStr;

@property (nonatomic,copy)NSString *Id;

@property (nonatomic,copy)NSString *Name;

@property (nonatomic,copy)NSString *PayType;

@property (nonatomic,copy)NSString *PhoneNum;

@property (nonatomic,copy)NSString *ProcessInstanceId;

@property (nonatomic,copy)NSString *Recipient;

@property (nonatomic,copy)NSString *RecyclerId;

@property (nonatomic,copy)NSString *Remark;

@property (nonatomic,copy)NSString *SalesDate;

@property (nonatomic,copy)NSString *SettleType;

@end

NS_ASSUME_NONNULL_END
