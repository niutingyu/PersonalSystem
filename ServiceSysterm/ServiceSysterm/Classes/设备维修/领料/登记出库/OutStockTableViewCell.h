//
//  OutStockTableViewCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/8/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "OutStockModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OutStockTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *materialTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *topNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

-(void)configureCellWithModel:(OutStockModel*)model idx:(NSString*)idx;
@end

NS_ASSUME_NONNULL_END
