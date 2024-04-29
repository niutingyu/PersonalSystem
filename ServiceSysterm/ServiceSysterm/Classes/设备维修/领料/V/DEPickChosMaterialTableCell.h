//
//  DEPickChosMaterialTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/8.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "DEPickChosMaterialModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DEPickChosMaterialTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (nonatomic,strong)DEPickChosMaterialModel * model;
@property (nonatomic,copy)void(^selectedBlock)(UIButton*);
@end

NS_ASSUME_NONNULL_END
