//
//  DEPauseRepairController.h
//  ServiceSysterm
//
//  Created by Andy on 2019/6/1.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DeviceBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DEPauseRepairController : DeviceBaseController
@property (nonatomic,copy)NSString * maintainType;//维修类型
@property (nonatomic,copy)NSString * maintainId;//维修id
@property (nonatomic,copy)NSString * comeFromController;
@property (nonatomic,copy)void(^passSecetedMutableParmsBlock)(NSMutableDictionary*mutableParms);
@end

NS_ASSUME_NONNULL_END
