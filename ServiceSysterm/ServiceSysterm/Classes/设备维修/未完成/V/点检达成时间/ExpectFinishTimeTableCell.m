//
//  ExpectFinishTimeTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/8/8.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "ExpectFinishTimeTableCell.h"

@implementation ExpectFinishTimeTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contentText.layer.borderWidth = 0.5;
    self.contentText.layer.cornerRadius = 3;
    self.contentText.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
