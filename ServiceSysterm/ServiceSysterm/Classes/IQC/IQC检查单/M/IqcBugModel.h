//
//  IqcBugModel.h
//  ServiceSysterm
//
//  Created by Andy on 2021/7/10.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IqcBugModel : BaseModel

/**
 缺陷ID
 */

@property (nonatomic,copy)NSString *BugId;

/**
 缺陷代码
 */
@property (nonatomic,copy)NSString *BugCode;

/**
 缺陷名称
 */
@property (nonatomic,copy)NSString *BugName;

/**
 描述
 */

@property (nonatomic,copy)NSString *Description;

/**
 工厂ID
 */
@property (nonatomic,copy)NSString *FactoryId;


/**
 数量
 */
@property (nonatomic,copy)NSString * countStr;


/**
 处理方式
 */

@property (nonatomic,copy)NSString * methodStr;


/**
 处理方式Id
 */
@property (nonatomic,copy)NSString * methodIdStr;

@end

@interface IqcTreatmentModel : NSObject

@property (nonatomic,copy)NSString *treatment;

@property (nonatomic,copy)NSString *count;

@property (nonatomic,copy)NSString *bugCode;

@property (nonatomic,copy)NSString *bugName;

@property (nonatomic,copy)NSString *bugId;

@property (nonatomic,copy)NSString *treatmentIdStr;


@end

NS_ASSUME_NONNULL_END
