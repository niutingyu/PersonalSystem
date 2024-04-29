//
//  RGBA.m
//  ServiceSysterm
//
//  Created by Andy on 2019/8/13.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "RGBA.h"

@implementation RGBA
+ (UIColor *)colorWithRGB16:(int)rgb {
    return [UIColor colorWithRed:((rgb & 0xFF0000) >> 16) / 255.0f
                           green:((rgb & 0xFF00) >> 8) / 255.0f
                            blue:((rgb & 0xFF)) / 255.0f
                           alpha:1.0f];
}
+ (UIColor *)colorWithRGBFromString:(NSString *)rgb {
    if ([rgb rangeOfString:@"#"].location != NSNotFound) {
        rgb = [rgb substringFromIndex:1];
    }
    rgb = [NSString stringWithFormat:@"0x%@",rgb];
    unsigned long rgb16 = strtoul([rgb UTF8String],0,16);
    
    return [self colorWithRGB16:(int)rgb16];
}
@end
