//
//  DEMemberStatusBaseController.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/24.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DeviceBaseController.h"
#import "DEUnFinishModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DEMemberStatusBaseController : DeviceBaseController

@property (nonatomic,strong)NSMutableArray * itemsArray;

-(void)filterMessage:(NSString*)typeString;




@end

NS_ASSUME_NONNULL_END
