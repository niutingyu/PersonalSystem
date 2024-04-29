//
//  DEConditionTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/14.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DEConditionTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@end

NS_ASSUME_NONNULL_END
