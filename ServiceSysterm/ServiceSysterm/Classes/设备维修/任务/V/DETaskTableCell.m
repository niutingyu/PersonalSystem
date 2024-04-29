//
//  DETaskTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/7.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DETaskTableCell.h"

@implementation DETaskTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 5;
    self.clipsToBounds =YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)configureCell:(NSMutableArray*)datasource rowIdx:(NSInteger)rowIdx{
    DETaskModel *model = datasource[rowIdx];
    _monthLab.text =[Units timeWithTime:model.IssueTime beforeFormat:@"yyyy-HH-dd HH:mm:ss" andAfterFormat:@"yy/HH/dd"];
    _hourLab.text =[Units timeWithTime:model.IssueTime beforeFormat:@"yyyy-HH-dd HH:mm:ss" andAfterFormat:@"HH:mm"];
    _titleLab.text = [NSString stringWithFormat:@"%@-%@",model.DepName,model.OperCreateUserName];
    _numberLab.text = model.TaskCode;
    _departmentLab.text =model.MaintainFaultName?:@"暂无";
    _departmentCheckLab.text =model.TaskStatusName;
    _companyLab.text = model.FacilityName;
    _checkProgressLab.text = [NSString stringWithFormat:@"%ld/%ld",rowIdx+1,datasource.count];
    _checkTimeLab.text =[NSString stringWithFormat:@"距离开单时间:%@",[self delayTime:model.IssueTime andEndTime:nil]];
    
    
    
}
-(void)setFrame:(CGRect)frame{
    frame.origin.x +=5;
    frame.size.width -=10;
    [super setFrame:frame];
}
@end
