//
//  IqcBugAlertView.h
//  ServiceSysterm
//
//  Created by Andy on 2021/8/25.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IqcBugModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^selectBugBlock)(IqcBugModel *bugModel);
@interface IqcBugAlertView : UIView
+(void)showBugViewWithList:(NSMutableArray*)bugList bugBlcok:(selectBugBlock)bugBlcok;

@property (nonatomic,copy)selectBugBlock bugBlcok;
@end

NS_ASSUME_NONNULL_END
