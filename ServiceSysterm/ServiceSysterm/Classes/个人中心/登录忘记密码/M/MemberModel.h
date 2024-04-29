//
//  MemberModel.h
//  ServiceSysterm
//
//  Created by Andy on 2019/5/29.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MemberModel : BaseModel
@property (nonatomic,copy)NSString *DepName;
@property (nonatomic,strong)NSArray *PepList;
@end

@interface PeopleListModel : BaseModel
@property (nonatomic,copy)NSString *DepName;
@property (nonatomic,copy)NSString *Email;
@property (nonatomic,copy)NSString *EmployeeId;
@property (nonatomic,copy)NSString *FName;
@property (nonatomic,copy)NSString *Mobile;
@property (nonatomic,copy)NSString *PositionName;
@property (nonatomic,copy)NSString *UserId;
@property (nonatomic,copy)NSString *UserName;
@property (nonatomic,copy)NSString *shortMobile;

@end
NS_ASSUME_NONNULL_END
