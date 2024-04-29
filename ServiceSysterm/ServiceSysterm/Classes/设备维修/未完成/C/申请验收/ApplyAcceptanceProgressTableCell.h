//
//  ApplyAcceptanceProgressTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/8/9.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "UITextView+Placeholder.h"
NS_ASSUME_NONNULL_BEGIN

@interface ApplyAcceptanceProgressTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headTitle;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

NS_ASSUME_NONNULL_END
