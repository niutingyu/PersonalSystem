//
//  DEMaterialListTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/14.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEMaterialListTableCell.h"

@implementation DEMaterialListTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(DEMaterialDetailModel *)model{
    _model =model;
    self.titleLab.text = model.MaterialName;
    self.materailTypeLab.text = [NSString stringWithFormat:@"物料规格:%@",model.MaterialInfo];
    self.materialNumberLab.text = [NSString stringWithFormat:@"物料编码:%@",model.MaterialCode];
    self.stockCountLab.text = [NSString stringWithFormat:@"库存数量:%d(%@)",model.CountAll, model.StockUnit];
    self.applyCountLab.text = [NSString stringWithFormat:@"申请数量:%d(%@)",model.ApplyCount,model.StockUnit];
    self.countLab.text = [NSString stringWithFormat:@"发放数量:%d(%@)",model.ActCount,model.StockUnit];
    self.wetherBackLab.text = [NSString stringWithFormat:@"是否退还:%@",model.IsReject==0?@"否":@"是"];
}
@end
