//
//  DECommitTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/6.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DECommitTableCell : BaseTableViewCell

@property (nonatomic,copy)void(^commitMessage)(void);
@end

NS_ASSUME_NONNULL_END
