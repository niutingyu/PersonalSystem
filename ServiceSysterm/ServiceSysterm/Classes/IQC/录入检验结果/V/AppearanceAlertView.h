//
//  AppearanceAlertView.h
//  ServiceSysterm
//
//  Created by Andy on 2021/6/4.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCSubmitMainModel.h"
#import "QCAppearanceModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^refreshBlcok)(void);
@interface AppearanceAlertView : UIView
+(void)showassetAlertViewWithMainModel:(QCSubmitMainModel*)model idxRow:(NSInteger)idxRow appranceBlock:(refreshBlcok)appranceBlcok;


@property (nonatomic,copy)refreshBlcok arrayBlock;

@end

NS_ASSUME_NONNULL_END
