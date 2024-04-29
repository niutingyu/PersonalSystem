//
//  AppDelegate.m
//  ServiceSysterm
//
//  Created by Andy on 2019/4/20.
//  Copyright © 2019 SLPCB. All rights reserved.
//

#import "AppDelegate.h"

#import "LoginViewController.h"
#import "BaseNavViewController.h"
#import "MainTabbarController.h"
#import <IQKeyboardManager.h>
#import <AdSupport/AdSupport.h>
#import <UserNotifications/UserNotifications.h>
#import "TopAlertView.h"
#import "RGBA.h"
#import "PDKeyChain.h"

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupJPush:launchOptions];
    [[IQKeyboardManager sharedManager]setEnable:YES];
    [[UITabBar appearance] setTranslucent:NO];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    NSString * useId = USERDEFAULT_object(USERID);
    
    NSKeyedUnarchiver * modleArchiver = [Units readDateFromDiskWithPathStr:@"keypath"];
    NSArray * moudleStatus = [modleArchiver decodeObjectForKey:@"moudle"];
    [modleArchiver finishDecoding];
    if (useId.length == 0 ||moudleStatus.count  ==0) {
        BaseNavViewController * nav = [[BaseNavViewController alloc]initWithRootViewController:[LoginViewController new]];
        self.window.rootViewController = nav;
    }else{
        //判断网址是否改变
        NSString * url = USERDEFAULT_object(@"url");
        if (![url isEqualToString:ServerAddress]&&![url isEqualToString:NetworkServerAddress]) {
            BaseNavViewController * nav = [[BaseNavViewController alloc]initWithRootViewController:[LoginViewController new]];
            self.window.rootViewController = nav;
        }else{
         UIStoryboard * stroyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         MainTabbarController * tabController = [stroyboard instantiateViewControllerWithIdentifier:@"tabar"];
          self.window.rootViewController = tabController;
        }
        
    }
   
    //SL.ServiceSysterm
  //  [[PgyManager sharedPgyManager] startManagerWithAppId:Pgy_APPKEY];
    return YES;
}

-(void)setupJPush:(NSDictionary*)launchOptions{
    //监听网络
    [self listenNetWork];
    //NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // 3.0.0及以后版本注册
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //      NSSet<UNNotificationCategory *> *categories;
        //      entity.categories = categories;
        //    }
        //    else {
        //      NSSet<UIUserNotificationCategory *> *categories;
        //      entity.categories = categories;
        //    }
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //如果使用地理围栏，请先获取地理位置权限。
   // [self getLocationAuthority];
    //如果使用地理围栏功能，需要注册地理围栏代理
   // [JPUSHService registerLbsGeofenceDelegate:self withLaunchOptions:launchOptions];
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            if (![PDKeyChain keyChainLoad]) {
                [PDKeyChain keyChainSave:[JPUSHService registrationID]];
            }
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    
}

#pragma mark ---  监听网络

-(void)listenNetWork{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // wifi
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown) {
            TopAlertView * alert = [[TopAlertView alloc]initWithStyle:[UIColor redColor]];
            alert.headerTitle = @"错误";
            alert.contentText =@"当前网络不可用";
            [alert beginTimer];
//            [NotificationUtil showErrorWithTitle:@"错误" andSubTitle:@"当前网络不可用" andView:self.window];
        }
    }];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    //判断下网址  ，登录之后保存id 程序不走登录接口
    NSString * url = USERDEFAULT_object(@"url");
    if (![url isEqualToString:ServerAddress]&&![url isEqualToString:NetworkServerAddress]) {
        BaseNavViewController * nav = [[BaseNavViewController alloc]initWithRootViewController:[LoginViewController new]];
        self.window.rootViewController = nav;
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
#if TARGET_IPHONE_SIMULATOR
    
#elif TARGET_OS_IPHONE
   // [self isLoginOnOtherPlace];
#endif
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark = =JPush

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(10.0)){
    if (@available(iOS 10.0, *)) {
        if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            //从通知界面直接进入应用
        }else{
            //从通知设置界面进入应用
        }
    } else {
        // Fallback on earlier versions
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
            //这里的方法是收到通知
            
            //判断app状态 是否 活跃 后台运行 在这里可以做个弹出框 判断账号是否在别处登录
            UIApplicationState state = [UIApplication sharedApplication].applicationState;
            if(state == UIApplicationStateActive){
                //取出推送的值
                NSString * type = [userInfo objectForKey:@"pushType"];
                if([type isEqualToString:@"3"]){
                    //3代表账号在别处登录
                    [Units showWarningWithTitle:@"警告" andSubTitle:@"你的账号已在其他地方登录" andView:self.window];
                    //跳转到登录页面
                    
                    self.window.rootViewController = [LoginViewController new];
                }
                
            }
            
        }
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    }
    // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
    
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
       //收到通知 在这里处理 这个方法是点击了通知,所有的通知跳转都在登录的基础上才能跳转到指定页面。没登录条道登录页面登录
        NSString * type = [userInfo objectForKey:@"pushType"];
        if([type isEqualToString:@"3"]){
        //3代表账号在别处登录
        [Units showWarningWithTitle:@"警告" andSubTitle:@"你的账号已在其他地方登录" andView:self.window];
        //跳转到登录页面
        
        self.window.rootViewController = [LoginViewController new];
        }
        
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    
   
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];

}

#pragma mark --- 检测是否在别处登录

-(void)isLoginOnOtherPlace{
    NSString * alias = [PDKeyChain keyChainLoad];
    NSString * jobNum = USERDEFAULT_object(JOBNUM);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (alias &&jobNum) {
        [params setObject:jobNum forKey:@"jobNum"];
        [params setObject:alias?:@"iOS66666666666" forKey:@"alias"];
        KWeakSelf
        [HttpTool POST:[OtherPlaceLogin  getWholeUrl] param:params success:^(id  _Nonnull responseObject) {
            if ([[responseObject objectForKey:@"error"]integerValue]== 0) {
                if ([[responseObject objectForKey:@"msg"] isEqualToString:@"失败"]) {
                    [Units showWarningWithTitle:@"警告" andSubTitle:@"你的账号已在别处登录" andView:weakSelf.window];
                    
                }
            }
        } error:^(NSString * _Nonnull error) {
            
        }];
        
    }
    
}


//- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
