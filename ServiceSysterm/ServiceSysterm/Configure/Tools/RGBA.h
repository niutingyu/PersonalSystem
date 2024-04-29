//
//  RGBA.h
//  ServiceSysterm
//
//  Created by Andy on 2019/8/13.
//  Copyright © 2019 SLPCB. All rights reserved.
//


#define RGB(rgbValue) [RGBA colorWithRGBFromString:(rgbValue)]
#define RGB16(rgbValue) [RGBA colorWithRGB16:(rgbValue)]

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RGBA : NSObject
+ (UIColor *)colorWithRGB16:(int)rgb;
+ (UIColor *)colorWithRGBFromString:(NSString *)rgb;
@end

NS_ASSUME_NONNULL_END
