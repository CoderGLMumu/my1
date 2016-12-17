//
//  LoginVM.m
//  JZBRelease
//
//  Created by zjapple on 16/5/17.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "LoginVM.h"
#import "AFNetworking.h"
#import "Defaults.h"
#import "AFHTTPSessionManager.h"
#import "HttpManager.h"
#import "DataBaseHelperSecond.h"
#import "JPUSHService.h"
@implementation LoginVM

+(instancetype) getInstance{
    static LoginVM *loginVM = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginVM = [[self alloc]init];
    });
    return loginVM;
}

-(BOOL)loginWithUserInfo : (UserInfo *) userInfo{
    if (!userInfo) {
        return NO;
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:userInfo.account forKey:@"username"];
    [param setObject:userInfo.password forKey:@"password"];
    [param setObject:userInfo.imei forKey:@"imei"];
    NSString *url = [[ValuesFromXML getValueWithName:@"Sever_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:[ValuesFromXML getValueWithName:@"Login_Relative" WithKind:XMLTypeNetPort]];
    
    [HttpManager requestWithUrlString:url parms:param finished:^(AFHTTPRequestOperation *oper, id responseObj) {
        NSLog(@"%@",responseObj);
        
        NSDictionary *dict = [[NSDictionary alloc]dictionaryWithJSON:responseObj];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            if ([[dict objectForKey:@"state"] intValue] == 0) {
                //返回block 提示账号密码有错误
                if (self.jumpToTab) {
                    self.jumpToTab(0,[dict objectForKey:@"info"]);
                }
                return ;
            }
            NSDictionary *subDict = [dict objectForKey:	@"data"];
            if ([subDict isKindOfClass:[NSDictionary class]]) {
                userInfo._id = [subDict objectForKey:@"id"];
                if (userInfo._id) {
                    NSSet *tags = [[NSSet alloc]initWithArray:@[[NSString stringWithFormat:@"member_%@",userInfo._id]]];
                    [JPUSHService  setTags:tags alias:[NSString stringWithFormat:@"member_%@",userInfo._id] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                        NSLog(@"iAlias %@",iAlias);
                    }];
                }
                userInfo.token = [subDict objectForKey:@"access_token"];
            }
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
        [self makeDir:userInfo.account];
        [defaults setObject:data forKey:@"UserInfo"];
        [defaults synchronize];
        
//        if (!self.userInfo) {
//            self.userInfo = userInfo;
//        }
        self.userInfo = userInfo;
        //[self.userInfo addObserver:self forKeyPath:@"userInfoChange" options:NSKeyValueObservingOptionNew context:nil];
        NSString *userUrl = [[ValuesFromXML getValueWithName:@"Sever_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:[ValuesFromXML getValueWithName:@"USER_INFO" WithKind:XMLTypeNetPort]];
        NSMutableDictionary *usrParam = [[NSMutableDictionary alloc]init];
        if (!userInfo.token) {
            return ;
        }
        [usrParam setObject:userInfo.token forKey:@"access_token"];
        [HttpManager requestWithUrlString:userUrl parms:usrParam finished:^(AFHTTPRequestOperation *oper, id responseObj) {
            NSDictionary *userDict = [[NSDictionary alloc]dictionaryWithJSON:responseObj];
            if (1 == [[userDict objectForKey:@"state"] longValue]) {
                NSDictionary *dataDict = [userDict objectForKey:@"data"];
                self.users = [Users mj_objectWithKeyValues:dataDict];
                if (!self.users.uid) {
                    self.users.uid = userInfo._id;
                }
                if ([[DataBaseHelperSecond getInstance] createTabel:self.users]) {
                    NSLog(@"创建表%@成功",NSStringFromClass([self.users class]));
                }
                if (![[DataBaseHelperSecond getInstance] isExistInTable:self.users]) {
                    if ([[DataBaseHelperSecond getInstance] insertModelToTabel:self.users]) {
                        NSLog(@"insert data 成功");
                    }
                }else{
                    if ([[DataBaseHelperSecond getInstance] delteModelFromTabel:self.users]) {
                        [[DataBaseHelperSecond getInstance] insertModelToTabel:self.users];
                        NSLog(@"alter data 成功");
                    }
                }
                AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
                appD.vip = self.users.vip;
                if(self.jumpToTab){
                    self.jumpToTab(1,[dict objectForKey:@"info"]);
                }
            }else{
                if (self.jumpToTab) {
                    self.jumpToTab(0,[dict objectForKey:@"info"]);
                }
            }
            
            
        } failed:^(AFHTTPRequestOperation *oper, NSError *error) {
            if(self.jumpToTab){
                self.jumpToTab(0,[dict objectForKey:@"info"]);
            }
        }];
//        NSLog(@"%@",self.userInfo);
    } failed:^(AFHTTPRequestOperation *oper, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    return NO;
}

-(BOOL)loginWithUserInfoForGetNewToken : (UserInfo *) userInfo{
    if (!userInfo) {
        return NO;
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:userInfo.account forKey:@"username"];
    [param setObject:userInfo.password forKey:@"password"];
    [param setObject:userInfo.imei forKey:@"imei"];
    NSString *url = [[ValuesFromXML getValueWithName:@"Sever_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:[ValuesFromXML getValueWithName:@"Login_Relative" WithKind:XMLTypeNetPort]];
    
    [HttpManager requestWithUrlString:url parms:param finished:^(AFHTTPRequestOperation *oper, id responseObj) {
//        NSLog(@"%@",responseObj);
        
        NSDictionary *dict = [[NSDictionary alloc]dictionaryWithJSON:responseObj];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            if ([[dict objectForKey:@"state"] intValue] == 0) {
                //返回block 提示账号密码有错误
                
                return ;
            }
            NSDictionary *subDict = [dict objectForKey:	@"data"];
            if ([subDict isKindOfClass:[NSDictionary class]]) {
                userInfo._id = [subDict objectForKey:@"id"];
                if (userInfo._id) {
                    NSSet *tags = [[NSSet alloc]initWithArray:@[[NSString stringWithFormat:@"member_%@",userInfo._id]]];
                    [JPUSHService  setTags:tags alias:[NSString stringWithFormat:@"member_%@",userInfo._id] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                        NSLog(@"iAlias %@",iAlias);
                    }];
                }
                userInfo.token = [subDict objectForKey:@"access_token"];
            }
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
        [self makeDir:userInfo.account];
        [defaults setObject:data forKey:@"UserInfo"];
        [defaults synchronize];
        
        self.userInfo = userInfo;
        //[self.userInfo addObserver:self forKeyPath:@"userInfoChange" options:NSKeyValueObservingOptionNew context:nil];
        NSString *userUrl = [[ValuesFromXML getValueWithName:@"Sever_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:[ValuesFromXML getValueWithName:@"USER_INFO" WithKind:XMLTypeNetPort]];
        NSMutableDictionary *usrParam = [[NSMutableDictionary alloc]init];
        if (!userInfo.token) {
            return ;
        }
        [usrParam setObject:userInfo.token forKey:@"access_token"];
        [HttpManager requestWithUrlString:userUrl parms:usrParam finished:^(AFHTTPRequestOperation *oper, id responseObj) {
            NSDictionary *userDict = [[NSDictionary alloc]dictionaryWithJSON:responseObj];
            if (1 == [[userDict objectForKey:@"state"] longValue]) {
                NSDictionary *dataDict = [userDict objectForKey:@"data"];
                self.users = [Users mj_objectWithKeyValues:dataDict];
                if (!self.users.uid) {
                    self.users.uid = userInfo._id;
                }
                if ([[DataBaseHelperSecond getInstance] createTabel:self.users]) {
                    NSLog(@"创建表%@成功",NSStringFromClass([self.users class]));
                }
                if (![[DataBaseHelperSecond getInstance] isExistInTable:self.users]) {
                    if ([[DataBaseHelperSecond getInstance] insertModelToTabel:self.users]) {
                        NSLog(@"insert data 成功");
                    }
                }else{
                    if ([[DataBaseHelperSecond getInstance] delteModelFromTabel:self.users]) {
                        [[DataBaseHelperSecond getInstance] insertModelToTabel:self.users];
                        NSLog(@"alter data 成功");
                    }
                }
            }
            if(self.isGetToken){
                self.isGetToken();
            }
            
        } failed:^(AFHTTPRequestOperation *oper, NSError *error) {
            
        }];
        NSLog(@"%@",self.userInfo);
    } failed:^(AFHTTPRequestOperation *oper, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    return NO;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"userInfoChange"]) {
        [[DataBaseHelperSecond getInstance]initDataBaseDB];
    }
}

-(UserInfo *)readLocal{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UserInfo *userInfo = (UserInfo *)[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"UserInfo"]];
    return userInfo;
}

-(NSString *) getAccountHomePath{
    return [[[NSHomeDirectory() stringByAppendingPathComponent:@"Library"]stringByAppendingPathComponent:@"Caches"] stringByAppendingPathComponent:[self readLocal].account];
}

-(NSString *) makeDir : (NSString *) name{
    NSString *directoryPath = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Library"]stringByAppendingPathComponent:@"Caches"] stringByAppendingPathComponent:name];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    BOOL isExist,isDirectory;
    isExist = [filemanager fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if (isDirectory && isExist) {
        return directoryPath;
    }else{
        if ([filemanager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil]) {
            return directoryPath;
        }
        return nil;
    }
}

-(void)dealloc{
    [self.userInfo removeObserver:self forKeyPath:@"userInfoChange"];
}

@end
