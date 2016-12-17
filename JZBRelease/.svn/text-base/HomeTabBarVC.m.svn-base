//
//  HomeTabBarVC.m
//  JZBRelease
//
//  Created by zjapple on 16/5/17.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "HomeTabBarVC.h"
#import "LocalDataRW.h"

#import "ZJBHelp.h"

#import "LiveVideoViewController.h"

#import "HomeTabBarVM.h"
#import "LocalDataRW.h"
#import "XBVideoAndVoiceVC.h"

#import "updateTabBarBadge.h"

@implementation HomeTabBarVC

- (instancetype)init{
    self = [super init];
    if (self) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        self = [story instantiateViewControllerWithIdentifier:@"HomeTabBarVC"];
        [ZJBHelp getInstance].homeTabBarVC = self;
    }
    return self;
}

- (void)viewDidLoad {
    
    UIApplication *ap = [UIApplication sharedApplication];
    
    ap.statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置自己身上的按钮
    [self setUpButtons];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MessageComing) name:@"MessageComing" object:nil];
    UserInfo *userInfo = [[LoginVM getInstance] readLocal];
    
    NSString *username = [NSString stringWithFormat:@"member_%@",userInfo._id];
    
    if (userInfo) {
         [LoginVM getInstance].jumpToTab = ^(int state,NSString *info){
        
        /** 自动登录 */
        
//        EMError *error = [[EMClient sharedClient] loginWithUsername:username password:@"123456"];
//        if (!error) {
//            NSLog(@"登录成功");
//        }
        
        
        
        
         };
        [[LoginVM getInstance] loginWithUserInfo:userInfo];
    }
    
}

#pragma mark -  设置按钮
- (void)setUpButtons
{
    
    for (int i = 0; i < self.childViewControllers.count; ++i) {
        [HomeTabBarVM setUpButtons:i :self.childViewControllers[i]];
    }
}

-(void)MessageComing{
    
    NSNumber *messageCount = [LocalDataRW returnCountWithType:@"dynamic_reply"];
    
    if ([messageCount intValue] != 0) {
        
        UINavigationController *navVC = self.childViewControllers[2];
        
//        navVC.tabBarItem.badgeValue = @"N";
        navVC.tabBarItem.badgeValue = [updateTabBarBadge updateTabBarBadgeNum];
        
        return;
    }
   
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MessageComing" object:nil];
    
}

- (BOOL)shouldAutorotate
{
    UINavigationController *nav = (UINavigationController *)self.viewControllers[0];
    GLLog(@"%@=-=-=%@",nav,nav.topViewController)
    if ([nav.topViewController isKindOfClass:[XBVideoAndVoiceVC class]] || [nav.topViewController isKindOfClass:[LiveVideoViewController class]]) {
        GLLog(@"%@=-=-=%@",nav,nav.topViewController)
        return nav.topViewController.shouldAutorotate;
    }
    
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

@end
