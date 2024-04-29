//
//  MCDetailAppointController.h
//  ServiceSysterm
//
//  Created by Andy on 2020/10/30.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "DeviceBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCDetailAppointController : DeviceBaseController

@property (nonatomic,copy)NSString *constructionId;

@property (nonatomic,copy)NSString * constructionType;

@end

NS_ASSUME_NONNULL_END
