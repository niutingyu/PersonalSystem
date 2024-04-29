//
//  DEUnfinishChildrenController.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/8.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DeviceBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DEUnfinishChildrenController : DeviceBaseController
@property (nonatomic,strong)NSMutableArray * mouleArray;
@property (nonatomic,copy)NSString * selectedTypeString;
@end

NS_ASSUME_NONNULL_END
