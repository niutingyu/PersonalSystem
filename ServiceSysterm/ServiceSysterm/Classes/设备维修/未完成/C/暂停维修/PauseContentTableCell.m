//
//  PauseContentTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/8/10.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "PauseContentTableCell.h"

@implementation PauseContentTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentText.layer.borderWidth =1;
    self.contentText.layer.borderColor = RGBA(245, 245, 245, 1).CGColor;
    self.contentText.layer.cornerRadius =3;
    self.contentText.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
