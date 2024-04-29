//
//  MoudleListModel.h
//  ServiceSysterm
//
//  Created by Andy on 2019/4/25.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MoudleListModel : BaseModel

@property(nonatomic,copy)NSString *ModuleId;
@property (nonatomic,copy)NSString *ModuleName;
@property (nonatomic,copy)NSString *PrivilegeId;

@end

NS_ASSUME_NONNULL_END
