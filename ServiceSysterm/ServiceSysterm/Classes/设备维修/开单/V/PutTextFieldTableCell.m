//
//  PutTextFieldTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/6/15.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "PutTextFieldTableCell.h"

@implementation PutTextFieldTableCell

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
        [self setupTextField];
    }return self;
}
-(void)setupTextField{
    PlaceholderTextView * textViewP =[[PlaceholderTextView alloc]init];
    textViewP.placeholder =@"请输入备注";
    _placeTextView = textViewP;
    [self.contentView addSubview:textViewP];
    [textViewP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(8);
        make.top.mas_offset(8);
        make.right.mas_offset(8);
        make.bottom.mas_offset(8);
    }];
}
@end
