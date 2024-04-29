//
//  DEWholeChosFactoryTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2020/7/15.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "DEWholeChosFactoryTableCell.h"
#import "MoudleModel.h"
@implementation DEWholeChosFactoryTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //取出工厂
    NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"functionModel"];
    MoudleModel * moudleStatus = [modleArchiver decodeObjectForKey:Function_WriteDisk];
    [modleArchiver finishDecoding];
    self.chosFactoryText.userInteractionEnabled  =NO;
    if (moudleStatus.FactoryList.count >0 ) {
        self.chosFactoryText.text  =moudleStatus.FactoryList[0][@"FactoryName"];
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
