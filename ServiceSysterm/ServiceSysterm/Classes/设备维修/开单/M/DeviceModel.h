//
//  DeviceModel.h
//  ServiceSysterm
//
//  Created by Andy on 2019/4/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeviceModel : BaseModel
@property (nonatomic,copy)NSString *RtId;
@property (nonatomic,copy)NSString *RtName;
@property (nonatomic,copy)NSString *Sort;
@end

NS_ASSUME_NONNULL_END
