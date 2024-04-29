//
//  GarbageOrderHeadTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2021/8/19.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "GarbageOrderHeadTableCell.h"
#import "GarbageOrdrModel.h"

@interface GarbageOrderHeadTableCell ()






@end
@implementation GarbageOrderHeadTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self  =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}


-(void)setupUI{
    
    
    UILabel * titleLab  =[[UILabel alloc]init];
    titleLab.font  =[UIFont systemFontOfSize:16];
    [titleLab sizeToFit];
    self.titleLab  =titleLab;
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(21);
       // make.width.mas_equalTo(75);
    }];
    
    UITextField *contentTextf  =[[UITextField alloc]init];
    contentTextf.font  =[UIFont systemFontOfSize:14];
    contentTextf.userInteractionEnabled  =NO;
    contentTextf.textAlignment  =NSTextAlignmentCenter;
    self.contentTextf  =contentTextf;
    [self.contentView addSubview:contentTextf];
    [contentTextf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLab.mas_right).mas_offset(8);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(38);
        make.right.mas_offset(-16);
    }];
}

-(void)configHeadCellWithIdx:(NSInteger)idx orderList:(NSMutableArray*)orderList{
    GarbageOrdrModel * model  = orderList[idx];
    
    self.titleLab.text =model.name;
    self.contentTextf.placeholder  =model.place;
    self.contentTextf.text  = model.content;
    
}
@end
