//
//  WasterInformationTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2021/8/20.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "WasterInformationTableCell.h"
#import "WasterAddInforModel.h"
@implementation WasterInformationTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)configureCellWithIdx:(NSString*)idx list:(NSMutableArray*)informationList row:(NSInteger)indxRow{
    
    WasterAddInforModel *model  = informationList[indxRow];
    if ([model.type isEqualToString:@"物品类别"]||[model.type isEqualToString:@"参考金属"]||[model.type isEqualToString:@"付款方式"]||[model.type isEqualToString:@"结算方式"]||[model.type isEqualToString:@"是否管控"]) {
        self.contentTextf.userInteractionEnabled  =NO;
        self.contentTextf.inputView  =[[UIView alloc]init];
    }else{
        if ([model.type isEqualToString:@"联系方式"]) {
            self.contentTextf.keyboardType  =UIKeyboardTypeNumberPad;
        }
        self.contentTextf.userInteractionEnabled  =YES;
    }
    self.titleLab.text  =model.type;
    self.contentTextf.placeholder  = model.place;
    self.contentTextf.text  =model.content;
    
}
@end
