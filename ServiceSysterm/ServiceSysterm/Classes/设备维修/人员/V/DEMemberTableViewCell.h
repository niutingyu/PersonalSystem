//
//  DEMemberTableViewCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/8.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "DEMemberModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DEMemberTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIButton *telphoneButton;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (nonatomic,copy)void(^buttonBlock)(NSInteger);
@property (nonatomic,strong)DEMemberModel *model;

@end

NS_ASSUME_NONNULL_END
