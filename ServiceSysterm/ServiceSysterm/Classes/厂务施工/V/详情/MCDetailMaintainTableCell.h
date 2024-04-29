//
//  MCDetailMaintainTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2020/10/27.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MCDetailMaintainArrayModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MCDetailMaintainTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nOrderTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *appointTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *acceptTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *issueAcceptanceLab;
@property (weak, nonatomic) IBOutlet UILabel *sureAcceptanceLab;
@property (weak, nonatomic) IBOutlet UILabel *constructionTimeConsumingLab;
@property (weak, nonatomic) IBOutlet UILabel *pauseTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *remarkLab;

-(void)setupMaintainCellWithModel:(MCDetailMaintainArrayModel*)model;
@property (nonatomic,strong)NSArray * maintainArray;

@end

NS_ASSUME_NONNULL_END
