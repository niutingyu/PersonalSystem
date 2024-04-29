//
//  UserModel.h
//  ServiceSysterm
//
//  Created by Andy on 2019/4/25.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : BaseModel<NSCoding>
//员工姓名
@property (nonatomic,copy) NSString * jobName;

//员工工号
@property (nonatomic,copy) NSString * jobNum;

//email
@property (nonatomic,copy) NSString * emailAddress;

//
@property (nonatomic,strong) NSArray * privilegeArray;

//手机
@property (nonatomic,copy) NSString * userMobile;

//短号
@property (nonatomic,copy) NSString * userShortMobile;

@property (nonatomic,strong) NSArray * frequentlyArray;

@end

NS_ASSUME_NONNULL_END
