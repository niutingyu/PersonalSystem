//
//  GarbageNameTableViewCell.m
//  ServiceSysterm
//
//  Created by Andy on 2021/8/19.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "GarbageNameTableViewCell.h"
#import "GarbageOrdrModel.h"

@interface GarbageNameTableViewCell ()



@property (nonatomic,strong)UILabel *titleLab;

@property (nonatomic,strong)UITextField *contentTextf;


@end
@implementation GarbageNameTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.matalTextf.userInteractionEnabled  =NO;
    self.nameTextf.userInteractionEnabled  =NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }return self;
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
    }];
    
    UITextField *contentTextf  =[[UITextField alloc]init];
    contentTextf.font  =[UIFont systemFontOfSize:14];
    self.contentTextf  =contentTextf;
    [self.contentView addSubview:contentTextf];
    [contentTextf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLab.mas_right).mas_offset(8);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(38);
        make.right.mas_offset(-16);
    }];
}

-(void)configGarbageNameCellWithIdx:(NSInteger)idx nameList:(NSMutableArray*)nameList{
    GarbageNameModel *model  = nameList[idx-1];
    
    self.nameLab.text  = model.materName;
    
    self.matalLab.text  =model.matal;
   
    self.countLab.text  = model.count;
    self.nameTextf.placeholder  =[NSString stringWithFormat:@"请选择%@",model.materName];
    self.matalTextf.placeholder  =@"该物品的参考金属";
    self.countTextf.placeholder  =@"请输入数量";
    self.nameTextf.text  = model.nameContent;
    self.matalTextf.text =model.matalContent;
    self.countTextf.text =model.countContent;
    
//    self.contentTextf.placeholder  = model.place;
//    self.contentTextf.text  =model.content;
    
}
@end
