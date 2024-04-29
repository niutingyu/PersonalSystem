//
//  GarbageFootAddView.h
//  ServiceSysterm
//
//  Created by Andy on 2021/8/19.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GarbageFootAddView : UIView

@property (nonatomic,copy)void(^addBlock)(void);

@end

NS_ASSUME_NONNULL_END
