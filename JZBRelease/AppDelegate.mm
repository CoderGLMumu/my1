//
//  AppDelegate.m
//  JZBRelease
//
//  Created by zjapple on 16/4/20.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginVM.h"
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
#import "ValuesFromXML.h"
#import "LocalDataRW.h"
#import "SlideNavigationController.h"

#import <CoreLocation/CoreLocation.h>
#import "UserLocalAndPush.h"

#import "EMSDK.h"
#import "AppDelegate+UMeng.h"
#import "AppDelegate+EaseMob.h"
#import "AlipaySDK.h"
#import "RedPacketUserConfig.h"
#import "RedpacketOpenConst.h"
#import "AppDelegate+Parse.h"

#import "SVProgressHUD.h"
#import "NSString+Hash.h"
#import "LoginVM.h"
#import "HomeTabBarVC.h"
#import "CusNaviVC.h"
#import "LoginVC.h"
#import "HXDataHelper.h"
#import "BaiduMobStat.h"
#import "AlipaySDK.h"
#import "WXApiManager.h"

#import "payForAlipay.h"
#import "payForWechat.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

#import "AliVcMoiveViewController.h"
#import <AliyunPlayerSDK/AliVcMediaPlayer.h>
#import "AlivcLiveViewController.h"
#import <AlivcLiveVideo/AlivcLiveVideo.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

//人人SDK头文件
//#import <RennSDK/RennSDK.h>
#import "PushextrasItem.h"
#import "GLSaveTool.h"
#import "NewFeatureViewController.h"
#define GLCurVersion @"CurVersion"

//#define isProduction YES

//#define isProduction NO

#import "SGNetObserver.h"
#import "StartPageVC.h"

@interface AppDelegate ()<CLLocationManagerDelegate,AliVcAccessKeyProtocol,JPUSHRegisterDelegate,WXApiDelegate>{
    BMKMapManager* _mapManager;
}
/** 网络判断 网络监听 */
@property (nonatomic,strong) SGNetObserver *observer;

/** 位置管理者 */
@property (nonatomic ,strong) CLLocationManager *locationM;

/** isAutoLogin */
@property (nonatomic, assign) BOOL isFirstLogin;
/** username */
@property (nonatomic, strong) NSString *username;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
     
    self.UDID = [[UIDevice currentDevice] identifierForVendor].UUIDString;
     
    [self setupNetworkStatus];
    
    [self setSwitchAttr];
    
    [self setUpFMDB];
    
    [self setUpShareSDK];
    
    [self setupSVPHub];
    
    [self checkIOSPay];
    
    [AliVcMediaPlayer setAccessKeyDelegate:self];
    
    //向微信注册
    [WXApi registerApp:@"wx80b16d8b06406025" withDescription:@"com.jzb.release"];
    
    //百度统计
    BaiduMobStat *stat = [BaiduMobStat defaultStat];
    stat.shortAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    stat.monitorStrategy = BaiduMobStatMonitorStrategyAll;
    [stat startWithAppId:@"d4e6d706f2"];

    //百度地图
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"uBLsm8Ssq8niGLoBTQSr6L8U1fiQLbc5" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    _locationM = [[CLLocationManager alloc] init];
    _locationM.distanceFilter = kCLDistanceFilterNone;
    
    _locationM.desiredAccuracy = kCLLocationAccuracyBest;
    
//    [UIApplication sharedApplication].idleTimerDisabled = TRUE;
//    CLLocationManager *locationmanager = [[CLLocationManager alloc] init];
//    [locationmanager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
//    [locationmanager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
//    locationmanager.delegate = self;
    
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge | UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //Required
    // init Push(2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil  )
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。

    [JPUSHService setupWithOption:launchOptions appKey:[ValuesFromXML getValueWithName:@"JPushAppKey" WithKind:XMLTypeNetPort]
                          channel:@"zjb_channel"
                 apsForProduction:[ValuesFromXML getValueWithName:@"isProduction" WithKind:XMLTypeNetPort].boolValue
            advertisingIdentifier:nil];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
