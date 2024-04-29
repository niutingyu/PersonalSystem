//
//  DeviceCorrectionTaskListCell.m
//  ServiceSysterm
//
//  Created by Andy on 2022/3/11.
//  Copyright © 2022 SLPCB. All rights reserved.
//

#import "DeviceCorrectionTaskListCell.h"

@implementation DeviceCorrectionTaskListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius  =3;
    self.clipsToBounds  =YES;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCellWithModel:(DeviceCorrectionTaskListModel*)model idx:(NSString*)idx{
    self.dateLab.text = [Units timeWithTime:model.IssueTime beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"yy/MM/dd"];
    self.timeLab.text =[Units timeWithTime:model.IssueTime beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"HH:mm"];
    //开单人
    self.nameLab.text = [NSString stringWithFormat:@"开单人:%@",model.OperCreateUser];
    
    //单号
    self.codeLab.text =model.TaskCode;
    self.reasonLab.text =model.FacilityName;
    self.statusLab.text  =model.TaskStatusStr;
    self.deviceLab.text  =model.Remark;
    self.countLab.text =idx;
    self.durationLab.text =[NSString stringWithFormat:@"距离开单时间:%@",[self delayTime:model.IssueTime andEndTime:[Units currentTimeWithFormat:@"yyyy-MM-dd HH:mm:ss"]]];
    
}

-(void)setFrame:(CGRect)frame{
    frame.origin.x +=5;
    frame.size.width -=10;
    [super setFrame:frame];
}
@end
