//
//  DESearchRankTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/18.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "DESearchModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DESearchRankTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleNameLab;
@property (weak, nonatomic) IBOutlet UILabel *rankLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UILabel *maintainTimeLab;
@property (nonatomic,strong)DERankModel * model;

@end

NS_ASSUME_NONNULL_END
