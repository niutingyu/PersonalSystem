//
//  MCDetailExtendSchudleTableCell.m
//  ServiceSysterm
//
//  Created by Andy on 2020/10/30.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "MCDetailExtendSchudleTableCell.h"

@implementation MCDetailExtendSchudleTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.swithBut addTarget:self action:@selector(swithcMethod) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)swithcMethod{
    debugLog(@"=====");
}
@end
