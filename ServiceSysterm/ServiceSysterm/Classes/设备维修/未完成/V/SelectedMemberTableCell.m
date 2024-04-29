//
//  SelectedMemberTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/30.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "SelectedMemberTableCell.h"

@implementation SelectedMemberTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_selectedButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)buttonClick:(UIButton*)sender{
    if (self.selectedItemBlock) {
        self.selectedItemBlock(sender);
    }
}
@end
