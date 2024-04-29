//
//  OutStockTableViewCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/8/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "OutStockTableViewCell.h"

@implementation OutStockTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)configureCellWithModel:(OutStockModel*)model idx:(NSString*)idx{
    self.dataLabel.text = [Units timeWithTime:model.IssueOn beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"yy/MM/dd"];
    self.timeLabel.text = [Units timeWithTime:model.IssueOn beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"HH:mm"];
    self.departmentLabel.text = model.MatRDepName;
    self.countLabel.text = idx;
    
    NSString * materialType;
    if (model.Status == 1) {
        materialType =@"待出库";
    }else if (model.Status ==2){
        materialType =@"已出库";
    }else if (model.Status == 11){
        materialType =@"作废";
    }
    self.stateLabel.text = materialType;
    self.materialTypeLabel.text = [NSString stringWithFormat:@"领料类型:%@",[self materialType:model.Status]];
    self.stockNumberLabel.text = [NSString stringWithFormat:@"出库单号:%@",model.StockOutBillCode];
    self.topNumberLabel.text = [NSString stringWithFormat:@"上级关联单号:%@",model.SupDocCode];
}

-(NSString*)materialType:(NSInteger)idx{
    NSString * status;
    if (idx ==1) {
        status =@"领料出库";
    }else if (idx ==2){
        status =@"转出出库";
    }else if (idx ==3){
        status =@"报废出库";
    }else if (idx ==4){
        status =@"退货出库";
    }else if (idx ==5){
        status =@"发料出库";
    }
    return status;
}
@end
