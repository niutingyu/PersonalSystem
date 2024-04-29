//
//  DEMaterialListTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/14.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "DEMaterialDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DEMaterialListTableCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *materialNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *stockCountLab;

@property (weak, nonatomic) IBOutlet UILabel *materailTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UILabel *applyCountLab;
@property (weak, nonatomic) IBOutlet UILabel *wetherBackLab;

@property (nonatomic,strong)DEMaterialDetailModel * model;
@end

NS_ASSUME_NONNULL_END
