//
//  UserModel.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/25.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.jobName forKey:@"jobName"];
    [aCoder encodeObject:self.jobNum forKey:@"jobNum"];
    [aCoder encodeObject:self.emailAddress forKey:@"emailAddress"];
    [aCoder encodeObject:self.userMobile forKey:@"userMobile"];
    [aCoder encodeObject:self.userShortMobile forKey:@"userShortMobile"];
    [aCoder encodeObject:self.privilegeArray forKey:@"privilegeArray"];
    [aCoder encodeObject:self.frequentlyArray forKey:@"frequentlyArray"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.jobName = [aDecoder decodeObjectForKey:@"jobName"];
        self.jobNum = [aDecoder decodeObjectForKey:@"jobNum"];
        self.emailAddress = [aDecoder decodeObjectForKey:@"emailAddress"];
        self.userMobile = [aDecoder decodeObjectForKey:@"userMobile"];
        self.userShortMobile = [aDecoder decodeObjectForKey:@"userShortMobile"];
        self.privilegeArray = [aDecoder decodeObjectForKey:@"privilegeArray"];
        self.frequentlyArray = [aDecoder decodeObjectForKey:@"frequentlyArray"];
    }
    return self;
}
@end
