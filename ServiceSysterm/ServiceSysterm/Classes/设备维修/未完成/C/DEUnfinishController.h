//
//  DEUnfinishController.h
//  ServiceSysterm
//
//  Created by Andy on 2019/4/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DeviceBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DEUnfinishController : DeviceBaseController
-(void)loadMessageparms:(NSMutableDictionary *)parms url:(NSString*)url;

-(void)setupSegmetControl;

@property (nonatomic,strong)NSMutableDictionary * mutaleParms;
@property (nonatomic,copy)NSString * typeControl;//跳转类型
@end

NS_ASSUME_NONNULL_END
