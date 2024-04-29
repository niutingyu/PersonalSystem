//
//  HttpURL.h
//  ServiceSysterm
//
//  Created by Andy on 2019/4/20.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#ifndef HttpURL_h
#define HttpURL_h

//
//http://192.168.101.48:7084/ //测试库
// http://192.168.1.58:8001/
//#define ServerAddress @"http://192.168.1.21:8001/"
//http://218.87.254.236:8091/ http://117.41.47.13:8092/
#define ServerAddress @"http://192.168.101.48:8080/"
//#define ServerAddress @"http://192.168.101.46:80/"
#define NetworkServerAddress @"http://117.41.47.13:8092/"

//登录
#define LoginUrl @"app/AccessToModule/login"

//检查是否在别处登录

#define OtherPlaceLogin @"userManger/aliasJudge"

//获取功能模块
#define FunctionModleURL @"app/AccessToModule/getModule"

//权限
#define ChoseMoudleURL @"app/AccessToModule/getModuleRights"

//设备编号
#define DeviceCodeURL @"maint/maintainfacility/findFacilityListByUserId"

//设备点检保养 设备编号

#define DeviceCheckCodeURL @"maint/maintainfacility/findDjbyFacilityListByUserId"

//设备管理 我的任务
#define DeviceTaskURL @"maint/maintaintask/myTasks"

//设备管理 未完成
#define DeviceUnfinishTaskURL @"maint/maintaintask/applyLists"

//设备管理 未完成详情

#define DeviceUnfinishTaskDetailURL @"maint/maintaintask/detailMsg"

#define DeviceDetailMsgURL @"maint/maintaindjby/detailMsg"

//人员 更新人员状态
#define DeviceUpdateMemberStatusURL @"maint/maintaintask/updateEngineerStatus"

//设备管理 领料工厂
#define DevicePickFactoryURL @"api/baseapi/getFactoryList"

//设备管理 开单
#define DeviceNewOrder @"maint/maintaintask/createOrUpdate"

//设备管理 领料单号

#define DevicePickOrderNoURL @"maint/maintaintask/getAssociateMaintId"

//设备管理 工序名称
#define DeviceProjectNameURL @"sys/department/getList"
//设备管理 异常
#define DeviceErrorURL @"maint/maintaintask/getExceptionList"
#define DevicePushLogURL @"maint/maintaintask/getPushLogList"//推送

//设备维修 登记出库

#define RegisterOutStockUrl @"mc/stockoutbill/getTaskList"

//设备维修 登记出库 获取出库物品信息

#define OutstockDetailUrl @"mc/stockrecord/getdetiallist"

//设备管理 确认登记出库
#define CommitStockUrl @"mc/stockoutbill/updateAndCommit"

//设备管理 获取物料

#define DevicePickMaterialURL @"pu/material/GetMaterialListWithStockCount"

//设备管理 领料

#define DeviceGetMaterialCommit @"mc/matrequisition/SaveAndCommit"

//设备管理 领料单

#define DevicePickListURL @"mc/matrequisition/getpage"

//设备管理 可回仓
#define DeviceBackStockURL @"mc/matrequisition/getSelectedMatReqList"

//设备管理 回仓表
#define DeviceStockListURL @"mc/returnbill/getpage"

//设备管理 物料清单
#define DeviceMaterialListURL @"mc/matrequisitiondetail/findDetailListById"

//设备管理 可回仓列表详细信息
#define DeviceMaightBackStockDetailURL @"mc/stockrecord/getMatReqStockOutDetail"

//设备管理 确认回仓
#define DeviceCommitbackStoreURL @"mc/returnbill/commit"

//设备管理 已回仓详细信息
#define DeviceBackStoreListDetailURL @"mc/returnbill/find"
//设备管理 部门数组

#define DeviceDepartmentURL @"maint/maintaintask/getAllDpart"

//设备管理 区域名称
#define DeviceAreaURL @"maint/maintaindistrict/getDistrictList"

