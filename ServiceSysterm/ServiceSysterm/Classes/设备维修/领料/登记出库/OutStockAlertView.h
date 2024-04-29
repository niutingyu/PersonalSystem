//
//  OutStockAlertView.h
//  ServiceSysterm
//
//  Created by Andy on 2019/8/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OutStockModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^outstockBlock)(NSMutableArray*);
@interface OutStockAlertView : UIView
@property (nonatomic,copy)outstockBlock stockBlock;


+(void)showAlertWithDatasource:(NSMutableArray*)datasource stockBlock:(outstockBlock)stockBlock;
@end

NS_ASSUME_NONNULL_END
