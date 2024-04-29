//
//  ApplyAcceptanceProgressTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/8/9.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "ApplyAcceptanceProgressTableCell.h"

@implementation ApplyAcceptanceProgressTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentTextView.layer.borderWidth =1;
    self.contentTextView.layer.borderColor = RGBA(242, 242, 242, 1).CGColor;
    self.contentTextView.layer.cornerRadius =3;
    self.contentTextView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
