//
//  MCUserOperateRemarkTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2020/11/7.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MCDetailUserOperateArrayModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MCUserOperateRemarkTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *remarkLab;


-(void)setupremarkcellWithModel:(MCDetailUserOperateArrayModel*)model;
@end

NS_ASSUME_NONNULL_END
