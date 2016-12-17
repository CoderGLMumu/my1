//
//  AppDelegate.h
//  JZBRelease
//
//  Created by zjapple on 16/4/20.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "VipModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SocialViewController *mainController;

/** checkpay */
@property (nonatomic, assign) BOOL checkpay;
/** notAutoLogin */
@property (nonatomic, assign) BOOL notAutoLogin;
/** userCurrentLocal */
@property (nonatomic, strong) NSString *userCurrentLocal;
/** vip */
@property (nonatomic, strong) VipModel *vip;
/** vip */
@property (nonatomic, strong) NSString *payType;
/** vip */
@property (nonatomic, strong) NSString *UDID;

/** 问答语音开关 */
@property (nonatomic, assign) BOOL audioSwitch;


@end

