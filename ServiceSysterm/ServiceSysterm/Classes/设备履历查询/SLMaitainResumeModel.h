//
//  SLMaitainResumeModel.h
//  SLPersonnelSystem
//
//  Created by Andy on 2020/3/19.
//  Copyright © 2020 深圳市深联电路有限公司. All rights reserved.
//

#import "BaseModel.h"
#import "SLResumeListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLMaitainResumeModel : BaseModel



/**
 设备Id
 */
@property (nonatomic,copy)NSString * FacilityId;

/**
 设备编号
 
 */

@property (nonatomic,copy)NSString * FacilityCode;

/**
 设备名称
 */

@property (nonatomic,copy) NSString * FacilityName;

/**
 入厂时间
 */

@property (nonatomic,copy)NSString *EnterTime ;
/**
 最近一次保养时间
 */

@property (nonatomic,copy)NSString * MaintDate;

/**
 下次保养时间
 */

@property (nonatomic,copy)NSString * NextMaintDate;

/**
 存放位置
 */

@property (nonatomic,copy)NSString *StorageLocation;




/**
 维修耗时
 */

@property (nonatomic,copy)NSString * MaintTime;
/**
 维修单数
 */

@property (nonatomic,copy)NSString * MaintCount;








/**
 数据数组
 */
@property (nonatomic,strong)NSArray<SLResumeListModel*> * list;

@end

NS_ASSUME_NONNULL_END
