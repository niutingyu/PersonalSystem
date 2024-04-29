//
//  DEAlertFilterView.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/10.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^chosTimeBlock)(NSMutableArray*);
@interface DEAlertFilterView : UIView
+(void)showAlertViewDatasouce:(NSMutableArray*)datasouce flag:(NSInteger)flag timeBlock:(chosTimeBlock)timeBlock;

//@property (nonatomic,copy)void(^chosTimeBlock)(NSMutableArray*);
@property (nonatomic,copy)chosTimeBlock timeBlock;
@end

NS_ASSUME_NONNULL_END
