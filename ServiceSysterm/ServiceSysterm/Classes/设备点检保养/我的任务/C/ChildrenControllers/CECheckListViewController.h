//
//  CECheckListViewController.h
//  ServiceSysterm
//
//  Created by Andy on 2019/6/11.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DeviceBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CECheckListViewController : DeviceBaseController
@property (nonatomic,strong)NSMutableArray * itemsArray;
-(void)filert:(NSString *)filterKey;
@end

NS_ASSUME_NONNULL_END
