//
//  SLResumeBasicMessageCell.m
//  SLPersonnelSystem
//
//  Created by Andy on 2020/3/19.
//  Copyright © 2020 深圳市深联电路有限公司. All rights reserved.
//

#import "SLResumeBasicMessageCell.h"

@implementation SLResumeBasicMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(SLMaitainResumeModel *)model{
    _model =model;
    
   
    /**
     设备编号
     */
    _deviceCode.text = [NSString stringWithFormat:@"设备编号:%@",model.FacilityCode?:@""];
    /**
     设备名称
     */
    _deviceName.text =[NSString stringWithFormat:@"设备名称:%@",model.FacilityName?:@""];
    /**
     设备位置
     */
    _deviceLocation.text =[NSString stringWithFormat:@"设备位置:%@",model.StorageLocation?:@""];
    /**
     设备入厂日期
     */
    _deviceEnterTime.text =[NSString stringWithFormat:@"设备入厂日期:%@",model.EnterTime?:@""];
    /**
     最近一次保养时间
     */
    _maitainTime.text =[NSString stringWithFormat:@"最近一次保养时间:%@",model.MaintDate?:@""];
    /**
     下次保养时间
     */
    _nextMaintainTime.text =[NSString stringWithFormat:@"下次计划保养时间:%@",model.NextMaintDate?:@""];
    
   /**
    更换字号
    */
    
    /**
     设备编号
     */
    _deviceCode.attributedText =[Units changeLabel:@"设备编号" wholeString:_deviceCode.text font:[UIFont systemFontOfSize:16] color:[UIColor blackColor]];
    /**
     设备位置
     */
    _deviceLocation.attributedText =[Units changeLabel:@"设备位置" wholeString:_deviceLocation.text font:[UIFont systemFontOfSize:16] color:[UIColor blackColor]];
    /**
     设备名称
     */
    _deviceName.attributedText =[Units changeLabel:@"设备名称" wholeString:_deviceName.text font:[UIFont systemFontOfSize:16] color:[UIColor blackColor]];
    /**
     设备入厂日期
     */
    _deviceEnterTime.attributedText = [Units changeLabel:@"设备入厂日期" wholeString:_deviceEnterTime.text font:[UIFont systemFontOfSize:16] color:[UIColor blackColor]];
    /**
     最近一次保养时间
     */
    _maitainTime.attributedText = [Units changeLabel:@"最近一次保养时间" wholeString:_maitainTime.text font:[UIFont systemFontOfSize:16] color:[UIColor blackColor]];
    /**
     下次计划保养时间
     */
    _nextMaintainTime.attributedText =[Units changeLabel:@"下次计划保养时间" wholeString:_nextMaintainTime.text font:[UIFont systemFontOfSize:16] color:[UIColor blackColor]];
}
@end