//设备管理 维修工程师
#define DeviceEngineerURL @"maint/maintaintask/getEngineerStatus"

//设备维修接单 修改故障
#define MaintainAcceptnceTaskURL @"maint/maintaintask/acceptTask"

//设备维修
#define DeviceReviseErrorUrl @"maint/maintaintask/finallyConfirm"


//设备管理 查询 汇总
#define DeviceWholeMessageURL @"maint/maintaintask/getSummaryOrRank"

//设备管理 积分 

#define DeviceSortURL @"maint/maintaintask/getMaintainScoreList"

//设备管理 积分详细信息

#define DeviceSortDetailMessageURL @"maint/maintaintask/getScoreDetailList"

//设备维修 确认验收 驳回返修
#define DeviceMaintainSureAcceptanceURL @"maint/maintaintask/confirmFinish"

//设备维修 解除暂停
#define MaintainCalloffPauseURL @"maint/maintaintask/recoveryMaint"

//设备维修 故障原因
#define MaintainEnginesFailURL @"maint/maintaintask/getFaultReasonList"

//设备维修 设备配件
#define DevicePartsURL @"maint/maintaintask/getPartsByFacilityId"

//设备维修 配件类型
#define TypeOfDevicePartURL @"maint/maintaintask/getPartsTypeList"

//设备维修 申请验收
#define AppyAcceptanceURL @"maint/maintaintask/applyFinish"

//设备维修 暂停维修

#define MaintainPauseUrl @"maint/maintaintask/pasueOrRefuse"

/**
 设备履历列表
 */
#define DeviceResumeListURL @"/maint/maintaintask/getMaintList"
/**
 设备查询
 */
#define DeviceResumeCheckListURL @"/maint/maintaintask/getAllMaintainFacility"
//点检
#define DeviceCheckUnFinishListURL @"maint/maintaindjby/applyLists"

//指派 增援指派 移除指派 维修

#define DeviceAppointURL @"maint/maintaintask/assignOrReinforce"

#define MemberURL @"it/Meeting/getCanHuiPeople"

//点检保养  获取设备类型
#define CheckDeviceTypeURL @"maint/maintaintask/getFaultByFacilityId"

//点检保养 开单
#define CheckNewOrderURL @"maint/maintaindjby/create"

//点检 暂停保养

#define CheckPauseMaintainUrl @"maint/maintaindjby/pasue"

//点检保养 我的任务
#define CheckMyTaskURL @"maint/maintaindjby/myTasks"

#define ProblemMessageURL @"maint/maintaindjby/getExceptiondetailMsg"

//点检问题点
#define CheckProblemUrl @"maint/maintaindjby/getExceptionForOperation"
//点检 接单 接单复核 接单稽核

#define AcceptanceURL @"maint/maintaindjby/acceptTask"

//点检 解除暂停 开始处理问题
#define CallOffPauseorSloveProblemURL @"maint/maintaindjby/recoveryMaint"

//点检保养 替换工程师
#define ChansgeEngineerURL @"maint/maintaindjby/otherOperation"

//点检完成 保养完成

#define CheckAndMaintainFinishURL @"maint/maintaindjby/submitForm"

//点检 申请完成
#define ApplayFinishUrl @"maint/maintaindjby/applyFinish"

//点检 指派 增援指派 移除指派

#define CheckAppointWorkURL @"maint/maintaindjby/assignOrReinforce"

//复核
#define CheckRecheckURL @"maint/maintaindjby/confirmFinish"
//更新个人资料
#define UpdateMobile @"userManger/updateMobile"

//我的待办
#define HandleTaskURL @"userManger/userTasks?jobNum="





//账号

#define CodeName @"codeName"
//密码
#define PassWord @"password"

//登录名
#define JOBNUM @"jobnum"
//用户Id

#define USERID @"userid"

//个人信息
#define  UserInformation @"userInfo"

//功能选择
#define Function_WriteDisk @"functionWriteDisk"







#endif /* HttpURL_h */
