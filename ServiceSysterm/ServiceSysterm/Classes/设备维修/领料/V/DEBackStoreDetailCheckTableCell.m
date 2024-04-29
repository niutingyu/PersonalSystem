//
//  DEBackStoreDetailCheckTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/6/4.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEBackStoreDetailCheckTableCell.h"

@implementation DEBackStoreDetailCheckTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.reasonTextField.layer.borderWidth =0.5;
//    self.reasonTextField.layer.borderColor = RGBA(245, 245, 245, 1).CGColor;
//    self.reasonTextField.layer.cornerRadius = 3;
//    self.reasonTextField.layer.masksToBounds =YES;
    //self.reasonTextField.minimumFontSize =15.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(DEReturnBillDetailModel *)model{
    _model =model;
    self.titleLab.text =model.MaterialName;
    self.materialTypeLab.text =[NSString stringWithFormat:@"物料规格:%@",model.MaterialInfo];
    self.materialCodeLab.text =[NSString stringWithFormat:@"物料编码:%@",model.MaterialCode];
    self.materialIdLab.text =[NSString stringWithFormat:@"物料Id:%@",model.MaterialId];
    self.checkoutNumberLab.text = [NSString stringWithFormat:@"出库个数:%@(%@)",model.StockCount,model.StockUnit];
    self.backstoreNumberTextField.text = [NSString stringWithFormat:@"%@(%@)",model.ReturnCount,model.StockUnit];
    self.reasonTextField.text = model.Reason;
    
}
@end
