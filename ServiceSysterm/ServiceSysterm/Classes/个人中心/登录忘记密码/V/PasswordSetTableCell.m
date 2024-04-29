//
//  PasswordSetTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/6/22.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "PasswordSetTableCell.h"

@implementation PasswordSetTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.vertifryButton.layer.cornerRadius = 3;
    self.vertifryButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)veritify:(JKCountDownButton*)sender {
    if (self.vertifyBlock) {
        self.vertifyBlock(sender);
    }
}

@end
