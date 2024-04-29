//
//  SLMaintainResumeCell.m
//  SLPersonnelSystem
//
//  Created by Andy on 2020/3/19.
//  Copyright © 2020 深圳市深联电路有限公司. All rights reserved.
//

#import "SLMaintainResumeCell.h"

@implementation SLMaintainResumeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 3;
    self.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(SLResumeListModel *)model{
    _model =model;
    //保养类型
    _orderType.text = model.MaintType?:@"";
    /**
     单据时间
     */
    _maintainTime.text = model.IssueTime?:@"";
    /**
     操作人
     */
    _operationName.text = [NSString stringWithFormat:@"操作人:%@",model.FName?:@""];
    /**
     单号
     */
    _orderNumber.text =[NSString stringWithFormat:@"单号:%@",model.TaskCode?:@""];
    /**
     问题
     */
    _issueLabel.text =[NSString stringWithFormat:@"问题:%@",model.FaultReasonName?:@"无"];
    /**
     更换配件
     */
    _changeDeviceLabel.text =[NSString stringWithFormat:@"更换配件:%@",model.MaterialName?:@"无"];
    /**
     状态
     */
    _orderStatus.text = model.TaskStatusName?:@"";
    /**
     改变字号
     */
    /**
     操作人
     */
    _operationName.attributedText = [Units changeLabel:@"操作人" wholeString:_operationName.text font:[UIFont systemFontOfSize:16] color:[UIColor blackColor]];
    /**
     单号
     */
    _orderNumber.attributedText =[Units changeLabel:@"单号" wholeString:_orderNumber.text font:[UIFont systemFontOfSize:16] color:[UIColor blackColor]];
    /**
     问题
     */
    _issueLabel.attributedText =[Units changeLabel:@"问题" wholeString:_issueLabel.text font:[UIFont systemFontOfSize:16] color:[UIColor blackColor]];
    /**
     更换配件
     */
    _changeDeviceLabel.attributedText =[Units changeLabel:@"更换配件" wholeString:_changeDeviceLabel.text font:[UIFont systemFontOfSize:16] color:[UIColor blackColor]];
  
}
-(void)setFrame:(CGRect)frame{
    frame.origin.x += 6.0f;
    frame.size.width -=12.0f;
    [super setFrame:frame];
}
@end
