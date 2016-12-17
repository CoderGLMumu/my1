//
//  HomeTabBarVM.m
//  JZBRelease
//
//  Created by zjapple on 16/8/31.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "HomeTabBarVM.h"

@implementation HomeTabBarVM

#pragma mark -  设置按钮
+ (void)setUpButtons:(NSUInteger)index :(UINavigationController *)nav
{
    
    switch (index) {
        case 2:
            // 设置"帮吧"按钮样式
            nav.tabBarItem.title = @"帮吧";
            nav.tabBarItem.image = [UIImage imageOriRenderNamed:@"table_BB"];
            nav.tabBarItem.selectedImage = [UIImage imageOriRenderNamed:@"table_BB_choose"];
            break;
            // 设置"消息"按钮样式
        case 3:
            nav.tabBarItem.title = @"聊吧";
//            nav.tabBarItem.badgeValue = @"N";
            nav.tabBarItem.image = [UIImage imageOriRenderNamed:@"table_XX"];
            nav.tabBarItem.selectedImage = [UIImage imageOriRenderNamed:@"table_XX_choose"];
            break;
        case 1:
            // 设置"资讯"按钮样式
            nav.tabBarItem.title = @"资讯";
            nav.tabBarItem.image = [UIImage imageOriRenderNamed:@"table_NewsInfo"];
            nav.tabBarItem.selectedImage = [UIImage imageOriRenderNamed:@"table_NewsInfo_choose"];
            break;
            // 设置"学吧"按钮样式
        case 0:
            nav.tabBarItem.title = @"学吧";
            nav.tabBarItem.image = [UIImage imageOriRenderNamed:@"table_XB"];
            nav.tabBarItem.selectedImage = [UIImage imageOriRenderNamed:@"table_XB_choose"];
            break;
            // 设置"我的"按钮样式
        case 4:
            nav.tabBarItem.title = @"我的";
            nav.tabBarItem.image = [UIImage imageOriRenderNamed:@"table_mine"];
            nav.tabBarItem.selectedImage = [UIImage imageOriRenderNamed:@"table_mine_choose"];
            break;
            
        default:
            break;
    }
}

@end
