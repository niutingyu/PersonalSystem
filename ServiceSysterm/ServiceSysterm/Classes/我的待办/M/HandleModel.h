//
//  HandleModel.h
//  ServiceSysterm
//
//  Created by Andy on 2019/7/19.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HandleModel : NSObject
@property (nonatomic,copy)NSString *privilegeId;
@property (nonatomic,copy)NSString *privilegeName;
@property (nonatomic,strong)NSArray *task;
@end

NS_ASSUME_NONNULL_END
