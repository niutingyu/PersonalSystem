//
//  ExpectFinishTimeTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/8/8.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "UITextView+Placeholder.h"
NS_ASSUME_NONNULL_BEGIN

@interface ExpectFinishTimeTableCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UITextView *contentText;

@end

NS_ASSUME_NONNULL_END
