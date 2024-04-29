//
//  ApplyAcceptanceTypeTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/8/9.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ApplyAcceptanceTypeTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentText;

@end

NS_ASSUME_NONNULL_END
