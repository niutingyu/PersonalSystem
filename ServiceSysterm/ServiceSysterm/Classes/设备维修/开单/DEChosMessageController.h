//
//  DEChosMessageController.h
//  ServiceSysterm
//
//  Created by Andy on 2019/4/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DERootViewController.h"

#import "DeviceCodeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DEChosMessageController : DERootViewController

@property (nonatomic,copy)void(^passCodeMessage)(DeviceCodeModel *messageModel);

@property (nonatomic,assign)NSInteger chosIdx;//从哪个页面push

@property (nonatomic,copy)NSString *factoryId;//工厂Id




@end

NS_ASSUME_NONNULL_END
