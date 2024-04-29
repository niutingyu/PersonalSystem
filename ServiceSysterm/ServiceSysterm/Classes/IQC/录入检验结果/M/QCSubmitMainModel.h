//
//  QCSubmitMainModel.h
//  ServiceSysterm
//
//  Created by Andy on 2021/7/17.
//  Copyright © 2021 SLPCB. All rights reserved.
//

#import "BaseModel.h"
#import "QCColumnListModel.h"
#import "QCAppearanceModel.h"
#import "QCDetailListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCSubmitMainModel : BaseModel

@property (nonatomic,copy)NSString *Id;
/**
 最大标准
 */
@property (nonatomic,copy)NSString *MaxStandard;

/**
 最小标准
 */
@property (nonatomic,copy)NSString *MinStandard;

/**
 标题
 */
@property (nonatomic,copy)NSString *Name;

/**
 单位
 */
@property (nonatomic,copy)NSString *TestUnit;
/**
 检查标准
 */
@property (nonatomic,copy)NSString *CheckStandard;

@property (nonatomic,strong)NSArray * checkStandardList;


@property (nonatomic,strong)NSArray *columnList;

@property (nonatomic,strong)NSArray<QCDetailListModel*> *detailList;

/**
 是否非IQC项目
 */
@property (nonatomic,copy)NSString *RelateModule;
/**
 是否是系统判定
 */
@property (nonatomic,copy)NSString *JudgeMethod;
/**
 合格标准
 */
@property (nonatomic,copy)NSString *DecisionResult;

/**
 外观检查每个检测项宽度
 */
@property (nonatomic,strong)NSMutableArray *contentW;

/**
 cell高度
 */
@property (nonatomic,assign)CGFloat cellHeight;

/**
 所在行号
 */
@property (nonatomic,assign)NSInteger pathNumber;

/**
 外观检查项目数组
 */
@property (nonatomic,strong)NSArray * appranceCheckStandardList;



/**
 外观检查选中
 */

@property (nonatomic,strong)NSMutableArray * selectedAppranceItemList;


/**
 是否物理实验室项目 为空才可以操作 不为空不能操作
 */

@property (nonatomic,copy)NSString *RelateTaskCode;


@property (nonatomic,copy)NSString *typeStr;

@property (nonatomic,strong)NSArray *dropTypeList;

/**
 是否查看编辑
 */
@property (nonatomic,copy)NSString *operationStr;

@end

NS_ASSUME_NONNULL_END
