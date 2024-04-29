//
//  DEPickChosMessageModel.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/8.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DEPickChosMessageModel : BaseModel
@property (nonatomic,copy)NSString * AssociateMaintId;
@property (nonatomic,copy)NSString * DepName;
@property (nonatomic,copy)NSString *TaskCode;
@property (nonatomic,copy)NSString *RequisitionTypeName;
@property (nonatomic,copy)NSString *FacilityName;
@property (nonatomic,copy)NSString *RequisitionType;
@end

NS_ASSUME_NONNULL_END
