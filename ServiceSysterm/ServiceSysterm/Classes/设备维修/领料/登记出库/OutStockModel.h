//
//  OutStockModel.h
//  ServiceSysterm
//
//  Created by Andy on 2019/8/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OutStockModel : NSObject
@property (nonatomic,assign) int Status;
@property (nonatomic,copy) NSString *StockOutBillCode;
@property (nonatomic,assign) int StockOutType;
@property (nonatomic,copy) NSString *SupDocCode;// 上级关联单号
@property (nonatomic,copy) NSString *IssueOn;// 发料日期
@property (nonatomic,copy) NSString *MatRDepName;// 领料部门
@property (nonatomic,copy) NSString *ProcedureName; // 领料工序
@property (nonatomic,copy) NSString *StockOutBillId;

@property (nonatomic,copy) NSString *SupDocId;

@property (nonatomic,copy) NSString *FactoryId; // 工厂ID

@property (nonatomic,copy) NSDictionary *TaskModel;


@end

@interface StockDetailModel : NSObject
@property (nonatomic,copy) NSString *Barcode;//流水号
@property (nonatomic,copy) NSString *MaterialCode;//物料编码
@property (nonatomic,copy) NSString *MaterialName;//物料名称
@property (nonatomic,copy) NSString *MaterialInfo;//物料规格
@property (nonatomic,copy) NSString *UnitName;//单位
@property (nonatomic,assign) int StockCount;//Int 数量
@property (nonatomic,copy) NSString *StoreName;//仓库
@property (nonatomic,copy) NSString *ShelvesNum;//货架号
@property (nonatomic,copy) NSString *Remark;//备注

@end
NS_ASSUME_NONNULL_END
