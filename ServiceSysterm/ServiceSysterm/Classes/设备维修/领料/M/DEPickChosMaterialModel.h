//
//  DEPickChosMaterialModel.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/8.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DEPickChosMaterialModel : NSObject<NSCoding>
@property (nonatomic,copy)NSString *ArticalCode;
@property (nonatomic,copy)NSString *ArticalId;
@property (nonatomic,copy)NSString *ArticalName;
@property (nonatomic,copy)NSString *CountAll;
@property (nonatomic,copy)NSString *DefaultStore;
@property (nonatomic,copy)NSString *DefaultStoreName;
@property (nonatomic,copy)NSString *FactoryId;
@property (nonatomic,copy)NSString *FactoryName;
@property (nonatomic,copy)NSString *ImgPath;
@property (nonatomic,copy)NSString *MaterialClassCode;
@property (nonatomic,copy)NSString *MaterialClassId;
@property (nonatomic,copy)NSString *MaterialClassName;
@property (nonatomic,copy)NSString *MaterialCode;
@property (nonatomic,copy)NSString *MaterialGroupCode;
@property (nonatomic,copy)NSString *MaterialGroupName;
@property (nonatomic,copy)NSString *MaterialId;
@property (nonatomic,copy)NSString *MaterialInfo;
@property (nonatomic,copy)NSString *MaterialName;
@property (nonatomic,copy)NSString *MinPurchaseQuantity;
@property (nonatomic,copy)NSString *PackageUnit;
@property (nonatomic,copy)NSString *PurchaseCycle;
@property (nonatomic,copy)NSString *PurchaseNum;
@property (nonatomic,copy)NSString *PurchaseUnitId;
@property (nonatomic,copy)NSString *Requirement;
@property (nonatomic,copy)NSString *Scale;
@property (nonatomic,copy)NSString *StockNum;
@property (nonatomic,copy)NSString *StockPurchaseRatio;
@property (nonatomic,copy)NSString *StockUnitId;
@property (nonatomic,copy)NSString *UnitInventoryName;
@property (nonatomic,copy)NSString *UnitPurchaseName;
@property (nonatomic,copy)NSString *Remark; // 备注
@property (nonatomic,copy)NSString * applyCount;

@property (copy,nonatomic)NSString * applyNumber;//申请数量




@end

NS_ASSUME_NONNULL_END
