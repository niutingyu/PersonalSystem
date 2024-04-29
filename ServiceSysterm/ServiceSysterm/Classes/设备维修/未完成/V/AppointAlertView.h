//
//  AppointAlertView.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/30.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEUnfinishDetailModel.h"

typedef void(^selectedItemBlock)(DetailMemberModel*_Nullable,NSMutableArray*_Nullable);
typedef void(^dismissBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface AppointAlertView : UIView
+(void)showAlertWithDatasource:(NSMutableArray*)datasource  itemCallbackBlock:(selectedItemBlock)itemCallbackBlock dismissBlock:(dismissBlock)dismissBlock;


@property (nonatomic,copy)selectedItemBlock itemBlock;

@property (nonatomic,copy)dismissBlock disappearBlock;

@end

NS_ASSUME_NONNULL_END
