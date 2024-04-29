//
//  MCHistoryTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2020/10/24.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MCHistoryTableCell.h"

@implementation MCHistoryTableCell

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
    
    self.departmentLab.text  =[NSString stringWithFormat:@"%@-%@",model.dpartName,model.operCreateUserName];
    
    self.orderNumLab.text  =model.taskCode;
    self.constructionTypelab.text  = model.typeName;
    
    self.statusLab.text  = model.taskStatus;
    self.constructionDepartmentLab.text  =[NSString stringWithFormat:@"施工部门:%@",model.consDepartName];
    self.countLab.text  = idx;
}
@end
