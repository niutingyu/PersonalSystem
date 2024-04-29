//
//  MCDetailOPerationLogCell.m
//  ServiceSysterm
//
//  Created by Andy on 2020/10/27.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MCDetailOPerationLogCell.h"

@implementation MCDetailOPerationLogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setupCellWithModel:(MCDetailUserOperateArrayModel*)model{
    self.operationContentLab.text  =[NSString stringWithFormat:@"操作内容:%@(%@)",model.PassFlag,model.FName];
   
    self.operationContentLab.attributedText  =[Units changeLabel:[NSString stringWithFormat:@"%@(%@)",model.PassFlag,model.FName] wholeString:self.operationContentLab.text font:[UIFont systemFontOfSize:15] color:[UIColor blueColor]];
    
    self.operationTimeLab.text  =[NSString stringWithFormat:@"操作时间:%@",model.SignTime];
    
   
    
   // self.remarkLab.text  =[NSString stringWithFormat:@"操作备注:%@",model.SignRemark?:@"无"];
}

@end
