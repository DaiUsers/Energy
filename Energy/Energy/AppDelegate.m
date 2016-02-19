//
//  AppDelegate.m
//  Energy
//
//  Created by qianfeng on 15/11/5.
//  Copyright (c) 2015年 wheng. All rights reserved.
//

#import "AppDelegate.h"
#import "RecommendViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - 分享

- (void)initUM {
    [UMSocialData setAppKey:@"563f3532e0f55a0a7e009928"];
    //设置微信AppId、appSecret，分享url
    //在微信申请的appid 和 appsecret 并将appid设为应用URLscheme
    [UMSocialWechatHandler setWXAppId:@"wx4e1cc508aedca8d6" appSecret:@"d4624c36b6795d1d99dcf0547af5443d" url:@"http://www.baidu.com"];
    //微博
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //qq
    [UMSocialQQHandler setQQWithAppId:@"1104954864" appKey:@"TYzf0dtbssjnLIed" url:@"http://www.baidu.com"];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return  [UMSocialSnsService handleOpenURL:url];
}

#pragma mark - app didfinishlaunching

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    //远程通知
    //[self resgisterRemoteNotification];
    //本地通知
    //[self locationRegister];
    
    [self initUM];
    
    
    RecommendViewController *rvc = [[RecommendViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rvc];
    self.window.rootViewController = nav;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
//
//- (void)resgisterRemoteNotification {
//    //要向苹果的推送服务器 apns 注册
//    if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0) {//让用户授权 通知配置
//        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert| UIUserNotificationTypeBadge| UIUserNotificationTypeSound categories:nil]];
//        //苹果服务器 会给当前app 一个 deviceToken
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//    } else {
//        //8.0之前
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
//    }
//}
////远程推送 注册成功
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {//apns 返回一个 deviceToken
//    NSLog(@"%@",deviceToken);
//}
////注册失败
//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    //失败原因：
//    //用户不允许执行此方法
//    //使用模拟器
//    //证书问题
//}
//
////接收到远程推送通知
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    application.applicationIconBadgeNumber = 0;//小标置为0
//    NSLog(@"%@",userInfo);
//}

#pragma mark - 本地推送
//本地推送
- (void)locationRegister {
    
#ifdef __IPHONE_8_0
    
    //申请用户的许可,注册用户通知的设置
    //UIUserNotificationTypeAlert 警告框
    //UIUserNotificationTypeSound  声音
    //UIUserNotificationTypeBadge  应用程序角标
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
#endif
    
}
//向本地系统 成功之后 回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
    if(notificationSettings.types != UIUserNotificationTypeNone){
        //注册本地通知
        UILocalNotification *localNotification = [[UILocalNotification alloc]init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
        NSDate *date = [formatter dateFromString:@"2015/11/10 09:00:00"];
        //触发的时间
        localNotification.fireDate = [NSDate dateWithTimeIntervalSince1970:[date timeIntervalSince1970]];
        //警告框的信息
        localNotification.alertBody = @"懒虫，起床了";
        //本地事件触发时的播放的声音
        localNotification.soundName = @"pushmsg.caf";
        
        //应用程序的角标
        localNotification.applicationIconBadgeNumber = 1;
        
        //把本地的通知调度到系统中去，这样无论我的应用程序是否启动，都会在指定的时间通知我们
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    

}


//当应用程序在前台时，本地推送会通过该代理方法传递给我们
//以及当我的应用程序在后台（没死），收到本地通知，用户点击通知，该代理方法也会被调用
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    //判断应用程序的状态
    //UIApplicationStateActive 说明应用程序在前台时收到的通知
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if(application.applicationState == UIApplicationStateActive)
    {
        UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:notification.alertBody delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alterView show];
    }else if(application.applicationState == UIApplicationStateInactive)
    {
        //应用程序处于不活跃状态时收到到的本地通知
        NSLog(@"再次激活时的业务处理");
    }else{
        //后台模式
        NSLog(@"后台模式");
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
