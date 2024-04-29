//
//  ExpectFinishTimeController.h
//  ServiceSysterm
//
//  Created by Andy on 2019/8/8.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DeviceBaseController.h"
#import "DEUnfinishDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ExpectFinishTimeController : DeviceBaseController
@property (nonatomic,strong)DEUnfinishDetailModel * detailModel;

@end

NS_ASSUME_NONNULL_END
