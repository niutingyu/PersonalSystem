//
//  MCDetailMaintainArrayModel.h
//  ServiceSysterm
//
//  Created by Andy on 2020/10/27.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCDetailMaintainArrayModel : BaseModel

@property (nonatomic,copy)NSString *ConfirmTime;

@property (nonatomic,copy)NSString *ReactTime;

@property (nonatomic,copy)NSString *acceptTime;

@property (nonatomic,copy)NSString *acceptUser;

@property (nonatomic,copy)NSString *applyFinishTime;

@property (nonatomic,copy)NSString *assignTime;

@property (nonatomic,copy)NSString *assignUser;

@property (nonatomic,copy)NSString *finishTime;

@property (nonatomic,copy)NSString *issueTime;

@property (nonatomic,copy)NSString *maintime;

@property (nonatomic,copy)NSString *operApplyUser;

@property (nonatomic,copy)NSString *operCreateUser;

@property (nonatomic,copy)NSString *operFinishUser;

@property (nonatomic,copy)NSString *pauseTime;

@property (nonatomic,copy)NSString *predictBeginTime;

@property (nonatomic,copy)NSString *status;

@property (nonatomic,copy)NSString *workLog;

@property (nonatomic,assign)CGFloat logHeight;

@end

NS_ASSUME_NONNULL_END
