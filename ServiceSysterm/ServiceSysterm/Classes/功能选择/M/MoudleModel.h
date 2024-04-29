//
//  MoudleModel.h
//  ServiceSysterm
//
//  Created by Andy on 2019/4/25.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoudleModel : NSObject<NSCoding>

@property (nonatomic,strong)NSArray *ModulesList;

@property (nonatomic,strong)NSDictionary *BaseMsg;

@property (nonatomic,strong)NSArray *FactoryList;

@end

NS_ASSUME_NONNULL_END
