//
//  MCUnfinishChildController.h
//  ServiceSysterm
//
//  Created by Andy on 2020/10/24.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "DeviceBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCUnfinishChildController : DeviceBaseController

@property (nonatomic,strong)NSMutableArray * moudleArray;

@property (nonatomic,copy)NSString * selectedTypeString;


@end

NS_ASSUME_NONNULL_END
