//
//  DEStockModel.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/13.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DEStockModel : NSObject

@end


@interface DEMatrialListModel :NSObject
@property (nonatomic,copy) NSString * Status; //Int 否 状态
@property (nonatomic,copy) NSString *MatRequisitionCode; //String 领料单号
@property (nonatomic,assign) int RequisitionType; // Int 领料类型(12：设备维修  13：设备保养 14：工程施工)
@property (nonatomic,copy) NSString *RequisitionOn; // String 申请时间
@property (nonatomic,copy) NSString *RequisitionByStr; // String 申请人
@property (nonatomic,copy) NSString *DepStr; // String 申请部门
@property (nonatomic,copy) NSString *Reason; // String 申请原因
@property (nonatomic,assign) int HasPrint; // Int 打印状态（0：未打印 大于0：已打印）
@property (nonatomic,copy) NSString *MatRequisitionId; // String 领料单ID ，不展示用于接口8.4.2
@property (nonatomic,copy) NSString *DepId;
@property (nonatomic,copy) NSString *FactoryId;

@end

@interface DEBackStockModel : NSObject
@property (nonatomic,copy)NSString *AssociateMaintId;
@property (nonatomic,copy)NSString *AuditIndex;
@property (nonatomic,copy)NSString *DepId;
@property (nonatomic,copy)NSString *DepStr;
@property (nonatomic,copy)NSString *DistributeBy;
@property (nonatomic,copy)NSString *FactoryId;
@property (nonatomic,copy)NSString *FactoryName;
@property (nonatomic,copy)NSString *HasPrint;
@property (nonatomic,copy)NSString *InstanceId;
@property (nonatomic,copy)NSString *IsReturnBill;
@property (nonatomic,copy)NSString *IsStartStock;
@property (nonatomic,copy)NSString *IssueOn;
@property (nonatomic,copy)NSString *MatNeedBill;
@property (nonatomic,copy)NSString *MatRequisitionCode;
@property (nonatomic,copy)NSString *MatRequisitionId;
@property (nonatomic,copy)NSString *OutMatRequisitionId;
@property (nonatomic,copy)NSString *PrintCount;
@property (nonatomic,copy)NSString *ProcedureId;
@property (nonatomic,copy)NSString *Reason;
@property (nonatomic,copy)NSString *RequisitionBy;
@property (nonatomic,copy)NSString *RequisitionByStr;
@property (nonatomic,copy)NSString *RequisitionOn;
@property (nonatomic,copy)NSString *RequisitionType;
@property (nonatomic,copy)NSString *Status;

@end

@interface DEStockListModel : NSObject

@property (nonatomic,copy) NSString *DepId;
@property (nonatomic,copy) NSString *DepName;
@property (nonatomic,copy) NSString *FactoryId;
@property (nonatomic,copy) NSString *InstanceId;
@property (nonatomic,copy) NSString *MatRequisitionCode;
@property (nonatomic,copy) NSString *MatRequisitionId;
@property (nonatomic,copy) NSString *ReturnBillId;  // 回仓Id
@property (nonatomic,copy) NSString *ReturnBillNum; // 回仓单号
@property (nonatomic,copy) NSString *ReturnBy;
@property (nonatomic,copy) NSString *ReturnByName;
@property (nonatomic,copy) NSString *ReturnOn;
@property (nonatomic,assign) int Status;
@property (nonatomic,copy) NSString *SyncId;

//@property (nonatomic,copy) NSString *TaskModel;
@property (nonatomic,copy) NSString *tempcolumn;
@property (nonatomic,copy) NSString *temprownumber;
@property (nonatomic,assign)int HasPrint;
@property (nonatomic,copy)NSString *FactoryName;

@end
NS_ASSUME_NONNULL_END
