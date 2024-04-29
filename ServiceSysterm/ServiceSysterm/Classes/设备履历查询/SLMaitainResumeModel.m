//
//  SLMaitainResumeModel.m
//  SLPersonnelSystem
//
//  Created by Andy on 2020/3/19.
//  Copyright © 2020 深圳市深联电路有限公司. All rights reserved.
//

#import "SLMaitainResumeModel.h"

@implementation SLMaitainResumeModel

+(NSDictionary*)mj_objectClassInArray{
    
    return @{ @"list" : [SLResumeListModel class]};
}
@end


