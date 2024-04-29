//
//  IQCSubmitPageController.h
//  ServiceSysterm
//
//  Created by Andy on 2021/6/1.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "IQCBaseController.h"
#import "IQCListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface IQCSubmitPageController : IQCBaseController

/**
 检验项目Id
 */
@property (nonatomic,copy)NSString * itemId;

@property (nonatomic,strong)IQCListModel *listModel;

@property (nonatomic,copy)NSString *operationTypeStr;

@property (nonatomic,copy)void(^submitSucessBlock)(void);

@end

NS_ASSUME_NONNULL_END
