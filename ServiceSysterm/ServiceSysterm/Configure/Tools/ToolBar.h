//
//  ToolBar.h
//  ServiceSysterm
//
//  Created by Andy on 2019/4/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^FinishBlock) (void);
NS_ASSUME_NONNULL_BEGIN

@interface ToolBar : UIToolbar


@property (nonatomic,copy) FinishBlock finishBlock;

- (instancetype)init;

+ (instancetype)toolBar;
@end

NS_ASSUME_NONNULL_END
