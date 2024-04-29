//
//  ProfileTableHeadView.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/24.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "ProfileTableHeadView.h"

@implementation ProfileTableHeadView

-(void)awakeFromNib{
    [super awakeFromNib];
    _nameLab.text = USERDEFAULT_object(CodeName)?:@"";
    _mobileLab.text = USERDEFAULT_object(@"phone")?:@"";
    
}

@end
