//
//  DESearchView.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/7.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DESearchView.h"

@implementation DESearchView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = RGBA(98, 130, 224, 2);
    self.searchContentTextField.layer.cornerRadius = 3;
    self.searchContentTextField.clipsToBounds = YES;
    [self.searchButton addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
   
}

-(void)search:(UIButton*)sender{
    if (self.searchBlock) {
        self.searchBlock();
    }
    
}

@end
