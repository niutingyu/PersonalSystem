//
//  IQCListModel.h
//  ServiceSysterm
//
//  Created by Andy on 2021/7/6.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IQCListModel : BaseModel
/**
 任务单号
 */
@property (nonatomic,copy)NSString *IQCCode;

/**
 紧急通过
 */
@property (nonatomic,copy)NSString *IsUrgentPass;

/**
 紧急通过中文
 */
@property (nonatomic,copy)NSString *IsUrgentPassStr;

/**
 状态
 */
@property (nonatomic,copy)NSString *Status;

/**
 状态中文
 */
@property (nonatomic,copy)NSString * statusStr;

/**
 物料编码
 */
@property (nonatomic,copy)NSString *MaterialCode;

/**
 物料名称
 */
@property (nonatomic,copy)NSString *MaterialName;

/**
 物料规格
 */
@property (nonatomic,copy)NSString *MaterialInfo;

/**
 供应商批次号
 */
@property (nonatomic,copy)NSString *SupBarcode;

/**
 供应商代码
 */
@property (nonatomic,copy)NSString *SupplierCode;
/**
 收货数量
 */
@property (nonatomic,copy)NSString *TotalCount;

/**
 抽检数量
 */
@property (nonatomic,copy)NSString *SampleCount;

@property (nonatomic,copy)NSString *CanPass;

@property (nonatomic,copy)NSString *IQCOn;

/**
 单位
 */
@property (nonatomic,copy)NSString *UnitName;


/**
 文字高度
 */

@property (nonatomic,assign)CGFloat cellHeight;


/**
 工厂
 */
@property (nonatomic,copy)NSString * FactoryName;

/**
 检查类型
 */
@property (nonatomic,copy)NSString * IQCType;

/**
 检查类型中文
 */
@property (nonatomic,copy)NSString * IqcTaskTypeStr;

/**
 合格数量
 */
@property (nonatomic,copy)NSString * PassCount;

/**
 不合格数量
 */
@property (nonatomic,copy)NSString * RejCount;

/**
 特采数量
 */
@property (nonatomic,copy)NSString *SpecialCount;

/**
 有效期
 */
@property (nonatomic,copy)NSString *ExpDate;

/**
 生产日期
 */
@property (nonatomic,copy)NSString *MfgDate;


@property (nonatomic,copy)NSString * Id;

@property (nonatomic,copy)NSString *AuditBy;

@property (nonatomic,copy)NSString *AuditOn;

@property (nonatomic,copy)NSString *operationTypeStr;

/**
 检验结果
 */
@property (nonatomic,copy)NSString *CheckResult;

@end

NS_ASSUME_NONNULL_END
