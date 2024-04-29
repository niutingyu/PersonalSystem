//
//  MaintainResumeSearchController.h
//  ServiceSysterm
//
//  Created by Andy on 2020/3/24.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "DeviceBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MaintainResumeSearchController : DeviceBaseController
@property(nonatomic,copy) void(^keyBlock)(NSString*deviceName,NSString*deviceCode);
@end

NS_ASSUME_NONNULL_END
