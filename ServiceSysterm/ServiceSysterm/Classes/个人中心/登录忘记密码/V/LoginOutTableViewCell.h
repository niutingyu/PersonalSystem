//
//  LoginOutTableViewCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/4/24.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^loginOutBlock)(void);
@interface LoginOutTableViewCell : BaseTableViewCell
@property (nonatomic,copy)loginOutBlock loginout;
@end

NS_ASSUME_NONNULL_END
