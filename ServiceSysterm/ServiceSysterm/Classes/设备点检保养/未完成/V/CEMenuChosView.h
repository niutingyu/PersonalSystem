//
//  CEMenuChosView.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/27.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CEMenuChosView : UIView
@property (nonatomic,copy)void(^chosItemBlock)(NSInteger);
@end

NS_ASSUME_NONNULL_END
