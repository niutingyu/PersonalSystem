//
//  DEUnfinishDetailModel.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/16.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DEUnfinishDetailModel : BaseModel
@property (nonatomic,copy)NSString *DepName;
@property (nonatomic,copy)NSString *DistrictName;
@property (nonatomic,copy)NSString *FacilityCode;
@property (nonatomic,copy)NSString *FacilityDpartName;
@property (nonatomic,copy)NSString *FacilityId;
@property (nonatomic,copy)NSString *FacilityName;
@property (nonatomic,copy)NSString *FacilityStatus;
@property (nonatomic,copy)NSString *FaultReasonId;
@property (nonatomic,copy)NSString *FaultReasonName;
@property (nonatomic,copy)NSString *HumanFlag;
@property (nonatomic,copy)NSString *IsReplace;
@property (nonatomic,copy)NSString *IssueTime;
@property (nonatomic,copy)NSString *LastByEngineer;
@property (nonatomic,copy)NSString *LastChangeTime;
@property (nonatomic,copy)NSString *Lev;
@property (nonatomic,copy)NSString *LossFlag;
@property (nonatomic,copy)NSString *MaintainDistrictId;
@property (nonatomic,copy)NSString *MaintainFacilityPartsId;
@property (nonatomic,copy)NSString *MaintainFaultId;
@property (nonatomic,copy)NSString *MaintainFaultName;
@property (nonatomic,copy)NSString *MaintainTaskId;
@property (nonatomic,copy)NSString *OccupyCapacity;
@property (nonatomic,copy)NSString *OperCreateUserName;
@property (nonatomic,copy)NSString *PartsDetailName;
@property (nonatomic,copy)NSString *PartsLife;
@property (nonatomic,copy)NSString *PartsTypeId;
@property (nonatomic,copy)NSString *PartsTypeName;
@property (nonatomic,copy)NSString *PlanStartTime;
@property (nonatomic,copy)NSString *Remark;
@property (nonatomic,copy)NSString *TaskCode;
@property (nonatomic,copy)NSString *TaskStatusName;
@property (nonatomic,copy)NSString *TreatmentProcess;
@property (nonatomic,copy)NSString *SumMain;// 实际单数：一个保养周期内维修单数实际值
@property (nonatomic,copy)NSString *MaintainDjbyId;//单ID

@property (nonatomic,strong)NSMutableArray *LinkmanArray;
@property (nonatomic,strong)NSMutableArray *MaintainArray;
@property (nonatomic,strong)NSMutableArray *UserOperateArray;
@property (nonatomic,strong)NSArray *OperateArray;
@property (nonatomic,strong)NSArray *ExceptionArray;
@property (nonatomic,strong)NSArray *MaintenceStepArray;//保养清单

@property (nonatomic,copy)NSString *CountGoal;
@property (nonatomic,copy)NSString *RecentlyTaskCode;
@property (nonatomic,copy)NSString *ByFinishTime;


@property (nonatomic,assign)BOOL isopen;

@property (nonatomic,assign)BOOL maintenceStepIsOpen;





@end

@interface LinkManModel : BaseModel
@property (nonatomic,copy)NSString *FName;
@property (nonatomic,copy)NSString *Ms;
@property (nonatomic,copy)NSString *UserMobile;
@property (nonatomic,copy)NSString *UserShortMobile;

@end

@interface MaintainModel : BaseModel
@property (nonatomic,copy)NSString *AcceptTime;
@property (nonatomic,copy)NSString *AcceptUserName;
@property (nonatomic,copy)NSString *ApplyFinishTime;
@property (nonatomic,copy)NSString *AssignTime;
@property (nonatomic,copy)NSString *AssignUserName;
@property (nonatomic,copy)NSString *ConfirmTime;
@property (nonatomic,copy)NSString *FinishTime;
@property (nonatomic,copy)NSString *IssueTime;
@property (nonatomic,copy)NSString *Maintime;
@property (nonatomic,copy)NSString *OperApplyUserName;
@property (nonatomic,copy)NSString *OperCreateUserName;
@property (nonatomic,copy)NSString *OperFinishUserName;
@property (nonatomic,copy)NSString *PauseTime;
@property (nonatomic,copy)NSString *ReactTime;
@property (nonatomic,copy)NSString *Status;
@property (nonatomic,copy)NSString *MaintainFaultName;//故障名称
@property (nonatomic,copy)NSString *QualityConfirmTime;
@property (nonatomic,copy)NSString *QualityConfirmUser;

@end

@interface UserOperateModel : BaseModel

@property (nonatomic,copy)NSString *FName;
@property (nonatomic,copy)NSString *PassFlag;
@property (nonatomic,copy)NSString *SignDpart;
@property (nonatomic,copy)NSString *SignRemark;
@property (nonatomic,copy)NSString *SignTime;
@property (nonatomic,copy)NSString *TaskCode;


@end

@interface DetailMemberModel : BaseModel
@property (nonatomic,copy)NSString *AssignSeqDj;
@property (nonatomic,copy)NSString *Classes;
@property (nonatomic,copy)NSString *ClassesName;
@property (nonatomic,copy)NSString *DistrictName;
@property (nonatomic,copy)NSString *FName;
@property (nonatomic,copy)NSString *TaskFlag;
@property (nonatomic,copy)NSString *UserId;
@property (nonatomic,copy)NSString *UserMobile;
@property (nonatomic,copy)NSString *UserName;
@property (nonatomic,copy)NSString * selectedType;//人员是否多选
@property (nonatomic,copy)NSString *ContentName;
@property (nonatomic,copy)NSString *MaintenanceProblemId;
@property (nonatomic,copy)NSString *FinishFlag;



@end

@interface ExceptionModel : BaseModel

@property (nonatomic,copy)NSString *ContentName;
@property (nonatomic,copy)NSString *Flag;
@property (nonatomic,copy)NSString *HrproId;
@property (nonatomic,copy)NSString *MaintenanceContentsId;
@property (nonatomic,copy)NSString *MaintenanceProblemId;

@property (nonatomic,assign)CGFloat contentW;

@property (nonatomic,assign)CGFloat contentH;

@end

@interface MaintenceStepListModel : BaseModel

@property (nonatomic,copy)NSString *MaintenanceStepsName;

@property (nonatomic,copy)NSString *ContentName;

@property (nonatomic,copy)NSString *CheckResult;

@property (nonatomic,copy)NSString *MaintenanceProjectName;

@property (nonatomic,copy)NSString *checkResultStr;



@end
NS_ASSUME_NONNULL_END
