//
//  HandleTableViewCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/7/18.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "HandleTableViewCell.h"

@implementation HandleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)congigureCellContent:(HandleTaskModel*)model rows:(NSInteger)rows models:(NSMutableArray*)models{
    self.dateLabel.text = [Units timeWithTime:model.issueTime beforeFormat:@"yyyy-MM-dd HH:mm:ss" andAfterFormat:@"yy/MM/dd"];
    self.timeLabel.text =[Units timeWithTime:model.issueTime beforeFormat:@"yyyy-MM-dd" andAfterFormat:@"HH:mm"];
    self.handLabel.text = model.operCreateUser;
    self.codeLabel.text = model.taskCode;
    self.departmentLabel.text = model.dpartName;
    self.checkLabel.text = model.taskStatus;
    self.companyLabel.text = [NSString stringWithFormat:@"%@-%@",model.dpartName,model.operCreateUser];
    NSString * string =nil;
    self.TTLabel.text = [NSString stringWithFormat:@"距离开单时间:%@",[Units delayTime:model.issueTime andEndTime:string]];
    self.countLabel.text = [NSString stringWithFormat:@"%ld/%ld",rows+1,models.count];
}

-(void)setFrame:(CGRect)frame{
    frame.origin.x +=5.0f;
    frame.size.width -=10.0f;
    [super setFrame:frame];
}
@end
