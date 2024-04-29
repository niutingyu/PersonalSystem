//
//  ApplyFinishAlertView.h
//  ServiceSysterm
//
//  Created by Andy on 2019/8/10.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEUnfinishDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^chosMaintainIdBlock)(DetailMemberModel*_Nullable,NSMutableArray*_Nullable);
@interface ApplyFinishAlertView : UIView

+(void)showAlertWithSource:(NSMutableArray*)source maintainBlock:(chosMaintainIdBlock)maintainBlock;
@property (nonatomic,copy)chosMaintainIdBlock maintainIdBlock;
@end

NS_ASSUME_NONNULL_END
