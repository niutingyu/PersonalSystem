//
//  DEProblemModel.h
//  ServiceSysterm
//
//  Created by Andy on 2019/6/17.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DEProblemModel : BaseModel
@property (nonatomic,copy)NSString *ActualFinishTime;
@property (nonatomic,copy)NSString *ContentName;
@property (nonatomic,copy)NSString *ExceptionExplain;
@property (nonatomic,copy)NSString *ImplementationPlan;
@property (nonatomic,copy)NSString *MaintenanceProblemId;
@property (nonatomic,copy)NSString *MaintenanceProjectName;
@property (nonatomic,copy)NSString *MaintenanceResult;
@property (nonatomic,copy)NSString *PartsBrand;
@property (nonatomic,copy)NSString *PartsCode;
@property (nonatomic,copy)NSString *PartsLife;
@property (nonatomic,copy)NSString *PartsName;
@property (nonatomic,copy)NSString *PartsRules;
@property (nonatomic,copy)NSString *PartsType;
@property (nonatomic,copy)NSString *PredictFinishTime;
@property (nonatomic,copy)NSString *QuantityDemanded;
@property (nonatomic,copy)NSString *ReasonType;
@property (nonatomic,copy)NSString *Verification;
@end


@interface ReviewProblemModel : NSObject
@property (nonatomic,copy)NSString *PredictFinishTime;
@property (nonatomic,copy)NSString *MaintenanceProblemId;
@property (nonatomic,copy)NSString *HrproId;
@property (nonatomic,copy)NSString *ContentName;
@property (nonatomic,copy)NSString *FinishFlag;
@property (nonatomic,copy)NSString *isSuerGood; // 是否合格


@end
NS_ASSUME_NONNULL_END
