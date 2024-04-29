//
//  MCListModel.h
//  ServiceSysterm
//
//  Created by Andy on 2020/10/24.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCListModel : BaseModel


@property (nonatomic,copy)NSString *consDepartName;

@property (nonatomic,copy)NSString *constructionTaskId;

@property (nonatomic,copy)NSString *dpartName;

@property (nonatomic,copy)NSString *issueTime;

@property (nonatomic,copy)NSString *operCreateUserName;

@property (nonatomic,copy)NSString *taskCode;

@property (nonatomic,copy)NSString *taskStatus;

@property (nonatomic,copy)NSString *typeName;


@end

NS_ASSUME_NONNULL_END
