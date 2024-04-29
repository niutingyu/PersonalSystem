//
//  BaseTableViewCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/24.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

//距离现在的时间
- (NSString *)delayTime:(NSString*)time andEndTime:(NSString * )endTime {
    NSDate *date ;
    NSString *str =nil;
    if (endTime == nil) {
        date =[NSDate date];
    }else{
        
        date = [Units dataFromString:endTime withFormat:str];
        
    }
    NSTimeInterval now = [date timeIntervalSince1970];
    NSTimeInterval before = [[Units dataFromString:time withFormat:str] timeIntervalSince1970];
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
//转换时间
-(NSString*)transferTime:(NSString*)timeString{
     int l = [timeString intValue];
    NSString *hour = [NSString stringWithFormat:@"%d",l/3600];
    NSString *second = [NSString stringWithFormat:@"%d",l%60];
    if (l/3600 < 10) {
        hour = [NSString stringWithFormat:@"0%@",hour];
    }
    if (l%60 < 10) {
        second = [NSString stringWithFormat:@"0%@",second];
    }
    return [NSString stringWithFormat:@"%@时%@分",hour,second];
}
@end
