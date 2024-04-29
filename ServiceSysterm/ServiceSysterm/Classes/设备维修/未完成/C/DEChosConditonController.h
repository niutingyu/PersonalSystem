//
//  DEChosConditonController.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/16.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DeviceBaseController.h"
#import "FilterModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DEChosConditonController : DeviceBaseController
@property (nonatomic,copy)void(^passItemBlock)(FilterModel*filterModel);
@end

NS_ASSUME_NONNULL_END
