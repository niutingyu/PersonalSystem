//
//  MCOperateTableAlertView.h
//  ServiceSysterm
//
//  Created by Andy on 2020/10/29.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^choseMemberBlock)(NSMutableArray*memberArray);
@interface MCOperateTableAlertView : UIView

@property (nonatomic,copy)choseMemberBlock memberBlock;


+(void)showTableAlertViewWithHeadString:(NSString*)headTitle datasource:(NSMutableArray*)datasource memBlock:(choseMemberBlock)memBlock;

@end

NS_ASSUME_NONNULL_END
