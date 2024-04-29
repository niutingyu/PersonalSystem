//
//  MCUserOperateRemarkTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2020/11/7.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MCUserOperateRemarkTableCell.h"

@implementation MCUserOperateRemarkTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)setupremarkcellWithModel:(MCDetailUserOperateArrayModel*)model{
    self.contentLab.text =[NSString stringWithFormat:@"%@(%@)",model.PassFlag,model.FName];
   
    
    self.timeLab.text =[NSString stringWithFormat:@"%@",model.SignTime];
   
    
    self.remarkLab.text =[NSString stringWithFormat:@"%@",model.SignRemark];
    
  
    
    
}
@end
