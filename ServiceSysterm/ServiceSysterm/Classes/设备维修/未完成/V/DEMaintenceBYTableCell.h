//
//  DEMaintenceBYTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2023/1/7.
//  Copyright © 2023 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "DEUnfinishDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DEMaintenceBYTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *processLab;
@property (weak, nonatomic) IBOutlet UILabel *partLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *resultLab;

-(void)configCellWithModel:(MaintenceStepListModel*)model idx:(NSInteger)idx;

@end

NS_ASSUME_NONNULL_END
