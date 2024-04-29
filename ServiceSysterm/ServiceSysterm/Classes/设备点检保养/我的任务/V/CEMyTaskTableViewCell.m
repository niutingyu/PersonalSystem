//
//  CEMyTaskTableViewCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/6/11.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "CEMyTaskTableViewCell.h"

@implementation CEMyTaskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 3.0f;
    self.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)configureCell:(NSMutableArray*)datasource rowIdx:(NSInteger)rowIdx model:(CETaskModel*)model{
    self.monthLab.text = [Units timeWithTime:model.IssueTime beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"yy/MM/dd"];
    self.hourLab.text =[Units timeWithTime:model.IssueTime beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"HH:mm"];
    self.nameLab.text =[NSString stringWithFormat:@"%@-%@",model.DepName,model.OperCreateUserName];
    self.codeLab.text = model.TaskCode;
    self.typeLab.text =model.MaintainFaultName;
    self.progressLab.text =model.TaskStatusName;
    self.materialNameLab.text =model.FacilityName;
    NSString * str =nil;
    self.timeLab.text = [NSString stringWithFormat:@"距离开单时间:%@",[self delayTime:model.IssueTime andEndTime:str]];
    self.countLab.text = [NSString stringWithFormat:@"%ld/%ld",rowIdx+1,datasource.count];
}

-(void)setFrame:(CGRect)frame{
    frame.origin.x +=5.0f;
    frame.size.width -= 10.0f;
    [super setFrame:frame];
}
@end
