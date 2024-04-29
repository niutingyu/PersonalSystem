//
//  DEBackStockAlertTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/6/4.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEBackStockAlertTableCell.h"
#import "UITextView+Placeholder.h"
@implementation DEBackStockAlertTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //self.backStockReasonTextField.placeholder =@"请输入回仓原因";
    
    self.backStockReasonTextField.placeholderColor = RGBA(211, 210, 215, 1);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(DEMaterialDetailModel *)model{
    _model =model;
    _titleLab.text = model.MaterialName;
    _materialLab.text = [NSString stringWithFormat:@"物料规格:%@",model.MaterialInfo];
    _materialCodeLab.text = [NSString stringWithFormat:@"物料编码:%@",model.MaterialCode];
    _stockLocationLab.text =[NSString stringWithFormat:@"仓库位置:%@--%@",model.StoreName,model.ShelvesNum];
    _saleCountLab.text =[NSString stringWithFormat:@"出库个数:%@(%@)",model.StockCount,model.UnitName];
}
@end
