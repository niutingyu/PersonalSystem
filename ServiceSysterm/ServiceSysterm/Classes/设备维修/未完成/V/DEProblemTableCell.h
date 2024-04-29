//
//  DEProblemTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/6/18.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "TextField.h"
NS_ASSUME_NONNULL_BEGIN

@interface DEProblemTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet TextField *inputTextField;

@end

NS_ASSUME_NONNULL_END
