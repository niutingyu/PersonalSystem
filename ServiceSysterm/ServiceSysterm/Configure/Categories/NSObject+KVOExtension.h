//
//  NSObject+KVOExtension.h
//  ServiceSysterm
//
//  Created by Andy on 2019/6/24.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^obsResultHandler) (id newData, id oldData,id owner);

@interface NSObject (KVOExtension)

-(void)obsKey:(NSString *)key handler:(obsResultHandler)handler;
@end

NS_ASSUME_NONNULL_END
