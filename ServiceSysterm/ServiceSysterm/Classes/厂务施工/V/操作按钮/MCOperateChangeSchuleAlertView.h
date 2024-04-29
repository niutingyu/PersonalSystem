//
//  MCOperateChangeSchuleAlertView.h
//  ServiceSysterm
//
//  Created by Andy on 2020/10/29.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface MCOperateChangeSchuleAlertView : UIView


@property (nonatomic,copy)void(^dateBlock)(NSString *dateString);

-(void)show;

@end

NS_ASSUME_NONNULL_END
