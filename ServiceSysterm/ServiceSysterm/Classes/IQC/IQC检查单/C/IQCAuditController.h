//
//  IQCAuditController.h
//  ServiceSysterm
//
//  Created by Andy on 2021/7/9.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "IQCBaseController.h"
#import "IQCListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface IQCAuditController : IQCBaseController

@property (nonatomic,strong)IQCListModel * mainListModel;

@property (nonatomic,copy)void(^networkSuncessBlock)(void);

@end

NS_ASSUME_NONNULL_END
