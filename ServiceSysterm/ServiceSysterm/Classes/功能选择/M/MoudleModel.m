//
//  MoudleModel.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/25.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "MoudleModel.h"

@implementation MoudleModel

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.ModulesList forKey:@"ModulesList"];
    [aCoder encodeObject:self.BaseMsg forKey:@"BaseMsg"];
    [aCoder encodeObject:self.FactoryList forKey:@"FactoryList"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.ModulesList = [aDecoder decodeObjectForKey:@"ModulesList"];
        self.BaseMsg = [aDecoder decodeObjectForKey:@"BaseMsg"];
        self.FactoryList  =[aDecoder decodeObjectForKey:@"FactoryList"];
    }
    return self;
}


@end
