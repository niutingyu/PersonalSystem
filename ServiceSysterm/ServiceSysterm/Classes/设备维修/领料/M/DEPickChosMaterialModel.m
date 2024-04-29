//
//  DEPickChosMaterialModel.m
//  ServiceSysterm
//
//  Created by Andy on 2019/5/8.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "DEPickChosMaterialModel.h"

@implementation DEPickChosMaterialModel
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.ArticalCode forKey:@"ArticalCode"];
    [aCoder encodeObject:self.ArticalId forKey:@"ArticalId"];
    [aCoder encodeObject:self.ArticalName forKey:@"ArticalName"];
    [aCoder encodeObject:self.CountAll forKey:@"CountAll"];
    [aCoder encodeObject:self.DefaultStoreName forKey:@"DefaultStoreName"];
    [aCoder encodeObject:self.DefaultStore forKey:@"DefaultStore"];
    [aCoder encodeObject:self.FactoryId forKey:@"FactoryId"];
    [aCoder encodeObject:self.FactoryName forKey:@"FactoryName"];
    [aCoder encodeObject:self.ImgPath forKey:@"ImgPath"];
    [aCoder encodeObject:self.MaterialClassCode forKey:@"MaterialClassCode"];
    [aCoder encodeObject:self.MaterialClassId forKey:@"MaterialClassId"];
    [aCoder encodeObject:self.MaterialClassName forKey:@"MaterialClassName"];
    [aCoder encodeObject:self.MaterialCode forKey:@"MaterialCode"];
    [aCoder encodeObject:self.MaterialGroupCode forKey:@"MaterialGroupCode"];
    [aCoder encodeObject:self.MaterialGroupName forKey:@"MaterialGroupName"];
    [aCoder encodeObject:self.MaterialId forKey:@"MaterialId"];
    [aCoder encodeObject:self.MaterialInfo forKey:@"MaterialInfo"];
    [aCoder encodeObject:self.MaterialName forKey:@"MaterialName"];
    [aCoder encodeObject:self.MinPurchaseQuantity forKey:@"MinPurchaseQuantity"];
    [aCoder encodeObject:self.PackageUnit forKey:@"PackageUnit"];
    [aCoder encodeObject:self.PurchaseCycle forKey:@"PurchaseCycle"];
    [aCoder encodeObject:self.PurchaseNum forKey:@"PurchaseNum"];
    [aCoder encodeObject:self.PurchaseUnitId forKey:@"PurchaseUnitId"];
    [aCoder encodeObject:self.Requirement forKey:@"Requirement"];
    [aCoder encodeObject:self.Scale forKey:@"Scale"];
    [aCoder encodeObject:self.StockNum forKey:@"StockNum"];
    [aCoder encodeObject:self.StockPurchaseRatio forKey:@"StockPurchaseRatio"];
    [aCoder encodeObject:self.StockUnitId forKey:@"StockUnitId"];
    [aCoder encodeObject:self.UnitInventoryName forKey:@"UnitInventoryName"];
    [aCoder encodeObject:self.UnitPurchaseName forKey:@"UnitPurchaseName"];
    [aCoder encodeObject:self.Remark forKey:@"Remark"];
    [aCoder encodeObject:self.applyCount forKey:@"applyCount"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.ArticalCode = [aDecoder decodeObjectForKey:@"ArticalCode"];
        self.ArticalId = [aDecoder decodeObjectForKey:@"ArticalId"];
        self.ArticalName = [aDecoder decodeObjectForKey:@"ArticalName"];
        self.CountAll = [aDecoder decodeObjectForKey:@"CountAll"];
        self.DefaultStore = [aDecoder decodeObjectForKey:@"DefaultStore"];
        self.DefaultStoreName  = [aDecoder decodeObjectForKey:@"DefaultStoreName"];
        self.FactoryId = [aDecoder decodeObjectForKey:@"FactoryId"];
        self.FactoryName = [aDecoder decodeObjectForKey:@"FactoryName"];
        self.ImgPath = [aDecoder decodeObjectForKey:@"ImgPath"];
        self.MaterialClassCode = [aDecoder decodeObjectForKey:@"MaterialClassCode"];
        self.MaterialClassId = [aDecoder decodeObjectForKey:@"MaterialClassId"];
        self.MaterialClassName = [aDecoder decodeObjectForKey:@"MaterialClassName"];
        self.MaterialCode = [aDecoder decodeObjectForKey:@"MaterialCode"];
        self.MaterialGroupCode = [aDecoder decodeObjectForKey:@"MaterialGroupCode"];
        self.MaterialGroupName = [aDecoder decodeObjectForKey:@"MaterialGroupName"];
        self.MaterialId = [aDecoder decodeObjectForKey:@"MaterialId"];
        self.MaterialInfo = [aDecoder decodeObjectForKey:@"MaterialInfo"];
        self.MaterialName = [aDecoder decodeObjectForKey:@"MaterialName"];
        self.MinPurchaseQuantity = [aDecoder decodeObjectForKey:@"MinPurchaseQuantity"];
        self.PackageUnit = [aDecoder decodeObjectForKey:@"PackageUnit"];
        self.PurchaseCycle = [aDecoder decodeObjectForKey:@"PurchaseCycle"];
        self.PurchaseNum = [aDecoder decodeObjectForKey:@"PurchaseNum"];
        self.PurchaseUnitId = [aDecoder decodeObjectForKey:@"PurchaseUnitId"];
        self.Requirement = [aDecoder decodeObjectForKey:@"Requirement"];
        self.Scale = [aDecoder decodeObjectForKey:@"Scale"];
        self.StockNum = [aDecoder decodeObjectForKey:@"StockNum"];
        self.StockPurchaseRatio = [aDecoder decodeObjectForKey:@"StockPurchaseRatio"];
        self.StockUnitId = [aDecoder decodeObjectForKey:@"StockUnitId"];
        self.UnitPurchaseName = [aDecoder decodeObjectForKey:@"UnitPurchaseName"];
        self.UnitInventoryName = [aDecoder decodeObjectForKey:@"UnitInventoryName"];
        self.Remark = [aDecoder decodeObjectForKey:@"Remark"];
        self.applyCount = [aDecoder decodeObjectForKey:@"applyCount"];
    }return self;
}
@end
