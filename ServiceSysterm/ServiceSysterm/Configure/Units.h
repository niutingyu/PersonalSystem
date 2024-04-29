//
//  Units.h
//  ServiceSysterm
//
//  Created by Andy on 2019/4/24.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "JFMinimalNotification.h"
NS_ASSUME_NONNULL_BEGIN

@interface Units : NSObject

+(NSDictionary*)jsonToDictionary:(NSString*)json;

+(NSArray*)jsonToArray:(NSString*)json;

+(NSString*)dictionaryToJson:(NSDictionary*)dictionry;

+(NSString*)arrayToJson:(NSArray*)array;

+(void)writeDataTodiskWithKeyStr:(NSString*)keyString path:(NSString*)pathString idObj:(id)idobj;

+(id)readDateFromDiskWithPathStr:(NSString*)path;

+ (NSString *)timeWithDate:(NSDate *)date andFormat:(NSString *)format;

+(void)showStatusWithStutas:(NSString*)status;

+(void)showLoadStatusWithString:(NSString*)string;

+(void)showErrorStatusWithString:(NSString*)string;

+(void)hideView;

+ (void)showWarningWithTitle:(NSString *)title andSubTitle:(NSString *)subTitle andView:(UIView *)view;//显示警告

+(void)translateTabbarController:(UITabBarController*)tabbarController;

+ (void)showHudWithText:(NSString *)text view:(UIView *)view model:(MBProgressHUDMode)model;

+ (void)hiddenHudWithView:(UIView *)view;

+ (UIViewController *)viewController:(UIView *)view;

+ (NSString *)timeWithTime:(NSString *)time beforeFormat:(NSString *)before andAfterFormat:(NSString *)after;
+ (NSDate *)dataFromString:(NSString *)time withFormat:(NSString *)format;

+ (NSString *)delayTime:(NSString *)time andEndTime:(NSString *)endTime;

+ (NSString *)currentTimeWithFormat:(NSString *)format;//获取当前时间

+(NSString *)getNowDate:(NSInteger)day;//获取当前 前一天 后一天 
//修改字体颜色
+(NSMutableAttributedString *)changeLabel:(NSString*)changeString wholeString:(NSString*)wholeString;

+(NSMutableAttributedString *)changeLabel:(NSString*)changeString wholeString:(NSString*)wholeString font:(UIFont*)font color:(UIColor*)color;

//根据文字计算高度
+(CGFloat)calculateRowHeight:(NSString*)string width:(CGFloat)width;
@end

NS_ASSUME_NONNULL_END
