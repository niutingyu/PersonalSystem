//
//  MCDetailOPerationLogCell.h
//  ServiceSysterm
//
//  Created by Andy on 2020/10/27.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MCDetailUserOperateArrayModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MCDetailOPerationLogCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *operationContentLab;
@property (weak, nonatomic) IBOutlet UILabel *operationTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *remarkLab;

-(void)setupCellWithModel:(MCDetailUserOperateArrayModel*)model;
@end

NS_ASSUME_NONNULL_END
