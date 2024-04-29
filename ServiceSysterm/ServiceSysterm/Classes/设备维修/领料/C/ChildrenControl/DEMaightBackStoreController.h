//
//  DEMaightBackStoreController.h
//  ServiceSysterm
//
//  Created by Andy on 2019/6/19.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DeviceBaseController.h"

#import "DEStockModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DEMaightBackStoreController : DeviceBaseController
@property (copy,nonatomic)NSString * requestId;

@property (copy,nonatomic)NSString * factoryId;

@property (nonatomic,strong)DEMatrialListModel * listModel;

@end

NS_ASSUME_NONNULL_END
