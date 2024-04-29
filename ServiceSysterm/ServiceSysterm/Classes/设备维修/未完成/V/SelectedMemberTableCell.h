//
//  SelectedMemberTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/30.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectedMemberTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (nonatomic,copy)void(^selectedItemBlock)(UIButton*);

@end

NS_ASSUME_NONNULL_END
