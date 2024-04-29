//
//  PauseContentTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/8/10.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface PauseContentTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UITextView *contentText;

@end

NS_ASSUME_NONNULL_END
