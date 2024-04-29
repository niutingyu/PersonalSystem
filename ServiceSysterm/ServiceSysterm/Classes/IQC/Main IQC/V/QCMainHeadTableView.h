//
//  QCMainHeadTableView.h
//  ServiceSysterm
//
//  Created by Andy on 2021/7/6.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownMenuView.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCMainHeadTableView : UIView

@property (nonatomic,copy)void(^segmentBlock)(NSInteger flag,DropDownMenuView *menuView);

/**查询和重置*/

@property (nonatomic,copy)void(^butBlock)(NSInteger flag,NSString * numberString,NSString * nameString,NSString * infoString);

/**
 输入框输入内容
 */
@property (nonatomic,copy)void(^textBlock)(NSString * numberString,NSString * nameString,NSString * infoString);

/**
 状态
 */
@property (nonatomic,strong)DropDownMenuView *menuView;

/**
 状态取值
 */
@property (nonatomic,copy)void(^menuViewBlock)(NSInteger selectedId);

@property (nonatomic,copy)void(^dateFilterBlock)(NSString*beginStr,NSString *endStr);

@end

NS_ASSUME_NONNULL_END
