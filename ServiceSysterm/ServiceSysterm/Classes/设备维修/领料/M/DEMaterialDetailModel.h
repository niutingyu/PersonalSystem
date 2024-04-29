//
//  DEMaterialDetailModel.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/14.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DEMaterialDetailModel : BaseModel
@property (nonatomic,copy) NSString *MaterialCode;//物料编码
@property (nonatomic,copy) NSString *MaterialName;//物料名称
@property (nonatomic,copy) NSString *MaterialInfo;//String 物料规格
@property (nonatomic,copy) NSString *StockUnit;// String 单位
@property (nonatomic,assign) int CountAll;//Int 库存数量
@property (nonatomic,assign) int ApplyCount;//Int 申请数量
@property (nonatomic,assign) int ActCount; //Int 发放数量
@property (nonatomic,assign) int IsReject;//Int 是否退回（0：否  1：是）
@property (nonatomic,copy)NSString *Barcode;
@property (nonatomic,copy)NSString *BarcodeId;
@property (nonatomic,copy)NSString *MaterialId;
@property (nonatomic,copy)NSString *ShelvesNum;
@property (nonatomic,copy)NSString *SortNum;
@property (nonatomic,copy)NSString *StockCount;
@property (nonatomic,copy)NSString *StockOutId;
@property (nonatomic,copy)NSString *StockOutRecordId;
@property (nonatomic,copy)NSString *StockUnitId;
@property (nonatomic,copy)NSString *StoreId;
@property (nonatomic,copy)NSString *StoreName;
@property (nonatomic,copy)NSString *SupplierId;
@property (nonatomic,copy)NSString *SupplierName;
@property (nonatomic,copy)NSString *UnitName;

@property (nonatomic,copy)NSString *DepId;
@property (nonatomic,copy)NSString *DepName;
@property (nonatomic,copy)NSString *FactoryId;
@property (nonatomic,copy)NSString *FactoryName;
@property (nonatomic,copy)NSString *InstanceId;
@property (nonatomic,copy)NSString *MatRequisitionCode;
@property (nonatomic,copy)NSString *MatRequisitionId;
@property (nonatomic,copy)NSString *ReturnBillId;
@property (nonatomic,copy)NSString *ReturnBillNum;
@property (nonatomic,copy)NSString *ReturnBy;
@property (nonatomic,copy)NSString *ReturnByName;
@property (nonatomic,copy)NSString *ReturnOn;
@property (nonatomic,copy)NSString *Status;
@property (nonatomic,strong)NSArray *ReturnBillDetailList;
@property (nonatomic,strong)NSDictionary *TaskModel;

@property (nonatomic,copy)NSString * backStoreReason;//回仓原因
@property (nonatomic,copy)NSString * backStoreCount;//回仓个数


@end


//已回仓returnbilldetaillist返回内容
@interface DEReturnBillDetailModel : BaseModel

@property (nonatomic,copy)NSString *ActCount;
@property (nonatomic,copy)NSString *Barcode;
@property (nonatomic,copy)NSString *BarcodeId;
@property (nonatomic,copy)NSString *DetailId;
@property (nonatomic,copy)NSString *MaterialCode;
@property (nonatomic,copy)NSString *MaterialId;
@property (nonatomic,copy)NSString *MaterialInfo;
@property (nonatomic,copy)NSString *MaterialName;
@property (nonatomic,copy)NSString *Reason;
@property (nonatomic,copy)NSString *Remark;
@property (nonatomic,copy)NSString *ReturnBillId;
@property (nonatomic,copy)NSString *ReturnCount;
@property (nonatomic,copy)NSString *StockCount;
@property (nonatomic,copy)NSString *StockRecordId;
@property (nonatomic,copy)NSString *StockUnit;

@property (nonatomic,copy)NSString * backStoreReason;//回仓原因
@property (nonatomic,copy)NSString * backStoreCount;//回仓个数


@end
NS_ASSUME_NONNULL_END
