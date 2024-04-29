//
//  QCColumnListModel.h
//  ServiceSysterm
//
//  Created by Andy on 2021/7/17.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCColumnListModel : BaseModel

/**
 列名
 */
@property (nonatomic,copy)NSString *ColumnName;

/**
 
 */
@property (nonatomic,copy)NSString *DataMember;

@property (nonatomic,copy)NSString *IfDecisionColumn;

@property (nonatomic,copy)NSString *ResultColumn;

@property (nonatomic,copy)NSString *Sort;

@end

NS_ASSUME_NONNULL_END
