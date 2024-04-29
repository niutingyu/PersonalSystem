//
//  DeviceCorrectionUserLogCell.m
//  ServiceSysterm
//
//  Created by Andy on 2022/3/12.
//  Copyright © 2022 SLPCB. All rights reserved.
//

#import "DeviceCorrectionUserLogCell.h"

@implementation DeviceCorrectionUserLogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(DeviceCorrectionUserLogModel *)model{
    _model =model;
    self.msgLab.text  =[NSString stringWithFormat:@"操作信息:%@ %@",model.FName?:@"",model.PassFlag?:@""];
    self.dateLab.text  =[NSString stringWithFormat:@"操作时间:%@",model.SignTime?:@""];
    self.remarkLab.text  =[NSString stringWithFormat:@"操作备注:%@",model.SignRemark?:@""];
}




@end
