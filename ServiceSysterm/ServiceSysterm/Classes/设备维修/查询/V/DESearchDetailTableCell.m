//
//  DESearchDetailTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/20.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DESearchDetailTableCell.h"

@implementation DESearchDetailTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius =3.0f;
    self.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)confgiureCell:(DESortDetailMessageModel*)model rowIdx:(NSInteger)rowIdx datasource:(NSMutableArray*)datasource{
    _monthLab.text = [Units timeWithTime:model.IssueTime beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"yy/MM/dd"];
    _hourLab.text =[Units timeWithTime:model.IssueTime beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"HH:mm"];
    _nameLab.text =[NSString stringWithFormat:@"%@-%@",model.DepName,model.OperCreateUserName];
    _codeNumberLab.text =model.TaskCode;
    _materialNameLab.text = model.MaintainFaultName;
    _facilityNameLab.text = model.FacilityName;
    _stateLab.text =model.TaskStatusName;
    _countLab.text = [NSString stringWithFormat:@"%ld/%ld",rowIdx+1,datasource.count];
}
-(void)setFrame:(CGRect)frame{
    frame.origin.x +=5;
    frame.size.width -=10;
    [super setFrame:frame];
}
@end
