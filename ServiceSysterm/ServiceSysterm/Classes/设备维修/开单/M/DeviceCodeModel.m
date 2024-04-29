//
//  DeviceCodeModel.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/6.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DeviceCodeModel.h"

@implementation DeviceCodeModel
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.FacilityName forKey:@"FacilityName"];
    [aCoder encodeObject:self.FacilityCode forKey:@"FacilityCode"];
    [aCoder encodeObject:self.DistrictName forKey:@"DistrictName"];
    [aCoder encodeObject:self.FacilityId forKey:@"FacilityId"];
    [aCoder encodeObject:self.FacilityDpartName forKey:@"FacilityDpartName"];
    [aCoder encodeObject:self.Lev forKey:@"Lev"];
    [aCoder encodeObject:self.AssociateMaintId forKey:@"AssociateMaintId"];
    [aCoder encodeObject:self.DepName forKey:@"DepName"];
    [aCoder encodeObject:self.TaskCode forKey:@"TaskCode"];
    [aCoder encodeObject:self.RequisitionTypeName forKey:@"RequisitionTypeName"];
    [aCoder encodeObject:self.RequisitionType forKey:@"RequisitionType"];
    [aCoder  encodeObject:self.ActiveFlag forKey:@"ActiveFlag"];
    [aCoder encodeObject:self.AssistantId forKey:@"AssistantId"];
    [aCoder encodeObject:self.AssistantNames forKey:@"AssistantNames"];
    [aCoder encodeObject:self.CreatedBy forKey:@"CreatedBy"];
    [aCoder encodeObject:self.CreatedByName forKey:@"CreatedByName"];
    [aCoder encodeObject:self.CreatedOn forKey:@"CreatedOn"];
    [aCoder encodeObject:self.DepCode forKey:@"DepCode"];
    [aCoder encodeObject:self.Description forKey:@"Description"];
    [aCoder encodeObject:self.FType forKey:@"FType"];
    [aCoder encodeObject:self.FactoryName forKey:@"FactoryName"];
    [aCoder encodeObject:self.ManagerCode forKey:@"ManagerCode"];
    [aCoder encodeObject:self.ManagerId forKey:@"ManagerId"];
    [aCoder encodeObject:self.ManagerName forKey:@"ManagerName"];
    [aCoder encodeObject:self.Name forKey:@"Name"];
    [aCoder encodeObject:self.OrId forKey:@"OrId"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.FacilityName = [aDecoder decodeObjectForKey:@"FacilityName"];
        self.FacilityCode =[aDecoder decodeObjectForKey:@"FacilityCode"];
        self.DistrictName = [aDecoder decodeObjectForKey:@"DistrictName"];
        self.FacilityId = [aDecoder decodeObjectForKey:@"FacilityId"];
        self.FacilityDpartName =[aDecoder decodeObjectForKey:@"FacilityDpartName"];
        self.Lev = [aDecoder decodeObjectForKey:@"Lev"];
        self.AssociateMaintId = [aDecoder decodeObjectForKey:@"AssociateMaintId"];
        self.DepName = [aDecoder decodeObjectForKey:@"DepName"];
        self.TaskCode = [aDecoder decodeObjectForKey:@"TaskCode"];
        self.RequisitionTypeName = [aDecoder decodeObjectForKey:@"RequisitionTypeName"];
        self.RequisitionType = [aDecoder decodeObjectForKey:@"RequisitionType"];
        self.ActiveFlag = [aDecoder decodeObjectForKey:@"ActiveFlag"];
        self.AssistantId = [aDecoder decodeObjectForKey:@"AssistantId"];
        self.AssistantNames = [aDecoder decodeObjectForKey:@"AssistantNames"];
        self.CreatedBy = [aDecoder decodeObjectForKey:@"CreatedBy"];
        self.CreatedByName = [aDecoder decodeObjectForKey:@"CreatedByName"];
        self.CreatedOn = [aDecoder decodeObjectForKey:@"CreatedOn"];
        self.DepCode = [aDecoder decodeObjectForKey:@"DepCode"];
        self.Description = [aDecoder decodeObjectForKey:@"Description"];
        self.FType = [aDecoder decodeObjectForKey:@"FType"];
        self.FactoryName = [aDecoder decodeObjectForKey:@"FactoryName"];
        self.ManagerCode = [aDecoder decodeObjectForKey:@"ManagerCode"];
        self.ManagerId = [aDecoder decodeObjectForKey:@"ManagerId"];
        self.ManagerName =[aDecoder decodeObjectForKey:@"ManagerName"];
        self.Name = [aDecoder decodeObjectForKey:@"Name"];
        self.OrId = [aDecoder decodeObjectForKey:@"OrId"];
    }return self;
}
@end
