//
//  DeviceNavController.h
//  ServiceSysterm
//
//  Created by Andy on 2019/4/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceNavController : UINavigationController
@property (nonatomic,copy)void(^passIdx)(NSInteger);
@end

NS_ASSUME_NONNULL_END
