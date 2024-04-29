//
//  MCDetailExtendSchudleController.h
//  ServiceSysterm
//
//  Created by Andy on 2020/10/30.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "DeviceBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCDetailExtendSchudleController : DeviceBaseController

@property (nonatomic,copy)NSString * typeString;

@property (nonatomic,copy)NSString * constructionId;

@property (nonatomic,copy)void(^finishNetBlock)(void);
@end

NS_ASSUME_NONNULL_END
