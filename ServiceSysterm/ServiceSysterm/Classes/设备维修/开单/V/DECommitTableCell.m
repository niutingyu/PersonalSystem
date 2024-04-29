//
//  DECommitTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/6.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DECommitTableCell.h"

@implementation DECommitTableCell

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
        self.backgroundColor = RGBA(242, 242, 242, 1);
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    UIButton * commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    commitButton.layer.cornerRadius =20;
    commitButton.clipsToBounds =YES;
    commitButton.layer.borderColor =[UIColor lightGrayColor].CGColor;
    commitButton.layer.borderWidth =0.5;
    commitButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    //commitButton.backgroundColor = RGBA(139, 58, 58, 1.0);
    commitButton.backgroundColor  =RGBA(242, 242, 242, 1);
    
    [commitButton addTarget:self action:@selector(commitData) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:commitButton];
    [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-8);
        make.height.mas_equalTo(48);
      
        
    }];
}

-(void)commitData{
    if (self.commitMessage) {
        self.commitMessage();
    }
}
@end
