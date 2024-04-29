//
//  DeviceCorrectionHistoryListModel.h
//  ServiceSysterm
//
//  Created by Andy on 2022/3/11.
//  Copyright © 2022 SLPCB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceCorrectionHistoryListModel : NSObject

/**
 
 */
@property (nonatomic,copy)NSString *AssetCode;

@property (nonatomic,copy)NSString *FacilityCode;

@property (nonatomic,copy)NSString *FacilityId;

@property (nonatomic,copy)NSString *FacilityName;

@property (nonatomic,copy)NSString *FinishTime;

@property (nonatomic,copy)NSString *IssueTime;

@property (nonatomic,copy)NSString *OperApplyUser;

@property (nonatomic,copy)NSString *OperCreateUser;

@property (nonatomic,copy)NSString *OperFinishUser;

@property (nonatomic,copy)NSString *OutCorrectionTaskId;

@property (nonatomic,copy)NSString *Remark;

@property (nonatomic,copy)NSString *Specifications;

@property (nonatomic,copy)NSString *StorageLocation;

@property (nonatomic,copy)NSString *TaskCode;
@property (nonatomic,copy)NSString *TaskUserId;

@property (nonatomic,copy)NSString *UserName;

@end

NS_ASSUME_NONNULL_END
