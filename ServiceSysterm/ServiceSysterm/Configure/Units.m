//
//  Units.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/24.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "Units.h"

@implementation Units


//json字符串转化字典
+(NSDictionary*)jsonToDictionary:(NSString*)json{
    if (json == nil){
        return nil;
    }
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    
    return dic;
}

//json字符串转化数组
+(NSArray*)jsonToArray:(NSString*)json{
    if (json == nil){
        return nil;
    }
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    return array;
}

//字典转化json字符串
+(NSString*)dictionaryToJson:(NSDictionary*)dictionry{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionry options:0 error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//数组转化json字符串
+(NSString*)arrayToJson:(NSArray*)array{
    //(1).先讲数组转化成NSData数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:0 error:nil];
    NSString *resultString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    return resultString;
}
//归档
+(void)writeDataTodiskWithKeyStr:(NSString*)keyString path:(NSString*)pathString idObj:(id)idobj{
    //归档
    NSMutableData * data = [[NSMutableData alloc]init];
    //创建归档辅助类
    NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    
    [archiver encodeObject:idobj forKey:keyString];
    //结束编码
    [archiver finishEncoding];
    //写入沙盒
    NSArray * array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * fileName = [array.firstObject stringByAppendingPathComponent:pathString];
    if ([data writeToFile:fileName atomically:YES]) {
        debugLog(@"归档成功");
        
    }
}
//解档
+(id)readDateFromDiskWithPathStr:(NSString*)path{
    NSArray * array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * fileName = [array.firstObject stringByAppendingPathComponent:path];
    //解档
    NSData * undata = [[NSData alloc]initWithContentsOfFile:fileName];
    //解档辅助类
    NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:undata];
    return unarchiver;
}


+ (NSString *)timeWithDate:(NSDate *)date andFormat:(NSString *)format {
    if (format == nil) {
        format = @"HH:mm";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:format];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

+(void)showStatusWithStutas:(NSString*)status{
    [self hideView];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showSuccessWithStatus:status];
    [SVProgressHUD dismissWithDelay:2];
}


+(void)showLoadStatusWithString:(NSString*)string{
    // 如果当前视图还有其他提示框，就dismiss
    [self hideView];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD setCornerRadius:5];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    
    // 加载中的提示框一般不要不自动dismiss，比如在网络请求，要在网络请求成功后调用 hideLoadingHUD 方法即可
    if (string) {
        [SVProgressHUD showWithStatus:string];
    }else{
        [SVProgressHUD show];
    }
}

+(void)showErrorStatusWithString:(NSString*)string{
    
    [SVProgressHUD showInfoWithStatus:string];
    [SVProgressHUD dismissWithDelay:1.0];
}
+(void)hideView{
    [SVProgressHUD dismiss];
    //[HttpTool CancelRequest];
}

//跳转页面

+(void)translateTabbarController:(UITabBarController*)tabbarController{
    CATransition * transtion = [CATransition animation];
    transtion.duration = 0.3;
    transtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transtion.type = kCATransitionFade;

    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = tabbarController;
    [window.layer addAnimation:transtion forKey:@"animation"];
}
+ (void)showHudWithText:(NSString *)text view:(UIView *)view model:(MBProgressHUDMode)model
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [view addSubview:hud];
    hud.label.text = text;
    
    hud.mode = model;
    hud.removeFromSuperViewOnHide = YES;
    
    if(model == MBProgressHUDModeText)
    {
        [hud hideAnimated:YES afterDelay:0.5];
        
    }
    
}

+ (void)hiddenHudWithView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
   
}


+ (UIViewController *)viewController:(UIView *)view {
    
    for (UIView *next = view; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

+ (void)showWarningWithTitle:(NSString *)title andSubTitle:(NSString *)subTitle andView:(UIView *)view {
    JFMinimalNotification *minimalNotification = [self minimaNotficationWithTitle:title andSubTitle:subTitle andView:view];
    [minimalNotification setStyle:JFMinimalNotificationStyleWarning animated:YES];
    
    [minimalNotification show];
}
+ (JFMinimalNotification *)minimaNotficationWithTitle:(NSString *)title andSubTitle:(NSString *)subTitle andView:(UIView *)view; {
    JFMinimalNotification *minimalNotification;
    minimalNotification = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleSuccess title:title subTitle:subTitle dismissalDelay:1.5 touchHandler:^{
        [minimalNotification dismiss];
        
    }];
    if (!view) {
        [view addSubview:minimalNotification];
    }else {
        [[UIApplication sharedApplication].keyWindow addSubview:minimalNotification];
    }
    
    return minimalNotification;
}
+ (NSString *)currentTimeWithFormat:(NSString *)format {
    if (format == nil) {
        format = @"yyyy-MM-dd HH:mm:ss";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:format];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}

+ (NSDate *)dataFromString:(NSString *)time withFormat:(NSString *)format {
    if (format == nil) {
        format = @"yyyy-MM-dd HH:mm:ss";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:format];
    
    NSDate *date = [dateFormatter dateFromString:time];
    
    return date;
}

+ (NSString *)timeWithTime:(NSString *)time beforeFormat:(NSString *)before andAfterFormat:(NSString *)after {
    NSDate *date = [self dataFromString:time withFormat:before];
    NSString *result = [self timeWithDate:date andFormat:after];
    return result;
}
+ (NSString *)delayTime:(NSString*)time andEndTime:(NSString*)endTime {
   
    long l = [time longLongValue];
    NSString *hour = [NSString stringWithFormat:@"%ld",l/3600];
    NSString *second = [NSString stringWithFormat:@"%ld",l%3600/60];
    if (l/3600 < 10) {
        hour = [NSString stringWithFormat:@"0%@",hour];
    }
    if (l%3600/60 < 10) {
        second = [NSString stringWithFormat:@"0%@",second];
    }
    NSString * timeString = [NSString stringWithFormat:@"%@时%@分",hour,second];
    if (l<60) {
        timeString = @"00时01分";
    }
    return timeString;
}

// 获得当天的日期 前一天或者后一天
+(NSString *)getNowDate:(NSInteger)day {
    
    //得到当前的时间
    NSDate * mydate = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:mydate];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    [adcomps setMonth:0];
    [adcomps setDay:day];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
    NSString *NewDate = [dateFormatter stringFromDate:newdate];
    
    return NewDate;
}
+(NSMutableAttributedString *)changeLabel:(NSString*)changeString wholeString:(NSString*)wholeString{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:wholeString];
    NSRange range1 = [[string string] rangeOfString:changeString];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range1];
   
    return string;
}

+(NSMutableAttributedString *)changeLabel:(NSString*)changeString wholeString:(NSString*)wholeString font:(UIFont*)font color:(UIColor*)color{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:wholeString];
    NSRange range1 = [[string string] rangeOfString:changeString];
    [string addAttribute:NSForegroundColorAttributeName value:color?:[UIColor blackColor] range:range1];
    [string addAttribute:NSFontAttributeName value:font range:range1];
    
    return string;
}

//根据文字计算高度
+(CGFloat)calculateRowHeight:(NSString*)string width:(CGFloat)width{
    NSDictionary * dic =@{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGRect rect  =[string?:@"" boundingRectWithSize:CGSizeMake(width-10, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
}
@end
