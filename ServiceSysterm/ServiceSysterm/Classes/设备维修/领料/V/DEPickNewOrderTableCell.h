//
//  DEPickNewOrderTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/8.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DEPickNewOrderTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tipTitleLab;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

@end

NS_ASSUME_NONNULL_END
