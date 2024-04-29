//
//  GarbageListTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2021/8/23.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "GarbageListTableCell.h"

@implementation GarbageListTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModel:(GarbageListModel *)model{
    _model  =model;
    self.nameContentLab.text = model.Name;
    self.codeContentLab.text =model.Code;
    self.typeContentLab.text  =model.Type;
    self.countContentLab.text  =[NSString stringWithFormat:@"%@(%@)",model.Count,model.Pieces];
    NSString *concentStr;
    if (model.Concentration.length  ==0) {
        concentStr =@"暂无";
    }else{
        concentStr  =[NSString stringWithFormat:@"百分之%@",model.Concentration];
    }
    self.ConcentContentLab.text  =concentStr;
    
    
}
@end
