//
//  HandleTaskModel.h
//  ServiceSysterm
//
//  Created by Andy on 2019/7/19.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HandleTaskModel : NSObject
@property (nonatomic,copy)NSString *dpartName;
@property (nonatomic,copy)NSString *facilityName;
@property (nonatomic,copy)NSString *faultTypeName;
@property (nonatomic,copy)NSString *issueTime;
@property (nonatomic,copy)NSString *operCreateUser;
@property (nonatomic,copy)NSString *taskCode;
@property (nonatomic,copy)NSString *taskStatus;

@end

NS_ASSUME_NONNULL_END
