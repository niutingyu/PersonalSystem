//
//  MCDetailUserOperateArrayModel.h
//  ServiceSysterm
//
//  Created by Andy on 2020/10/27.
//  Copyright © 2020 SLPCB. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCDetailUserOperateArrayModel : BaseModel

@property (nonatomic,copy)NSString *FName;

@property (nonatomic,copy)NSString *PassFlag;

@property (nonatomic,copy)NSString *SignDpart;

@property (nonatomic,copy)NSString *SignRemark;

@property (nonatomic,copy)NSString *SignTime;

@property (nonatomic,copy)NSString *TaskCode;


@property (nonatomic,assign)CGFloat cellHeight;


@end

NS_ASSUME_NONNULL_END
