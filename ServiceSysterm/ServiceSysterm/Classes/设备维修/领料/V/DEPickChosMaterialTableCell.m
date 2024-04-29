//
//  DEPickChosMaterialTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/8.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEPickChosMaterialTableCell.h"

@implementation DEPickChosMaterialTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(DEPickChosMaterialModel *)model{
    _model = model;
    self.titleLab.text = model.MaterialName;
    self.typeLab.text = model.MaterialInfo;
    self.countLab.text = [NSString stringWithFormat:@"可用数量:%@",model.CountAll];

}
- (IBAction)click:(UIButton *)sender {
   // sender.selected =! sender.selected;
    if (self.selectedBlock) {
        self.selectedBlock(sender);
    }
}
@end
