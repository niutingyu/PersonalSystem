//
//  DeviceCorrectionUserLogModel.h
//  ServiceSysterm
//
//  Created by Andy on 2022/3/12.
//  Copyright © 2022 SLPCB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceCorrectionUserLogModel : NSObject
/**
 姓名
 */
@property (nonatomic,copy)NSString *FName;

/**
 是否通过
 */
@property (nonatomic,copy)NSString *PassFlag;

/**
 部门
 */
@property (nonatomic,copy)NSString *SignDpart;

/**
 备注
 */
@property (nonatomic,copy)NSString *SignRemark;
/**
 操作时间
 */
@property (nonatomic,copy)NSString *SignTime;

/**
 任务单号
 */
@property (nonatomic,copy)NSString *TaskCode;
@end

NS_ASSUME_NONNULL_END
