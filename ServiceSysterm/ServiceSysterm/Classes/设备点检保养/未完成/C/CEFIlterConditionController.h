//
//  CEFIlterConditionController.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/28.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DeviceBaseController.h"
#import "CEUnFinishModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CEFIlterConditionController : DeviceBaseController
@property (nonatomic,copy)void(^passTypeBlock)(CEChosTypeModel*);
@end

NS_ASSUME_NONNULL_END
