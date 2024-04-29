//
//  DeviceCorrectionDetailListModel.h
//  ServiceSysterm
//
//  Created by Andy on 2022/3/12.
//  Copyright © 2022 SLPCB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceCorrectionDetailListModel : NSObject
/**
 单号
 */
@property (nonatomic,copy)NSString *AssetCode;

/**
 设备单号
 */
@property (nonatomic,copy)NSString *FacilityCode;
/**
 设备ID
 */
@property (nonatomic,copy)NSString *FacilityId;

/**
 设备名称
 */
@property (nonatomic,copy)NSString *FacilityName;

/**
 完成时间
 */
@property (nonatomic,copy)NSString *FinishTime;

/**
 提交时间
 */
@property (nonatomic,copy)NSString *IssueTime;

/**
 申请人
 */
@property (nonatomic,copy)NSString *OperApplyUser;

/**
 操作权限数组
 */
@property (nonatomic,strong)NSArray *OperateArray;

/**
 备注
 */
@property (nonatomic,copy)NSString *Remark;

/**
 
 */
@property (nonatomic,copy)NSString *OperCreateUser;


@property (nonatomic,copy)NSString *OutCorrectionTaskId;
/**
 规格
 */
@property (nonatomic,copy)NSString *Specifications;
/**
 所属区域
 */

@property (nonatomic,copy)NSString *StorageLocation;

/**
 任务单号
 */
@property (nonatomic,copy)NSString *TaskCode;

/**
 任务状态
 */
@property (nonatomic,assign)NSInteger TaskStatus;

@property (nonatomic,copy)NSString *TaskUserId;

@property (nonatomic,copy)NSString *UserName;

/**
 操作记录
 */
@property (nonatomic,strong)NSArray *UserOperateArray;

@end

NS_ASSUME_NONNULL_END
