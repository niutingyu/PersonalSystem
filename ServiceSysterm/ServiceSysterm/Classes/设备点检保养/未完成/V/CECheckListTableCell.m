//
//  CECheckListTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/25.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "CECheckListTableCell.h"

@implementation CECheckListTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius =  3.0f;
    self.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)confiugeCell:(NSMutableArray*)datasource rowIdx:(NSInteger)rowIdx model:(CEUnFinishModel*)model{
 
    _monthLab.text = [Units timeWithTime:model.IssueTime beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"yy/MM/dd"];
    _hourLab.text =[Units timeWithTime:model.IssueTime beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"HH:mm"];
    _titleLab.text = [NSString stringWithFormat:@"%@-%@",model.DepName,model.OperCreateUserName];
    _codeLab.text = model.TaskCode;
    _maintainTypeLab.text = model.MaintainFaultName;
    _maintainStatusLab.text = model.TaskStatusName;
    _maiterialNameLab.text = model.FacilityName;
    NSString * str =nil;
    _avaliableTimeLab.text = [NSString stringWithFormat:@"距离开单时间:%@",[self delayTime:model.IssueTime andEndTime:str]];
    _countLab.text = [NSString stringWithFormat:@"%ld/%ld",rowIdx+1,datasource.count];
    
}
-(void)setFrame:(CGRect)frame{
    frame.origin.x +=5.0f;
    frame.size.width -=10.0f;
    [super setFrame:frame];
}
@end
