//
//  MCOperateRemarkAlertView.h
//  ServiceSysterm
//
//  Created by Andy on 2020/10/29.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^commitBlock)(NSString *text);
@interface MCOperateRemarkAlertView : UIView


@property (nonatomic,copy)commitBlock cBlock;

+(void)showAlerMCRemarkAlertViewWithHeadString:(NSString*)headString commitBlock:(commitBlock)commitBlock;

@end

NS_ASSUME_NONNULL_END
