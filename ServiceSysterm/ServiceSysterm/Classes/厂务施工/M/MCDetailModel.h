//
//  MCDetailModel.h
//  ServiceSysterm
//
//  Created by Andy on 2020/10/27.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "BaseModel.h"

#import "MCDetailMaintainArrayModel.h"
#import "MCDeatilLinkmanArrayModel.h"
#import "MCDetailUserOperateArrayModel.h"
#import "MCDetailOperateModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MCDetailModel : BaseModel

@property (nonatomic,copy)NSString *consDepartName;

@property (nonatomic,copy)NSString *constructionTaskId;

@property (nonatomic,copy)NSString *dpartName;

@property (nonatomic,copy)NSString *faultTypeId;

@property (nonatomic,copy)NSString *issueTime;

@property (nonatomic,copy)NSString *makeDrawing;

@property (nonatomic,copy)NSString *operCreateUser;

@property (nonatomic,copy)NSString *planStartTime;

@property (nonatomic,copy)NSString *predictBeginTime;

@property (nonatomic,copy)NSString *predictEndTime;

@property (nonatomic,copy)NSString *remark;

@property (nonatomic,copy)NSString *sgType;

@property (nonatomic,copy)NSString *taskCode;

@property (nonatomic,copy)NSString *taskStatus;

@property (nonatomic,strong)NSArray<MCDeatilLinkmanArrayModel*> *LinkmanArray;

@property (nonatomic,strong)NSArray<MCDetailMaintainArrayModel*> *MaintainArray;

@property (nonatomic,strong)NSArray<MCDetailUserOperateArrayModel*> *UserOperateArray;

@property (nonatomic,strong)NSArray<MCDetailOperateModel*> *OperateArray;


@property (nonatomic,assign)CGFloat remarkheight;

@end

NS_ASSUME_NONNULL_END
