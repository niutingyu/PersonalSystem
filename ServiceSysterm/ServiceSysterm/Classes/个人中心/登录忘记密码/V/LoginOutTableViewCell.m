//
//  LoginOutTableViewCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/24.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "LoginOutTableViewCell.h"

@implementation LoginOutTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)loginOut:(id)sender {
    if (self.loginout) {
        self.loginout();
    }
}

@end
