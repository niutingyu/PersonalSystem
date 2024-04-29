//
//  NSString+Category.h
//  ServiceSysterm
//
//  Created by Andy on 2019/4/20.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Category)

- (NSString *)getWholeUrl;

- (BOOL)isEmail;

- (BOOL)isPhoneNumber;
@end

NS_ASSUME_NONNULL_END
