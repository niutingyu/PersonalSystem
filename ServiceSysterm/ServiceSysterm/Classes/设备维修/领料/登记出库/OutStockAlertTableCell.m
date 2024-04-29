//
//  OutStockAlertTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/8/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "OutStockAlertTableCell.h"

@implementation OutStockAlertTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(StockDetailModel *)model{
    _model =model;
    self.headLineLabel.text = model.MaterialName;
    self.materialTypeLabel.text = [NSString stringWithFormat:@"物料规格:%@",model.MaterialInfo];
    self.materilaNumberLabel.text = [NSString stringWithFormat:@"物料编码:%@",model.MaterialCode];
    self.stockLabel.text = [NSString stringWithFormat:@"库存数量:%d(%@)",model.StockCount,model.UnitName];
    self.flowWaterLabel.text = [NSString stringWithFormat:@"流水:%@",model.Barcode];
    self.storeHouseLabel.text = [NSString stringWithFormat:@"仓库:%@",model.StoreName];
    self.luggageLabel.text = [NSString stringWithFormat:@"货架号:%@",model.ShelvesNum];
}
@end
