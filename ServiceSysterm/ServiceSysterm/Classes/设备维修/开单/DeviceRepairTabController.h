//
//  DeviceRepairTabController.h
//  ServiceSysterm
//
//  Created by Andy on 2019/4/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceRepairTabController : UITabBarController

@property (nonatomic,copy)void(^moudleArrayBlock)(NSMutableArray *moudleArray);
@property (nonatomic,assign)NSInteger flag;
@end

NS_ASSUME_NONNULL_END
