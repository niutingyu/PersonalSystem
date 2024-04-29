//
//  IqcBugModel.m
//  ServiceSysterm
//
//  Created by Andy on 2021/7/10.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "IqcBugModel.h"

@implementation IqcBugModel


-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    _methodStr =_methodStr?_methodStr:@"";
}


@end

@implementation IqcTreatmentModel



@end
