//
//  DESearchRankTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/18.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DESearchRankTableCell.h"

@implementation DESearchRankTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(DERankModel *)model{
    _model =model;
    _titleNameLab.text = [NSString stringWithFormat:@"%@(%@)",model.FName,model.UserName];
    _rankLab.text =[NSString stringWithFormat:@"排名:%@-%@",model.Ranking,model.DistrictName?:@""];
    _countLab.text =[NSString stringWithFormat:@"总维修数:%@",model.SumMain];
    
    _maintainTimeLab.text =[NSString stringWithFormat:@"平均维修时间:%@",[self transferTime:model.Maintime]];
    //qiege排名字符串
    NSArray * arr =[_rankLab.text componentsSeparatedByString:@":"];
    _rankLab.attributedText = [Units changeLabel:[arr lastObject] wholeString:_rankLab.text];
}
@end
