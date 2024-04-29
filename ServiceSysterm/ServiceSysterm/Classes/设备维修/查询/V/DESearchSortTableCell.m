//
//  DESearchSortTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/18.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DESearchSortTableCell.h"

@implementation DESearchSortTableCell

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



-(void)configureCell:(DESortModel*)model rowIdx:(NSInteger)rowIdx datasource:(NSMutableArray*)datasource{
    _monthLab.text = [Units timeWithTime:model.RecordDate beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"yy/MM/dd"];
    _hourLab.text =[Units timeWithTime:model.RecordDate beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"HH:mm"];
    _namLab.text =model.FName;
    _numberLab.text =model.TaskCode;
    _sortLab.text =[NSString stringWithFormat:@"得分:%@/%@",model.Scored,model.PerformanceGoal];
    _typeLab.text = model.CheckProgram;
    _materialNameLab.text = model.FacilityName;
    NSString * typeStr;
    if ([model.CheckProgram isEqualToString:@"点检得分"]||[model.CheckProgram isEqualToString:@"保养得分"]) {
        typeStr =@"漏失点数";
    }else{
        typeStr =@"超出单数";
    }
    _errorLab.text =[NSString stringWithFormat:@"%@:%@",typeStr,model.Amount];
    _countLab.text =[NSString stringWithFormat:@"%ld/%ld",rowIdx,datasource.count];
}
-(void)setFrame:(CGRect)frame{
    frame.origin.x +=5;
    frame.size.width -=10;
    [super setFrame:frame];
}
@end
