//
//  OutStockAlertTableCell.h
//  ServiceSysterm
//
//  Created by Andy on 2019/8/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "OutStockModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OutStockAlertTableCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headLineLabel;
@property (weak, nonatomic) IBOutlet UILabel *materialTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *materilaNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockLabel;
@property (weak, nonatomic) IBOutlet UILabel *flowWaterLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeHouseLabel;
@property (weak, nonatomic) IBOutlet UILabel *luggageLabel;
@property (nonatomic,strong)StockDetailModel *model;

@end

NS_ASSUME_NONNULL_END
