//
//  MTFootAddView.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "MTFootAddView.h"

@implementation MTFootAddView

-(void)awakeFromNib{
    [super awakeFromNib];
    _addButton.layer.cornerRadius = 3.0f;
    _addButton.clipsToBounds = YES;
    [_addButton addTarget:self action:@selector(addMaterial) forControlEvents:UIControlEventTouchUpInside];
}
-(void)addMaterial{
    if (self.addMaterialBlock) {
        self.addMaterialBlock();
    }
}
@end
