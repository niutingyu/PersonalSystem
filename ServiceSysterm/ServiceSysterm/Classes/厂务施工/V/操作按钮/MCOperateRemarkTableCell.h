//
//  MCOperateRemarkTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2020/10/29.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCOperateRemarkTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UITextView *contentTextV;

@property (nonatomic,copy)void(^contentBlock)(NSString*text);

@end

NS_ASSUME_NONNULL_END
