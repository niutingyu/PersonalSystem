//
//  DEMaintenceBYTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2023/1/7.
//  Copyright © 2023 SLPCB. All rights reserved.
//

#import "DEMaintenceBYTableCell.h"

@implementation DEMaintenceBYTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)configCellWithModel:(MaintenceStepListModel*)model idx:(NSInteger)idx{
    self.processLab.text =[NSString stringWithFormat:@"%ld.步骤名称:%@",idx,model.MaintenanceStepsName];
    self.partLab.text  =[NSString stringWithFormat:@"检查项目:%@",model.MaintenanceProjectName];
    self.contentLab.text =[NSString stringWithFormat:@"检查内容:%@",model.ContentName];
    self.resultLab.text  =[NSString stringWithFormat:@"检验结果:%@",model.CheckResult];
}

@end
