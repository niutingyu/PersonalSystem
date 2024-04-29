//
//  MCMyTaskTableViewCell.m
//  ServiceSysterm
//
//  Created by Andy on 2020/10/17.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MCMyTaskTableViewCell.h"

@implementation MCMyTaskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setupCellWithModel:(MCListModel*)model idx:(NSString*)idx{
    self.dateLab.text  = [Units timeWithTime:model.issueTime beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"yy/MM/dd"];
    self.timeLab.text  =[Units timeWithTime:model.issueTime beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"HH:mm"];
    self.orderLab.text  = [NSString stringWithFormat:@"%@-%@",model.dpartName,model.operCreateUserName];
    self.typeLab.text  = model.typeName;
    self.processLab.text  =[NSString stringWithFormat:@"施工部门:%@",model.consDepartName];
    self.timeSlotLab.text  = [NSString stringWithFormat:@"距离开单时间:%@",[Units delayTime:model.issueTime andEndTime:@""]];
    self.checkTypeLab.text  = model.taskStatus;
    self.countLab.text  =idx;
    
}
@end
