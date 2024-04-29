//
//  WasterTaskListTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2021/8/23.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "WasterTaskListTableCell.h"

@implementation WasterTaskListTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)configureTaskListCellWithModel:(WasterTaskListModel*)model idx:(NSInteger)indx count:(NSInteger)count{
    self.dateLab.text =[Units timeWithTime:model.CreatedOn beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"yy/MM/dd"];
    self.timeLab.text  =[Units timeWithTime:model.CreatedOn beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"HH:mm"];
    self.typeLab.text  = model.FName;
    
    self.numberLab.text  =model.Code;
    self.departmentLab.text  =model.Remark?:@"暂无";
    self.statusLab.text  =model.flowStautsStr;
    
    self.visitorLab.text  =[NSString stringWithFormat:@"%@-%@-%@",model.Name,model.SettleType,model.PayType];
    self.duratationLab.text  =[NSString stringWithFormat:@"距离开单时间:%@",[self delayTime:model.CreatedOn andEndTime:[Units currentTimeWithFormat:@"yyyy-MM-dd HH:mm:ss"]]];
    self.countLab.text  =[NSString stringWithFormat:@"%ld/%ld",indx+1,count];
    
}

- (NSString *)delayTime:(NSString *)time andEndTime:(NSString *)endTime {
    NSDate *date;
    if (endTime == nil) {
        date =[NSDate date];
    }else{
        date =[Units dataFromString:endTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSTimeInterval now = [date timeIntervalSince1970];
    NSTimeInterval before = [[Units dataFromString:time withFormat:@"yyyy-MM-dd HH:mm:ss"] timeIntervalSince1970];
    NSTimeInterval cha = now - before;
    long l = cha;
    NSString *hour = [NSString stringWithFormat:@"%ld",l/3600];
    NSString *second = [NSString stringWithFormat:@"%ld",l%3600/60];
    if (l/3600 < 10) {
        hour = [NSString stringWithFormat:@"0%@",hour];
    }
    if (l%3600/60 < 10) {
        second = [NSString stringWithFormat:@"0%@",second];
    }
    
    return [NSString stringWithFormat:@"%@时%@分",hour,second];
}
@end
