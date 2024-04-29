//
//  DEPauseTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/6/1.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEPauseTableCell.h"

@implementation DEPauseTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel * tipLab = [[UILabel alloc]init];
        tipLab.font = [UIFont systemFontOfSize:15];
        [tipLab sizeToFit];
        _tipLab = tipLab;
        [self.contentView addSubview:tipLab];
        [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(8);
            make.centerY.mas_equalTo(self.contentView);
            make.width.mas_equalTo(100);
        }];
        UITextField * textF = [[UITextField alloc]init];
        textF.font = [UIFont systemFontOfSize:15];
        _inputTextField = textF;
        [self.contentView addSubview:textF];
        [textF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(tipLab.mas_right).mas_offset(6);
            make.centerY.mas_equalTo(self.contentView);
            make.right.mas_offset(-8);
            make.height.mas_equalTo(35);
        }];
        UIView * bottomLine =[[UIView alloc]init];
        bottomLine.backgroundColor = RGBA(242, 242, 242, 1);
        [self.contentView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(2);
            make.right.mas_offset(-2);
            make.bottom.mas_offset(0);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}
@end
