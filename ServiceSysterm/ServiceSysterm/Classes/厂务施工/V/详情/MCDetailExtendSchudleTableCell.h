//
//  MCDetailExtendSchudleTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2020/10/30.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCDetailExtendSchudleTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UISwitch *swithBut;

@end

NS_ASSUME_NONNULL_END
