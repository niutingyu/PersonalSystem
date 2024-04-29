//
//  FFAddNewOrderTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/4/25.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface FFAddNewOrderTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

@end

NS_ASSUME_NONNULL_END
