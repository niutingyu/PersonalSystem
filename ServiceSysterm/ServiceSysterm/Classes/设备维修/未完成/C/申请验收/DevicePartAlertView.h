//
//  DevicePartAlertView.h
//  ServiceSysterm
//
//  Created by Andy on 2019/8/9.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^selectedDevicePartBlock)(NSString*,NSString*);
@interface DevicePartAlertView : UIView

@property (nonatomic,copy)selectedDevicePartBlock devicePartBlock;

+(void)showAlertViewWithdatsource:(NSArray*)datasource partBlock:(selectedDevicePartBlock)partblock;
@end

NS_ASSUME_NONNULL_END
