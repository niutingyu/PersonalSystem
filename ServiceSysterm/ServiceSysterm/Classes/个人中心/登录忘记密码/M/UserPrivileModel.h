//
//  UserPrivileModel.h
//  ServiceSysterm
//
//  Created by Andy on 2019/4/25.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserPrivileModel : BaseModel

@property (nonatomic,copy)NSString *dpartName;
@property (nonatomic,copy)NSString *privilegeId;
@property (nonatomic,copy)NSString *privilegeName;
@end

NS_ASSUME_NONNULL_END
