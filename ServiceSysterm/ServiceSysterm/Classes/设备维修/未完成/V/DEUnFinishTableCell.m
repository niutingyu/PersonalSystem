//
//  DEUnFinishTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/7.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEUnFinishTableCell.h"

@implementation DEUnFinishTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius =3.0f;
    self.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)configureCell:(DEUnfinishModel*)model datasource:(NSMutableArray*)datasource idx:(NSInteger)idx{
    _monthLab.text = [Units timeWithTime:model.IssueTime beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"yy/MM/dd"];
    _hourLab.text = [Units timeWithTime:model.IssueTime beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"HH:mm"];
    _titleNameLab.text  = [NSString stringWithFormat:@"%@-%@",model.DepName,model.OperCreateUserName];
    _orderNumberLab.text = model.TaskCode;
    _deviceTypeLab.text = model.MaintainFaultName;
    _deviceNameLab.text = model.FacilityName;
    _statusLab.text = model.TaskStatusName;
    
    _beginedTimeLab.text = [NSString stringWithFormat:@"距离开单时间:%@",[self delayTime:model.IssueTime andEndTime:nil]];
    _finishProgressLab.text = [NSString stringWithFormat:@"%ld/%ld",idx+1,datasource.count];
}
-(void)setFrame:(CGRect)frame{
    frame.origin.x +=5.0f;
    frame.size.width -=10.0f;
    [super setFrame:frame];
}
@end
