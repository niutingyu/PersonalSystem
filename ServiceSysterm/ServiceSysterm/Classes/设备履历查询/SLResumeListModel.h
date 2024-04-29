//
//  SLResumeListModel.h
//  SLPersonnelSystem
//
//  Created by Andy on 2020/3/20.
//  Copyright © 2020 深圳市深联电路有限公司. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLResumeListModel : BaseModel
/**
 故障原因
 */

@property (nonatomic,copy)NSString *FaultReasonName;

/**
 问题
 */
@property (nonatomic,copy)NSString *MaintainFaultName;

/**
 操作人
 */

@property (nonatomic,copy)NSString *FName;

/**
 单据时间
 */

@property (nonatomic,copy)NSString *IssueTime;

/**
 单据类型
 */

@property (nonatomic,copy)NSString *MaintType;
/**
 更换条件
 */

@property (nonatomic,copy)NSString *MaterialName;

/**
 单据编号
 */
@property (nonatomic,copy)NSString * TaskCode;

/**
 单据id
 */

@property (nonatomic,copy)NSString *TaskId;


/**
 单据
 状态
 */

@property (nonatomic,copy)NSString *TaskStatusName;


@end

NS_ASSUME_NONNULL_END
