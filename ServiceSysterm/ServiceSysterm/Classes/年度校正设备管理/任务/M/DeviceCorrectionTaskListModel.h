//
//  DeviceCorrectionTaskListModel.h
//  ServiceSysterm
//
//  Created by Andy on 2022/3/11.
//  Copyright © 2022 SLPCB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceCorrectionTaskListModel : NSObject
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
 申请时间
 */

@property (nonatomic,copy)NSString *IssueTime;

/**
 申请人
 */
@property (nonatomic,copy)NSString *OperApplyUser;

/**
 创建人
 */
@property (nonatomic,copy)NSString *OperCreateUser;

/**
 创建人姓名
 */
@property (nonatomic,copy)NSString *OperCreateUserName;
/**
 操作者
 */
@property (nonatomic,copy)NSString *OperFinishUser;

/**
 taskId
 */
@property (nonatomic,copy)NSString *OutCorrectionTaskId;

/**
 备注
 */
@property (nonatomic,copy)NSString *Remark;

/**
 任务单号
 */
@property (nonatomic,copy)NSString *TaskCode;

/**
 任务状态
 */
@property (nonatomic,assign)NSInteger TaskStatus;

@property (nonatomic,copy)NSString *TaskStatusStr;

/**
 任务Id
 */
@property (nonatomic,copy)NSString *TaskUserId;

/**
 姓名
 */
@property (nonatomic,copy)NSString *UserName;

@end

NS_ASSUME_NONNULL_END
