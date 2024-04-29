//
//  RevisePassWordTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "RevisePassWordTableCell.h"

@implementation RevisePassWordTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }return self;
}
-(void)setupUI{
    UILabel * tipLabel = [[UILabel alloc]init];
    tipLabel.font = [UIFont systemFontOfSize:16.0f];
    [tipLabel sizeToFit];
    _tipLab = tipLabel;
    [self.contentView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(20);
    }];
    UITextField * inputTextField = [[UITextField alloc]init];
    inputTextField.textAlignment = NSTextAlignmentCenter;
    inputTextField.font =[UIFont systemFontOfSize:14];
    _inputTextField = inputTextField;
    [self.contentView addSubview:inputTextField];
    [inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tipLabel).mas_offset(6);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-8);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(30);
    }];
}
@end
