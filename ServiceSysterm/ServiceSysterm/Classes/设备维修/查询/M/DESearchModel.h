//
//  DESearchModel.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/18.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DESearchModel : BaseModel
@property (nonatomic,copy)NSString *CheckProgram;
@property (nonatomic,copy)NSString *SumMain;

@end


@interface DERankModel : BaseModel

@property (nonatomic,copy)NSString *DistrictName;
@property (nonatomic,copy)NSString *FName;
@property (nonatomic,copy)NSString *Maintime;
@property (nonatomic,copy)NSString *Ranking;
@property (nonatomic,copy)NSString *UserName;
@property (nonatomic,copy)NSString *SumMain;

@end

@interface DEErrorModel : BaseModel

@property (nonatomic,copy)NSString *FacilityException;
@property (nonatomic,copy)NSString *MaintainTaskId;
@property (nonatomic,copy)NSString *TaskCode;

@end

@interface DESortModel : BaseModel
@property (nonatomic,copy)NSString *Amount;
@property (nonatomic,copy)NSString *CheckProgram;
@property (nonatomic,copy)NSString *FName;
@property (nonatomic,copy)NSString *FacilityCode;
@property (nonatomic,copy)NSString *FacilityName;
@property (nonatomic,copy)NSString *PerformanceGoal;
@property (nonatomic,copy)NSString *RecordDate;
@property (nonatomic,copy)NSString *Scored;
@property (nonatomic,copy)NSString *TaskCode;

@end
NS_ASSUME_NONNULL_END
