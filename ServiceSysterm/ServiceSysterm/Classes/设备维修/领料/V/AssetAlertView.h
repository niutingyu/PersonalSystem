//
//  AssetAlertView.h
//  SLPersonnelSystem
//
//  Created by Andy on 2019/4/22.
//  Copyright © 2019 深圳市深联电路有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^updateStock)(void);

@interface AssetAlertView : UIView

+(void)showassetAlertViewWithCode:(NSString*)code;

@property (nonatomic,copy) updateStock updateBlock;
@end

NS_ASSUME_NONNULL_END