//   
//    [JPUSHService crashLogON];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0)
        {
            // iOS10获取registrationID放到这里了, 可以存到缓存里, 用来标识用户单独发送推送
            NSLog(@"registrationID获取成功：%@",registrationID);
            [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"registrationID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    

    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    
    NSLog(@"identifier %@",identifier);
    
    //[NSTimer scheduledTimerWithTimeInterval:12 target:self selector:@selector(sendMessage) userInfo:nil repeats:NO];
    
    
#ifdef REDPACKET_AVALABLE
    /**
     *  TODO: 通过环信的AppKey注册红包
     */
    [[RedPacketUserConfig sharedConfig] configWithAppKey:[ValuesFromXML getValueWithName:@"HXAppKey" WithKind:XMLTypeNetPort]];
#endif
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:[ValuesFromXML getValueWithName:@"HXAppKey" WithKind:XMLTypeNetPort]];
    //    options.apnsCertName = @"istore_dev";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        // 设置topView和状态栏的颜色
        //[[UINavigationBar appearance] setBarTintColor:RGBACOLOR(130, 167, 252, 1)];
        
        //[[UINavigationBar appearance] setTitleTextAttributes:
         //[NSDictionary dictionaryWithObjectsAndKeys:RGBACOLOR(245, 245, 245, 1), NSForegroundColorAttributeName, [UIFont fontWithName:@ "HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    }
    
    // 环信UIdemo中有用到友盟统计crash，您的项目中不需要添加，可忽略此处。
    [self setupUMeng];
    
    // 环信UIdemo中有用到Parse，您的项目中不需要添加，可忽略此处。
    //    [self parseApplication:application didFinishLaunchingWithOptions:launchOptions];
    
#warning 初始化环信SDK，详细内容在AppDelegate+EaseMob.m 文件中
#warning SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"chatdemoui_dev";
#else
    apnsCertName = @"chatdemoui";
#endif
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *appkey = [ud stringForKey:@"identifier_appkey"];
    if (!appkey) {
        appkey = @"jianzhong#jianzhong";
        [ud setObject:appkey forKey:@"identifier_appkey"];
    }
    
    [self easemobApplication:application
didFinishLaunchingWithOptions:launchOptions
                      appkey:appkey
                apnsCertName:apnsCertName
                 otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    
    
    //加载首页
    UserInfo *userInfo = [[LoginVM getInstance] readLocal];
    
    NSString *username = [NSString stringWithFormat:@"member_%@",userInfo._id];
     self.username = username;
    
    NSUserDefaults *defautls = [NSUserDefaults standardUserDefaults];
    
    self.notAutoLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"notAutoLogin"];
    
    //获取之前保存的版本号
    //NSString *preV = [[NSUserDefaults standardUserDefaults] objectForKey:XMGCurVersion];
    NSString *preV = [GLSaveTool objectForKey:GLCurVersion];
    
    //获取当前软件的版本号
    NSString *curV =  [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    //NSLog(@"curV==%@",curV);
    //判断当前版本是否与之前的版本相同
     
    if ([curV isEqualToString:preV]) {
        //相同,跳到程序的主框架
        //2.设置窗口的根控制器
        
        if (userInfo &&!self.notAutoLogin) {
            // [LoginVM getInstance].jumpToTab = ^(int state){
            
            /** 自动登录 */
             
             self.isFirstLogin = YES;
             StartPageVC *vc = [StartPageVC new];
             self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
             self.window.rootViewController = vc;//配置window窗口的rootViewController实例
             //判定系统版本，选择页面加载方式
             
             [self.window makeKeyAndVisible];
            
            
        }else{
            if (!self.checkpay) {
                HomeTabBarVC *tabVC = [[HomeTabBarVC alloc]init];
                [tabVC.view setBackgroundColor:[UIColor whiteColor]];
                tabVC.selectedIndex = 0;
                self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
                self.window.rootViewController = tabVC;//配置window窗口的rootViewController实例
                //判定系统版本，选择页面加载方式
                [self.window makeKeyAndVisible];

            }
            LoginVC *loginVC = [[LoginVC alloc]init];
            loginVC.isClearPassword = YES;
            UINavigationController *naviVC = [[UINavigationController alloc]initWithRootViewController:loginVC];
            self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
            self.window.rootViewController = naviVC;//配置window窗口的rootViewController实例
            //判定系统版本，选择页面加载方式
            
            [self.window makeKeyAndVisible];
            [[UserLocalAndPush shareUserLocalAndPush] setupLocation];
            self.notAutoLogin = NO;
            
            
            [defautls setBool:self.notAutoLogin forKey:@"notAutoLogin"];
            
        }
        
//        self.checkpay = YES;
        
    }else {
        //review with free login
        
        
        //不同,跳到新特性,保存当前的版本号
        //创建CollectionView
        //1.创建窗口
        
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        NewFeatureViewController *collectVc = [[NewFeatureViewController alloc] init];
//        collectVc.collectionView.backgroundColor = [UIColor greenColor];
        self.window.rootViewController = collectVc;
//        [[NSUserDefaults standardUserDefaults] setObject:curV forKey:XMGCurVersion];
        [GLSaveTool setObject:curV forKey:GLCurVersion];
        
        
        [[UserLocalAndPush shareUserLocalAndPush] setupLocation];
        self.notAutoLogin = NO;
        
        
        [defautls setBool:self.notAutoLogin forKey:@"notAutoLogin"];
        [[UserLocalAndPush shareUserLocalAndPush] setupLocation];
        self.notAutoLogin = NO;
        
        
        //3.显示窗口
        [self.window makeKeyAndVisible];
    }
    
    // 启动页延迟
    //[NSThread sleepForTimeInterval:3.0];
    return YES;
}


/**
 设置系统模块开关
 */
- (void)setSwitchAttr{
    self.audioSwitch = YES;
}


#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
//        NSString *message = [NSString stringWithFormat:@"will%@", [userInfo[@"aps"] objectForKey:@"alert"]];
//        NSLog(@"iOS10程序在前台时收到的推送: %@", message);
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
//        NSString *message = [NSString stringWithFormat:@"did%@", [userInfo[@"aps"] objectForKey:@"alert"]];
//        NSLog(@"iOS10程序关闭后通过点击推送进入程序弹出的通知: %@", message);
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    if ([[UIDevice currentDevice].systemVersion floatValue] < 10.0 || application.applicationState > 0)
    {
        // 程序在前台或通过点击推送进来的会弹这个alert
//        NSString *message = [NSString stringWithFormat:@"iOS7-8-9收到的推送%@", [userInfo[@"aps"] objectForKey:@"alert"]];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
//        [alert show];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}



-(void)rigisterSuccess:(NSNotification *)notification{
    NSLog(@"通知[notification userInfo]:%@", [notification userInfo] );
}
-(void)loginSuccess:(NSNotification *)notification{
    NSLog(@"通知[notification userInfo]:%@", [notification userInfo] );
}
-(void)connectSuccess:(NSNotification *)notification{
    NSLog(@"通知[notification userInfo]:%@", [notification userInfo] );
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString *contentType = [userInfo valueForKey:@"content_type"];
     if (!contentType) {
          return;
     }

    [LocalDataRW addCountWithType:contentType];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageComing" object:self userInfo:nil];
    NSLog(@"收到通知:%@", contentType);
    //NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
    
    if ([contentType isEqualToString:@"circle_forbid"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageBanSpeak" object:self userInfo:extras];
        NSUserDefaults *udefaults = [NSUserDefaults standardUserDefaults];
        [udefaults setObject:extras forKey:extras[@"groupid"]];
//        [[HXuserDefault alloc]initWithDict:extras];
    }
    
    // 新好友
    if ([contentType isEqualToString:@"friend_add"]) {
        
        NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
        NSInteger num = [udefault integerForKey:@"MessageFriend"];
        
        num++;
        
        [udefault setInteger:num forKey:@"MessageFriend"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageFriend_add" object:self userInfo:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageFriend_add" object:nil];
//        NSUserDefaults *udefaults = [NSUserDefaults standardUserDefaults];
//        [udefaults setObject:extras forKey:extras[@"groupid"]];
//        NSLog(@"接受申请好友");
    }
    // 新好友
    if ([contentType isEqualToString:@"friend_agree"]) {
        
        NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
        NSInteger num = [udefault integerForKey:@"MessageFriend"];
        
        num++;
        
        [udefault setInteger:num forKey:@"MessageFriend"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageFriend_agree" object:self userInfo:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageFriend_agree" object:nil];
//        NSUserDefaults *udefaults = [NSUserDefaults standardUserDefaults];
//        [udefaults setObject:extras forKey:extras[@"groupid"]];
//        NSLog(@"同意申请好友");
    }
    
    // 新商机
    if ([contentType isEqualToString:@"activity_new"]) {
        
        NSMutableArray *arrM = [NSMutableArray array];
        
        NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
        
        [arrM addObjectsFromArray: [NSKeyedUnarchiver unarchiveObjectWithFile:CachesNotificationActivity]];
        
        PushextrasItem *item = [PushextrasItem mj_objectWithKeyValues:extras];
        item.content = content;
        
        [arrM insertObject:item atIndex:0];
        
        [NSKeyedArchiver archiveRootObject:arrM toFile:CachesNotificationActivity];
        
        NSInteger num = [udefault integerForKey:@"Message_activity_newNum"];
        num++;
        [udefault setInteger:num forKey:@"Message_activity_newNum"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Message_activity_new" object:self userInfo:nil];

    }
    
    // 新审核
    if ([contentType isEqualToString:@"activity_audit"]) {
        
        //        NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
        //        NSInteger num = [udefault integerForKey:@"MessageFriend"];
        //
        //        num++;
        //
        //        [udefault setInteger:num forKey:@"MessageFriend"];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageFriend_activity_audit" object:self userInfo:nil];
        
    }
    
    // 新提问
    if ([contentType isEqualToString:@"question_new"]) {
        
        NSMutableArray *arrM = [NSMutableArray array];
        
        NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
        

        [arrM addObjectsFromArray: [NSKeyedUnarchiver unarchiveObjectWithFile:CachesNotificationQuestion]];
        
        PushextrasItem *item = [PushextrasItem mj_objectWithKeyValues:extras];
        item.content = content;
        [arrM insertObject:item atIndex:0];
        
        [NSKeyedArchiver archiveRootObject:arrM toFile:CachesNotificationQuestion];
        
//        NSString *paths = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/GLcache"];
//        NSLog(@"Caches: %@", paths);
//        NSString *personsArrPath = [paths stringByAppendingString:@"/personsArr.plist"];
//        [NSKeyedArchiver archiveRootObject:arrM toFile:personsArrPath];
        
//        NSArray *newPersonsArr = [NSKeyedUnarchiver unarchiveObjectWithFile:personsArrPath];
        
        
        
//        NSLog(@"反归档: %@", newPersonsArr);
        
        NSInteger num = [udefault integerForKey:@"Message_question_newNum"];
        num++;
        [udefault setInteger:num forKey:@"Message_question_newNum"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Message_question_new" object:self userInfo:nil];
        
    }
    
    // 评论-打赏-点赞
    if ([contentType isEqualToString:@"question_reply"]) {
        
        NSMutableArray *arrM = [NSMutableArray array];
        
        NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
        
        [arrM addObjectsFromArray: [NSKeyedUnarchiver unarchiveObjectWithFile:CachesNotificationQuestion]];
        
        PushextrasItem *item = [PushextrasItem mj_objectWithKeyValues:extras];
        item.content = content;
        [arrM insertObject:item atIndex:0];
        
        [NSKeyedArchiver archiveRootObject:arrM toFile:CachesNotificationQuestion];
        
        NSInteger num = [udefault integerForKey:@"Message_question_newNum"];
        num++;
        [udefault setInteger:num forKey:@"Message_question_newNum"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Message_question_new" object:self userInfo:nil];
        
    }
    
    // 采纳答案
    if ([contentType isEqualToString:@"question_use"]) {
        
        NSMutableArray *arrM = [NSMutableArray array];
        
        NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
        
        [arrM addObjectsFromArray: [NSKeyedUnarchiver unarchiveObjectWithFile:CachesNotificationQuestion]];
        
        PushextrasItem *item = [PushextrasItem mj_objectWithKeyValues:extras];
        item.content = content;
        [arrM insertObject:item atIndex:0];
        
        [NSKeyedArchiver archiveRootObject:arrM toFile:CachesNotificationQuestion];
        
        NSInteger num = [udefault integerForKey:@"Message_question_newNum"];
        num++;
        [udefault setInteger:num forKey:@"Message_question_newNum"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Message_question_new" object:self userInfo:nil];
        
    }
    
    // 推荐人
    if ([contentType isEqualToString:@"user_reference"]) {
        
//        NSMutableArray *arrM = [NSMutableArray array];
        
        NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
        
//        [arrM addObjectsFromArray: [NSKeyedUnarchiver unarchiveObjectWithFile:CachesNotificationReference]];
        
//        PushextrasItem *item = [PushextrasItem mj_objectWithKeyValues:extras];
//        item.content = content;
//        [arrM insertObject:item atIndex:0];
//        
//        [NSKeyedArchiver archiveRootObject:arrM toFile:CachesNotificationReference];
        
        NSInteger num = [udefault integerForKey:@"Message_reference_newNum"];
        num++;
        [udefault setInteger:num forKey:@"Message_reference_newNum"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Message_reference_new" object:self userInfo:nil];
        
    }
     
     // 学吧直播课程
     if ([contentType isEqualToString:@"course_new"]) {
          
          NSMutableArray *arrM = [NSMutableArray array];
          
          NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
          
          [arrM addObjectsFromArray: [NSKeyedUnarchiver unarchiveObjectWithFile:CachesNotificationLiveTime]];
          
          PushextrasItem *item = [PushextrasItem mj_objectWithKeyValues:extras];
          item.content = content;
          [arrM insertObject:item atIndex:0];
          
          [NSKeyedArchiver archiveRootObject:arrM toFile:CachesNotificationLiveTime];
          
          NSInteger num = [udefault integerForKey:@"Message_course_LivenewNum"];
          num++;
          [udefault setInteger:num forKey:@"Message_course_LivenewNum"];
          
          [[NSNotificationCenter defaultCenter] postNotificationName:@"Message_course_Livenew" object:self userInfo:nil];
          
     }
     
     // 学吧音视频课程
     if ([contentType isEqualToString:@"course_tips"]) {
          
          NSMutableArray *arrM = [NSMutableArray array];
          
          NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
          
          [arrM addObjectsFromArray: [NSKeyedUnarchiver unarchiveObjectWithFile:CachesNotificationCourseNow]];
          
          PushextrasItem *item = [PushextrasItem mj_objectWithKeyValues:extras];
          item.content = content;
          [arrM insertObject:item atIndex:0];
          
          [NSKeyedArchiver archiveRootObject:arrM toFile:CachesNotificationCourseNow];
          
          NSInteger num = [udefault integerForKey:@"Message_course_NownewNum"];
          num++;
          [udefault setInteger:num forKey:@"Message_course_NownewNum"];
          
          [[NSNotificationCenter defaultCenter] postNotificationName:@"Message_course_Nownew" object:self userInfo:nil];
          
     }
    
//    [SVProgressHUD showInfoWithStatus:@"收到通知"];
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    /// Required - 注册 DeviceToken
    NSLog(@"My token is: %@", deviceToken);
     
//     self.deviceToken = [deviceToken base64Encoding];
     
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   // [[UIScreen mainScreen] setBrightness: 0.5];//0.5是自己设定认为比较合适的亮度值
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
        //[[LoginVM getInstance] loginWithUserInfo:[[LoginVM getInstance] readLocal]];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
   
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setUpFMDB
{
    [GLFMDBToolSDK shareToolsWithCreateDDL:@"CREATE TABLE if not exists t_HXFriendDataSource ( uid text, nickname text, HXid text, UserModel blob );"];
    [GLFMDBToolSDK shareToolsWithCreateDDL:@"CREATE TABLE if not exists t_HXapplyFriendItems ( _id text, recode_uid text, message_content text, recode_u_avatar text, recode_u_nickname text, create_time text, status text,type text, ustate text, isConfirm bit );"];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        
//    });
}

- (void)setUpShareSDK
{
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"172fd1942d4f4"
     
          activePlatforms:@[
//                            @(SSDKPlatformTypeSinaWeibo),
//                            @(SSDKPlatformTypeMail),
//                            @(SSDKPlatformTypeSMS),
//                            @(SSDKPlatformTypeCopy),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
//                            @(SSDKPlatformTypeRenren),
//                            @(SSDKPlatformTypeGooglePlus)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             case SSDKPlatformTypeRenren:
//                 [ShareSDKConnector connectRenren:[RennClient class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx80b16d8b06406025"
                                       appSecret:@"0b07847d19796cf5abaecc31bf386b8f"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"100371282"
                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                    authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeRenren:
                 [appInfo        SSDKSetupRenRenByAppId:@"226427"
                                                 appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
                                              secretKey:@"f29df781abdd4f49beca5a2194676ca4"
                                               authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeGooglePlus:
                 [appInfo SSDKSetupGooglePlusByClientID:@"232554794995.apps.googleusercontent.com"
                                           clientSecret:@"PEdFgtrMw97aCvf0joQj7EMk"
                                            redirectUri:@"http://localhost"];
                 break;
             default:
                 break;
         }
     }];
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

/** 支付宝相关-------------------------------------
 ------------------------------------------------
 ------------------------------------------------*/

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            GLLog(@"result = %@",resultDic);
//            [SVProgressHUD showInfoWithStatus:@"支付完成"];
            [payForAlipay payforShowCallBackInfo:resultDic];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IntegralDetailVCPay" object:self userInfo:resultDic];

            
        }];
    }else {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    
    
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            GLLog(@"result = %@",resultDic);
//            [SVProgressHUD showInfoWithStatus:resultDic.];
            [payForAlipay payforShowCallBackInfo:resultDic];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IntegralDetailVCPay" object:self userInfo:resultDic];

            
        }];
    }else if ([url.host isEqualToString:@"pay"]){
        return  [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

/** --------------------------------------------
 ------------------------------------------------
 -----------------------------------------支付宝相关*/


/** 微信相关-------------------------------------
 ------------------------------------------------
 ------------------------------------------------*/
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    //支付返回结果，实际支付结果需要去微信服务器端查询
    NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
    
    switch (resp.errCode) {
        case WXSuccess:
            if ([self.payType isEqualToString:@"2"]) {
                
                [[LoginVM getInstance]loginWithUserInfo:[[LoginVM getInstance]readLocal]];
            }
            strMsg = @"支付结果：成功！";
            GLLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//            [SVProgressHUD showInfoWithStatus:strMsg];
            break;
            
        default:
//            strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
            strMsg = [NSString stringWithFormat:@"支付结果：失败！"];
            GLLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
//            [SVProgressHUD showInfoWithStatus:strMsg];
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    if (resp.errCode == WXSuccess) {
        NSDictionary *dict = @{@"WXSuccess":@"支付成功"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IntegralDetailVCPay" object:self userInfo:dict];
    }
    
    
    
//    [SVProgressHUD showInfoWithStatus:@"支付完成"];
    
}


/** 微信相关-------------------------------------
 ------------------------------------------------
 ------------------------------------------------*/

//(recode_uid,message_content,recode_u_avatar,recode_u_nickname,create_time,status,type,ustate,isConfirm)


NSString* accessKeyID = @"LTAIfxiQB9ssFLZ3";
NSString* accessKeySecret = @"F0RVEZvuKm5Qp90j9ppE5yhxl3Cv3Z";

-(AliVcAccesskey*)getAccessKeyIDSecret
{
    AliVcAccesskey* accessKey = [[AliVcAccesskey alloc] init];
    accessKey.accessKeyId = accessKeyID;
    accessKey.accessKeySecret = accessKeySecret;
    return accessKey;
}

- (void)setupSVPHub
{
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];

}

- (void)checkIOSPay
{
//    NSDictionary *parameters = @{
//                                 @"access_token":[LoginVM getInstance].readLocal.token,
//                                 @"uid":@""
//                                 };
    
//    self.checkpay = YES;
    
    self.checkpay = NO;
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Version/checkIOSPay2"] parameters:nil success:^(id json) {
    
        NSDictionary *result = (NSDictionary *)json;
        
        NSString *data = result.allKeys[0];
        
        // 利哥不要改判断语句里面的代码啊，我都不知道判断啥了 要改 在下面改
        // == 0 self.checkpay = NO; == 1 self.checkpay = YES;
        
        if ([[result objectForKey:data] integerValue] == 0) {
            self.checkpay = NO;
        }else {
            // 返回 1 正常 支付
            self.checkpay = YES;
        }
       
    } failure:^(NSError *error) {
        
    }];
}

- (void)setupNetworkStatus
{
     self.observer = [SGNetObserver defultObsever];
     
     self.observer.failureTimes = 10;
     self.observer.interval = 3;
     
     [self.observer startNotifier];
     
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChanged:) name:SGReachabilityChangedNotification object:nil];
}

- (void)networkStatusChanged:(NSNotification *)notify{
     NSLog(@"notify-------%@",notify.userInfo);
     NSLog(@"self.observer5-------%lu",(unsigned long)self.observer.networkStatus);
     
//     SGNetworkStatusNone,
//     SGNetworkStatus3G,
//     SGNetworkStatus4G,
//     SGNetworkStatusWifi,
//     SGNetworkStatusUkonow
     
     if (self.observer.networkStatus == SGNetworkStatus3G || self.observer.networkStatus == SGNetworkStatus4G || self.observer.networkStatus == SGNetworkStatusWifi) {
          
          GLLog(@"1111111%lu",(unsigned long)self.observer.networkStatus)
          
          if (self.isFirstLogin) {
               EMError *error = [[EMClient sharedClient] loginWithUsername:self.username password:@"123456"];
               if (!error) {
                    NSLog(@"登录成功");
               }
               
               /** 开始定位 */
               //[wself setupLocation];
               
               /** 登录成功 获取环信好友数据 */
               [[HXDataHelper new]loadHXDataWithComplete:nil];
               
               HomeTabBarVC *tabVC = [[HomeTabBarVC alloc]init];
               [tabVC.view setBackgroundColor:[UIColor whiteColor]];
               tabVC.selectedIndex = 3;
//               self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
               self.window.rootViewController = tabVC;//配置window窗口的rootViewController实例
               //判定系统版本，选择页面加载方式
               [self.window makeKeyAndVisible];
               [[UserLocalAndPush shareUserLocalAndPush] setupLocation];
               
               self.isFirstLogin = NO;
               
               //};
               
               //[[LoginVM getInstance] loginWithUserInfo:userInfo];
          }
     }else {
          
          if (self.isFirstLogin) {
               GLLog(@"222222%lu",(unsigned long)self.observer.networkStatus)
               NSUserDefaults *defautls = [NSUserDefaults standardUserDefaults];
               
               LoginVC *loginVC = [[LoginVC alloc]init];
               loginVC.isFirstLogin = self.isFirstLogin;
//               loginVC.isClearPassword = YES;
               UINavigationController *naviVC = [[UINavigationController alloc]initWithRootViewController:loginVC];
//               self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
               self.window.rootViewController = naviVC;//配置window窗口的rootViewController实例
               //判定系统版本，选择页面加载方式
               
               [self.window makeKeyAndVisible];
               [[UserLocalAndPush shareUserLocalAndPush] setupLocation];
               self.notAutoLogin = NO;
               
               
               [defautls setBool:self.notAutoLogin forKey:@"notAutoLogin"];
               
               self.isFirstLogin = NO;
          }
     }
     
     
}

@end