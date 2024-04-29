//
//  PasswordSetTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/6/22.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "JKCountDownButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface PasswordSetTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UIButton *vertifryButton;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (nonatomic,copy)void(^vertifyBlock)(JKCountDownButton*);
@end

NS_ASSUME_NONNULL_END
