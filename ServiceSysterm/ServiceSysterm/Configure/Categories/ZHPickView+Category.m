//
//  ZHPickView+Category.m
//  ServiceSysterm
//
//  Created by Andy on 2020/3/12.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "ZHPickView+Category.h"
#import <objc/runtime.h>
static void *FlagKey =&FlagKey;
@implementation ZHPickView (Category)


-(void)setFlag:(NSInteger)flag{
    objc_setAssociatedObject(self, FlagKey, @(flag), 3);
}
-(NSInteger)flag{
    return [objc_getAssociatedObject(self, FlagKey)  integerValue];
}
@end
