//
//  MaintainResumeKeyCell.h
//  ServiceSysterm
//
//  Created by Andy on 2020/3/24.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MaintainResumeKeyCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *keyTipLabel;
@property (weak, nonatomic) IBOutlet UITextField *keyTextField;

@end

NS_ASSUME_NONNULL_END
