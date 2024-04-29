//
//  DEMemberTableViewCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/8.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEMemberTableViewCell.h"

@implementation DEMemberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.nameButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    self.nameButton.tag = 1000;
    [self.statusButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    self.statusButton.tag = 1001;
    [self.telphoneButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    self.telphoneButton.tag = 1002;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(DEMemberModel *)model{
    _model =model;
    [_nameButton setTitle:model.FName forState:UIControlStateNormal];
    [_statusButton setTitle:model.TaskFlag forState:UIControlStateNormal];
    
}
-(void)clickButton:(UIButton*)sender{
    if (self.buttonBlock) {
        self.buttonBlock(sender.tag);
    }
}
@end
