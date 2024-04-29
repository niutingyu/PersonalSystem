//
//  MCNewOrderRemarkTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2020/10/17.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCNewOrderRemarkTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (nonatomic,copy)void(^textViewBlock)(NSString *text);

@end

NS_ASSUME_NONNULL_END
