//
//  MaintainErrorTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2021/7/3.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MaintainErrorTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;


@property (nonatomic,copy)void(^textBlock)(NSString *textString);

@end

NS_ASSUME_NONNULL_END
