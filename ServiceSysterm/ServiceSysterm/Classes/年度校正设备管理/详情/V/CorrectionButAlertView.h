//
//  CorrectionButAlertView.h
//  ServiceSysterm
//
//  Created by Andy on 2022/3/12.
//  Copyright © 2022 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^sureBlock)(NSString *passFlag,NSString *remark);

@interface CorrectionButAlertView : UIView

@property (nonatomic,copy)sureBlock sBlock;

+(void)showAlertViewWithTipStr:(NSString*)tipStr suBlock:(sureBlock)suBlock;

@end

NS_ASSUME_NONNULL_END
