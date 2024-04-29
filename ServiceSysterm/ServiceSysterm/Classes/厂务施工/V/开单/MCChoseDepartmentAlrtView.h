//
//  MCChoseDepartmentAlrtView.h
//  ServiceSysterm
//
//  Created by Andy on 2020/10/22.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^choseDepartmentBlock)(NSDictionary *department);
@interface MCChoseDepartmentAlrtView : UIView

@property (nonatomic,copy)choseDepartmentBlock departmentBlock;

+(void)showMKBusinessHistoryAlertViewWithDatasource:(NSArray*)datasource department:(choseDepartmentBlock)department;

@end

NS_ASSUME_NONNULL_END
