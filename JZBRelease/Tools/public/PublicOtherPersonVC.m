//
//  OtherPersonCentralVC.m
//  JZBRelease
//
//  Created by cl z on 16/8/5.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "PublicOtherPersonVC.h"

#import "Defaults.h"
#import "PersonalHeaderView.h"
#import "PersonalModel.h"
#import "GetUserInfoModel.h"
#import "BQDynamicVC.h"
#import "PerAskAndAnswerVC.h"
#import "BBActivityVC.h"
#import "PerActivityVC.h"
#import "CustomAlertView.h"
#import "AddFansModel.h"
#import "LewPopupViewAnimationSpring.h"
#import "FansListVC.h"

#import "ChatViewController.h"
#import "SendAndGetDataFromNet.h"

#import "MyCourseVC.h"
#import "WDPersonInfoVC.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>

#import "WDRootCell.h"
#import "AttentionListVC.h"

#import "WDPainCell.h"
#import "WDPushCell.h"

#import "ApplyVipVC.h"
#import "BCH_Alert.h"

#import "FocusContentVC.h"

#import "AppDelegate.h"
#import "PainTableViewCell.h"

#import "LWImageBrowserModel.h"
#import "LWImageBrowser.h"

@interface PublicOtherPersonVC ()<UITableViewDelegate,UITableViewDataSource>{
    CGFloat cellHeight;
    UILabel *label;
    NSInteger count;

}

@property (nonatomic, strong) UIView *painView;
@property (nonatomic, strong) UILabel *painLabel;

/** panNameS */
@property (nonatomic, strong) NSString *panNameS;
@property(nonatomic, strong) Users *model;
@property(nonatomic, assign) int requestCount;

@property(nonatomic, assign) BOOL isZLT;
@property(nonatomic, assign) BOOL isTeacher;

/** isSendFriend */
@property (nonatomic, assign) BOOL isSendFriend;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrV;

@property (weak, nonatomic) IBOutlet UIImageView *BGimageView;
@property (weak, nonatomic) IBOutlet UIImageView *userAvaImageView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *fansButton;
@property (weak, nonatomic) IBOutlet UIButton *friendButton;
@property (weak, nonatomic) IBOutlet UILabel *focusLabel;

@property (weak, nonatomic) IBOutlet UILabel *contributionLabel;
@property (weak, nonatomic) IBOutlet UILabel *LeftContributionName;
@property (weak, nonatomic) IBOutlet UILabel *contribution_this_levelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contribution_next_levelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *type_nameLabel;
@property (weak, nonatomic) IBOutlet UIView *type_nameLView;
@property (weak, nonatomic) IBOutlet UIView *compLView;

@property (weak, nonatomic) IBOutlet UILabel *zntLabel;

@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageViewLeftconstraint;
@property (weak, nonatomic) IBOutlet UIImageView *vipIconImageV;

@property (weak, nonatomic) IBOutlet UIProgressView *JifenProgressV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewSH;
//@property (weak, nonatomic) IBOutlet UILabel *painLabel;
//@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (weak, nonatomic) IBOutlet UILabel *panNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *painWCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PainAndAddressViewHCons;
@property (weak, nonatomic) IBOutlet UIButton *KCButton;

@property (weak, nonatomic) IBOutlet UIView *lastbotSpeView;
@property (weak, nonatomic) IBOutlet UIButton *fwxmButton;
@property (weak, nonatomic) IBOutlet UIButton *lastButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLToPainLConstrTop;

/**
 *  面板
 */
@property (nonatomic, strong) UIView *panelView;

/**
 *  加载视图
 */
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

/** tableView */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *midView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *bangBiNameLabel;

@end

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


@implementation PublicOtherPersonVC

static NSString *ID = @"PublicOtherPersonCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupTableView];
    
    [self setupSubView];
 
    if (!self.model) {
        self.model = [[Users alloc]init];
    }
    
    [self downloadData];
    
    if (iPhone5){
        /*代码操作*/
        self.userImageViewLeftconstraint.constant = 3;
        
    }else{
        /*代码操作*/
    }
    
    
    
//    if (![self.user.is_teacher isEqualToString:[LoginVM getInstance].readLocal._id]) {
//        self.isTeacher = self.user.is_teacher;
//    }else {
//        ;
//    }
    /** 分享功能还没有 */
    self.shareButton.hidden = YES;
    
     //AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    //if (appD.checkpay) {
        NSString *bangbi = @"帮币";
        self.bangBiNameLabel.text = bangbi;
//    }else {
//        self.bangBiNameLabel.text = @"店员";
//    }
}

- (void)addBotButton
{
    // 左边按钮
    UIView *intevalView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.glh_height - 50, GLScreenW, 1)];
    [intevalView setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"dfdfdf"]];
    [self.view addSubview:intevalView];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *btnTitle = @"加关注";
    [btn1 setTitle:btnTitle forState:UIControlStateNormal];
    
//    if (self.liveitem.is_zan.integerValue == 1) {
//        [btn1 setTitle:@"已收藏" forState:UIControlStateNormal];
//    }
    
    [btn1 setTitleColor:[UIColor hx_colorWithHexRGBAString:@"2196f0"] forState:UIControlStateNormal];
    btn1.frame = CGRectMake(0, self.view.glh_height - 49, self.view.glw_width * 0.5, 49);
    [self.view addSubview:btn1];
    btn1.backgroundColor = [UIColor whiteColor];
    [btn1 addTarget:self action:@selector(ClickFansButton:) forControlEvents:UIControlEventTouchUpInside];
    self.fansButton = btn1;
    
    // 右边按钮
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *btn2Title = @"加好友";
    [btn2 setTitle:btn2Title forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn2.frame = CGRectMake(self.view.glw_width * 0.5, self.view.glh_height - 49, self.view.glw_width * 0.5, 49);
    [self.view addSubview:btn2];
    btn2.backgroundColor = [UIColor orangeColor];
    [btn2 addTarget:self action:@selector(ClickFriendButton:) forControlEvents:UIControlEventTouchUpInside];
    self.friendButton = btn2;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.type_nameLView.hidden = YES;
    self.compLView.hidden = YES;
    
    self.view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f2f2f2"];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}

- (void)setupSubView
{
//    [self.userAvaImageView sizeToFit];

    [self.view layoutIfNeeded];
    
    self.userAvaImageView.layer.cornerRadius = self.userAvaImageView.glh_height * 0.5;
    self.userAvaImageView.clipsToBounds = YES;
    
    self.userAvaImageView.layer.borderWidth = 2;
    self.userAvaImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.userAvaImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUserAvaImageView)];
    [self.userAvaImageView addGestureRecognizer:tap];

    
//    self.userAvaImageView.layer.cornerRadius = self.userAvaImageView.glw_width * 0.5;
//    self.userAvaImageView.clipsToBounds = YES;
    
    /** 积分进度条 */
    self.JifenProgressV.layer.cornerRadius = 5;
    self.JifenProgressV.clipsToBounds = YES;
    self.JifenProgressV.layer.borderWidth = 1;
    self.JifenProgressV.layer.borderColor = [UIColor hx_colorWithHexRGBAString:@"ff9800"].CGColor;
    /** 整条的颜色 trackTintColor 就看不见了 */
    self.JifenProgressV.trackTintColor = [UIColor whiteColor];
    /** 目前进度的颜色 */
    self.JifenProgressV.progressTintColor = [UIColor hx_colorWithHexRGBAString:@"ff9800"];
    
    //设置进度值
    self.JifenProgressV.progress = 0.0;
}

- (IBAction)clickBackButton:(UIButton *)sender {
    if (self.fromDynamicDetailVC) {
        
        //self.navigationController.navigationBar.hidden = NO;
        //[self.navigationController setNavigationBarHidden:NO animated:YES];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    if (self.isSecVCPush) {
        
        self.navigationController.navigationBar.hidden = NO;
        
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.tabBarController.tabBar.hidden = YES;
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
        
    }
    
    //self.navigationController.navigationBar.hidden = NO;
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)painView{
    if (!_painView) {
        _painView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GLScreenW, 20)];
        [_painView setBackgroundColor:[UIColor whiteColor]];
        label = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 0, 0)];
        [label setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
        [label setFont:[UIFont systemFontOfSize:13]];
        [_painView addSubview:label];
        
        self.painLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 12, 0, 0)];
        [self.painLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"757575"]];
        [self.painLabel setFont:[UIFont systemFontOfSize:13]];
        self.painLabel.numberOfLines = 0;
        [_painView addSubview:self.painLabel];
    }
    return _painView;
}

- (void)downloadData {
    
    self.contentViewSH.constant = 2333;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
            if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
                GetUserInfoModel *model = [[GetUserInfoModel alloc]init];
                model.access_token = [[LoginVM getInstance] readLocal].token;
                model.uid = self.user.uid;
                SendAndGetDataFromNet *sendAndget = [[SendAndGetDataFromNet alloc]init];
                __weak SendAndGetDataFromNet *wsend = sendAndget;
                __weak PublicOtherPersonVC *wself = self;
                sendAndget.returnDict = ^(NSDictionary *dict){
                    if (!dict) {
                        [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:0.8];
                    }else{
                        if ([[dict objectForKey:@"state"] integerValue] == 1) {
                            wself.requestCount = 0;
                            NSDictionary *dataDict = [dict objectForKey:@"data"];
                            self.model = [Users mj_objectWithKeyValues:dataDict];
                            self.user = self.model;
//                            NSLog(@"dataDict %@",dataDict);
                            
                            [self addBotButton];
                            
                            if ([self.model.is_fllow integerValue] == 1) {
                                [self.fansButton setTitle:@"取消关注" forState:UIControlStateNormal];
                            }else {
                                [self.fansButton setTitle:@"加关注" forState:UIControlStateNormal];
                            }
                            
                            if ([self.model.is_friend integerValue] == 1) {
                                [self.friendButton setTitle:@"发消息" forState:UIControlStateNormal];
                            }else {
                                [self.friendButton setTitle:@"加好友" forState:UIControlStateNormal];
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self refreshComplete];
                            });
                        }else{
                            if (wself.requestCount > 1) {
                                [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:0.8];
                                return ;
                            }
                            [LoginVM getInstance].isGetToken = ^(){
                                model.access_token = [[LoginVM getInstance] readLocal].token;
                                [wsend dictFromNet:model WithRelativePath:@"USER_INFO"];
                                wself.requestCount ++;
                            };
                            [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
                        }
                    }
                };
                [sendAndget dictFromNet:model WithRelativePath:@"USER_INFO"];
            }else{
                [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:0.8];
            }
        }];
    });
}

/** 初始化 刷新界面 */
- (void)refreshComplete {
    
    if ([self.user.type isEqualToString:@"2"]) {
        self.isZLT = YES;
    }
    
//    if (self.isZLT) {
//        self.panNameLabel.text = @"擅长领域：";
//    }else{
//        self.panNameLabel.text = @"经营痛点：";
//    }
    if (self.isZLT) {
        self.panNameS = @"擅长领域：";
    }else{
        self.panNameS = @"经营痛点：";
    }
    
    [self.userAvaImageView sd_setImageWithURL:[NSURL URLWithString:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.user.avatar]] placeholderImage:[UIImage imageNamed:@"ZCCG_TX"]];
    
    if (self.user.score) {
        self.scoreLabel.text = self.user.score;
    }else {
        self.scoreLabel.text = @"0";
    }
    
    if (self.user.fans_count) {
        self.fansLabel.text = self.user.fans_count;
    }else {
        self.fansLabel.text = @"0";
    }
    
    if (self.user.fllow_count) {
        self.focusLabel.text = self.user.fllow_count;
    }else {
        self.focusLabel.text = @"0";
    }
    
    if (self.user.nickname) {
        self.titleNameLabel.text = self.user.nickname;
    }else {
        self.titleNameLabel.text = @"";
    }
    
    if (self.user.nickname) {
        self.nickNameLabel.text = self.user.nickname;
    }else {
        self.nickNameLabel.text = @"正在加载数据";
    }
    
    if (self.user.vip) {
        self.vipIconImageV.hidden = NO;
    }else {
        self.vipIconImageV.hidden = YES;
    }
    
//    if (self.user.company.length >=8) {
//        self.companyLabel.text = [NSString stringWithFormat:@"%@...",[self.user.company substringToIndex:8]];
//    }else {
        self.companyLabel.text = self.user.company;
//    }
    
    if (!self.user.company) {
        self.companyLabel.text = @"暂无";
    }
    
    if ([self.user.company isEqualToString:@""]) {
        self.companyLabel.text = @"暂无";
    }else {
        self.companyLabel.text = self.user.company;
    }
    
    self.jobLabel.text = self.user.job;
    
    self.contributionLabel.text = [NSString stringWithFormat:@"%@",self.user.contribution];
    self.LeftContributionName.text = self.user.contribution_level.this_level.name;
    self.contribution_this_levelNameLabel.text = self.user.contribution_level.this_level.name;
    self.contribution_next_levelNameLabel.text = self.user.contribution_level.next_level.name;
    self.type_nameLabel.text = self.user.type_name;
    self.zntLabel.text = self.user.znt;
    
    if (self.user.ss_address && ![self.user.ss_address isEqualToString:@""]) {
        [self.addressButton setTitle:self.user.ss_address forState:UIControlStateNormal];
    }else {
        [self.addressButton setTitle:@"尚未定位" forState:UIControlStateNormal];
    }
    
    
//    self.addressLabel.text = self.user.address;
//    self.painLabel.text = self.user.pain;
    
    /** 设置行距 */
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.user.pain];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:6];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.user.pain length])];
    [self.painLabel setAttributedText:attributedString1];
    
    /** ********* */
    
    [self.panNameLabel sizeToFit];
    
    if ([self.jobLabel.text isEqualToString:@""]) {
        self.jobLabel.text = @"暂无";
    }else {
//        self.type_nameRightView.hidden = NO;
    }
    
    if ([self.companyLabel.text isEqualToString:@""]) {
        self.companyLabel.text = @"暂无";
    }else {
        //        self.type_nameRightView.hidden = NO;
    }
    //
    if ([self.type_nameLabel.text isEqualToString:@""]) {
        self.type_nameLabel.text = @"暂无";
    }else {
        //        self.type_nameRightView.hidden = NO;
    }
    
    if ([self.contribution_this_levelNameLabel.text isEqualToString:@""]) {
        self.contribution_this_levelNameLabel.text = @"暂无";
    }else {
        //        self.type_nameRightView.hidden = NO;
    }
    
    self.type_nameLView.hidden = NO;
    self.compLView.hidden = NO;
    
    if ([self.jobLabel.text isEqualToString:@""]) {
        self.compLView.hidden = YES;
    }else {
        self.compLView.hidden = NO;
    }
    
    [self.painLabel sizeToFit];
//    [self.addressLabel sizeToFit];
    
    if (!self.isZLT) {
        self.fwxmButton.hidden = YES;
        self.KCButton.hidden = YES;
    }
    
    // *************第六版前注释***********
//    if (![self.painLabel.text isEqualToString:@""]){
//        self.PainAndAddressViewHCons.constant = 15 + 10 + self.painLabel.glh_height + self.addressLabel.glh_height + 25;
//        
//        self.painWCons.constant = GLScreenW - self.panNameLabel.glw_width - 35;
//    }else {
//        self.addressLToPainLConstrTop.constant = 25;
//    }
//    
//    self.contentViewSH.constant = self.lastButton.glb_bottom + 12;
//    self.contentScrV.contentSize = CGSizeMake(0, self.lastButton.glb_bottom + self.painLabel.glh_height + 12);
//    
//    if (!self.isZLT) {
//        self.contentViewSH.constant -= self.fwxmButton.glh_height + 2;
//        self.lastbotSpeView.hidden = YES;
//    }else {
//        self.contentViewSH.constant -= self.fwxmButton.glh_height + 2;
//        self.lastbotSpeView.hidden = YES;
//    }
//    
//    [self.view layoutIfNeeded];
//    
//    self.contentViewSH.constant = self.lastButton.glb_bottom + 12;
//    self.contentScrV.contentSize = CGSizeMake(0, self.lastButton.glb_bottom + self.painLabel.glh_height + 12);
//    
//    if (![self.painLabel.text isEqualToString:@""]){
//        self.PainAndAddressViewHCons.constant = 15 + 10 + self.painLabel.glh_height + self.addressLabel.glh_height + 25;
//        
//        self.painWCons.constant = GLScreenW - self.panNameLabel.glw_width - 35;
//    }else {
//        self.addressLToPainLConstrTop.constant = 25;
//    }
//    
//    if (!self.isZLT) {
//        self.contentViewSH.constant -= self.fwxmButton.glh_height + 2;
//        self.lastbotSpeView.hidden = YES;
//    }else {
//        self.contentViewSH.constant -= self.fwxmButton.glh_height + 2;
//        self.lastbotSpeView.hidden = YES;
//    }
    // *************第六版前注释***********
    
    //[self.tableViewHeader refreshingAnimateStop];
    [UIView animateWithDuration:0.35f animations:^{
//        self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
//        [self.personalHeaderView removeFromSuperview];
//        self.personalHeaderView = nil;
//        [self.tableView reloadData];
    }];
    
    self.isTeacher = self.user.is_teacher.boolValue;
    
    if (self.painLabel.text) {
        NSMutableAttributedString * attributedString2 = [[NSMutableAttributedString alloc] initWithString:self.painLabel.text];
        NSMutableParagraphStyle * paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle2 setLineSpacing:4];
        [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [self.painLabel.text length])];
        [self.painLabel setAttributedText:attributedString2];
    }
    
    
    self.painLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize subscribeInfoTviewsize = [self.painLabel sizeThatFits:CGSizeMake(GLScreenW - 85 - 20, MAXFLOAT)];
    [self.painLabel setFrame:CGRectMake(85,12, GLScreenW - 85 - 20, subscribeInfoTviewsize.height)];
    [self.painView setFrame:CGRectMake(0, 0, GLScreenW, subscribeInfoTviewsize.height + 12 + 10)];
    label.text = self.panNameS;
    [label sizeToFit];
    cellHeight = 0;
    if (self.user.pain && self.user.pain.length > 0) {
        cellHeight = subscribeInfoTviewsize.height + 12 + 10;
    }else{
        cellHeight = 18 + 12 + 10;
    }

    
    
    [self.tableView reloadData];
}



/** 
 -(PersonalHeaderView *)personalHeaderView{
 
 if (_personalHeaderView) {
 return _personalHeaderView;
 }
 _personalHeaderView = [[PersonalHeaderView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , 20 + 44 * 2 + 205)];
 if (!self.model) {
 self.model = [[Users alloc]init];
 }
 [_personalHeaderView initWithData:self.model];
 __weak typeof (self) wself = self;
 
 NSUserDefaults *udefaults = [NSUserDefaults standardUserDefaults];
 NSString *isSendFriendWithID = [NSString stringWithFormat:@"isSendFriend%@",self.model.uid];
 self.isSendFriend = [udefaults objectForKey:isSendFriendWithID];
 
 if (self.isSendFriend) {
 [self.personalHeaderView.addFriendBtn setTitle:@"已申请" forState:UIControlStateNormal];
 }
 
 if ([self.model.is_friend integerValue] == 1) {
 [self.personalHeaderView.addFriendBtn setTitle:@"交流" forState:UIControlStateNormal];
 }
 
 _personalHeaderView.btnAction = ^(NSInteger tag){
 if (0 == tag) {
 if ([wself.model.is_fllow integerValue] == 1) {
 [wself delFans];
 }else{
 [wself addFans];
 }
 }else if (3 == tag){
 FansListVC *fansVC = [[FansListVC alloc]init];
 fansVC.user = wself.model;
 wself.navigationController.navigationBar.hidden = NO;
 [wself.navigationController pushViewController:fansVC animated:YES];
 }else if (1 == tag){
 if (wself.isSendFriend) {
 CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"已经发送申请"];
 [wself lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 [wself lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
 });
 }else {
 // 点击 加为好友
 if ([wself.model.is_friend integerValue] == 1) {
 
 [wself MesFriend];
 }else{
 [wself addFriend];
 }
 }
 
 
 }
 };
 return _personalHeaderView;
 }
 
 */


- (void)MesFriend
{
    ChatViewController *chatViewController = [[ChatViewController alloc]
                                              initWithConversationChatter:[NSString stringWithFormat:@"member_%@",self.user.uid] conversationType:0];
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    chatViewController.title = self.nickNameLabel.text;
//    chatViewController.hidesBottomBarWhenPushed = YES;
    chatViewController.Ttitle = self.nickNameLabel.text;
    [self.navigationController pushViewController:chatViewController animated:YES];
}


- (void)addFriend
{
    NSDictionary *parameters = @{
                                 @"to_uid":self.user.uid ,
                                 @"access_token":[[LoginVM getInstance] readLocal].token
                                 };
    
//    NSLog(@"gaolintestparameters = %@",parameters);
    
    /** 正在进行好友申请 */
    CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"正在发送请求..."];
    [self lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
//    self.personalHeaderView.addFriendBtn.enabled = NO;
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Friend/add"] parameters:parameters success:^(id json) {
        
        if ([json[@"state"] isEqual:@(1)]) {
            /** 已经发送好友申请 */
            alertView.label.text = @"已经发送好友申请";
            self.model.is_friend = [NSNumber numberWithInteger:1];
            [self.friendButton setTitle:@"已申请" forState:UIControlStateNormal];
            
            NSUserDefaults *udefaults = [NSUserDefaults standardUserDefaults];
//            [udefaults objectForKey:@""];
            NSString *isSendFriendWithID = [NSString stringWithFormat:@"isSendFriend%@",self.user.uid];
            [udefaults setBool:YES forKey:isSendFriendWithID];
            self.isSendFriend = YES;
            
        }else {
            /** 网络问题 或者 token过期 */\
            alertView.label.text = @"网络问题,申请失败,请稍后重试 或者联系我们";
            
            if ([json[@"info"] isEqualToString:@"已邀请"]) {
                alertView.label.text = @"已邀请";
                [self.friendButton setTitle:@"已申请" forState:UIControlStateNormal];
            }
            
            self.model.is_friend = [NSNumber numberWithInteger:0];
        }
//        self.personalHeaderView.addFriendBtn.enabled = YES;
        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
        
        [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
        
    } failure:^(NSError *err) {
        [alertView setTitle:@"申请失败..请稍后重试"];
//        self.personalHeaderView.addFriendBtn.enabled = YES;
        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
        [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
//        [self showHint:NSLocalizedString(@"acceptFail", @"accept failure")];
//        [self hideHud];
    }];
}

-(void)addFans{
//    self.personalHeaderView.focusBtn.enabled = NO;
    CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"关注中..."];
    [self lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    AddFansModel *addFansModel = [[AddFansModel alloc]init];
    addFansModel.access_token = [[LoginVM getInstance] readLocal].token;
    addFansModel.user_id = self.user.uid;
    SendAndGetDataFromNet *sendAndGet = [[SendAndGetDataFromNet alloc]init];
    __block SendAndGetDataFromNet *wsend = sendAndGet;
    sendAndGet.returnModel = ^(GetValueObject *obj,int state){
        if (!obj) {
            [alertView setTitle:@"关注失败"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                    [Toast makeShowCommen:@"您的网络 " ShowHighlight:@"出现故障" HowLong:0.8];
//                    self.personalHeaderView.focusBtn.enabled = YES;
                });
            });
        }else{
            if (1 == state) {
                self.requestCount = 0;
                [alertView.label setText:@"成功关注"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                    [self.fansButton setTitle:@"取消关注" forState:UIControlStateNormal];
//                    [_personalHeaderView.fansValue setText:[NSString stringWithFormat:@"%ld",[_personalHeaderView.fansValue.text integerValue] + 1]];
                    self.model.is_fllow = [NSNumber numberWithInteger:1];
//                    self.personalHeaderView.focusBtn.enabled = YES;
                });
            }else{
                if (self.requestCount > 1) {
                    [alertView setTitle:@"关注失败"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                            [Toast makeShowCommen:@"您的网络 " ShowHighlight:@"出现故障" HowLong:0.8];
//                            self.personalHeaderView.focusBtn.enabled = YES;
                        });
                    });
                    return ;
                }
                [LoginVM getInstance].isGetToken = ^(){
                    addFansModel.access_token = [[LoginVM getInstance] readLocal].token;
                    [wsend commenDataFromNet:addFansModel WithRelativePath:@"Add_Fans_URL"];
                    self.requestCount ++;
                };
                [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
            }
            
        }
    };
    [sendAndGet commenDataFromNet:addFansModel WithRelativePath:@"Add_Fans_URL"];
}

-(void)delFans{
//    self.personalHeaderView.focusBtn.enabled = NO;
    CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"取消关注中..."];
    [self lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    //AddFansModel可作取消关注Model
    AddFansModel *addFansModel = [[AddFansModel alloc]init];
    addFansModel.access_token = [[LoginVM getInstance] readLocal].token;
    addFansModel.user_id = self.user.uid;
    SendAndGetDataFromNet *sendAndGet = [[SendAndGetDataFromNet alloc]init];
    __block SendAndGetDataFromNet *wsend = sendAndGet;
    sendAndGet.returnModel = ^(GetValueObject *obj,int state){
        if (!obj) {
            [alertView setTitle:@"取消失败"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                    [Toast makeShowCommen:@"您的网络 " ShowHighlight:@"出现故障" HowLong:0.8];
//                    self.personalHeaderView.focusBtn.enabled = YES;
                });
            });
        }else{
            if (1 == state) {
                self.requestCount = 0;
                [alertView.label setText:@"取消关注"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                    [self.fansButton setTitle:@"加关注" forState:UIControlStateNormal];
//                    [_personalHeaderView.fansValue setText:[NSString stringWithFormat:@"%ld",[_personalHeaderView.fansValue.text integerValue] - 1]];
                    self.model.is_fllow = [NSNumber numberWithInteger:0];
//                    self.personalHeaderView.focusBtn.enabled = YES;
                });
            }else{
                if (self.requestCount > 1) {
                    [alertView setTitle:@"取消失败"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
                        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                            [Toast makeShowCommen:@"您的网络 " ShowHighlight:@"出现故障" HowLong:0.8];
//                            self.personalHeaderView.focusBtn.enabled = YES;
                        });
                    });
                    return ;
                }
                [LoginVM getInstance].isGetToken = ^(){
                    addFansModel.access_token = [[LoginVM getInstance] readLocal].token;
                    [wsend commenDataFromNet:addFansModel WithRelativePath:@"Delete_Fans_URL"];
                    self.requestCount ++;
                };
                [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
            }
            
        }
    };
    [sendAndGet commenDataFromNet:addFansModel WithRelativePath:@"Delete_Fans_URL"];
}

- (void)pushPerActivityVC
{
    Users *user = self.model;
    
    if (!user) {
        [SVProgressHUD showWithStatus:@"网络不好,请检查后重试"];
        [self downloadData];
    }
    
    PerActivityVC *activityVC = [[PerActivityVC alloc]init];
    activityVC.user = user;
    //    self.navigationController.navigationBar.hidden = NO;
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController pushViewController:activityVC animated:YES];
}

- (void)pushBQDynamicVC
{
    Users *user = self.model;
    
    if (!user) {
        [SVProgressHUD showWithStatus:@"网络不好,请检查后重试"];
        [self downloadData];
    }
    
    BQDynamicVC *bqRoot = [[BQDynamicVC alloc]init];
    bqRoot.fromPernoal = YES;
    bqRoot.user = user;
    //    self.navigationController.navigationBar.hidden = NO;
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController pushViewController:bqRoot animated:YES];
}

- (void)pushMyCourseVC
{
    MyCourseVC *myVC = [[MyCourseVC alloc]init];
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
    myVC.isOther = YES;
    myVC.user = self.model;
    
    [self.navigationController pushViewController:myVC animated:YES];
}

- (void)pushPerAskAndAnswerVC
{
    Users *user = self.model;
    
    if (!user) {
        [SVProgressHUD showWithStatus:@"网络不好,请检查后重试"];
        [self downloadData];
    }
    
    PerAskAndAnswerVC *askVC = [[PerAskAndAnswerVC alloc]init];
    askVC.user = user;
    //    self.navigationController.navigationBar.hidden = NO;
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController pushViewController:askVC animated:YES];
}

- (IBAction)ClickGRDTButton:(UIButton *)sender {
    
//    [self pushBQDynamicVC];
    
}

#pragma mark - 点击商机
- (IBAction)ClickHDButton:(UIButton *)sender {
    
    [self pushPerActivityVC];
    
}
#pragma mark - 点击话题
- (IBAction)ClickWDButton:(UIButton *)sender {
    
    [self pushPerAskAndAnswerVC];
    
}

- (IBAction)ClickKCButton:(UIButton *)sender {
    
//    MyCourseVC *myVC = [[MyCourseVC alloc]init];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [self.navigationController pushViewController:myVC animated:YES];
    
    [self pushMyCourseVC];
}

#pragma mark - 点击个人简介
/** 点击个人简介 */
- (IBAction)ClickPersonInfoControl:(UIControl *)sender {
    
    AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (!appD.vip) {
        [UIView bch_showWithTitle:@"提示" message:@"进入建众人脉要先加入建众帮会员哦！" buttonTitles:@[@"取消",@"确定"] callback:^(id sender, NSUInteger buttonIndex) {
            if (1 == buttonIndex) {
                //AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                
               // if (appDelegate.checkpay) {
                    ApplyVipVC *applyVipVC = [[ApplyVipVC alloc]init];
                    [self.navigationController pushViewController:applyVipVC animated:YES];
               // }
            }
        }];
        return ;
    };
    
    WDPersonInfoVC *vc = [[UIStoryboard storyboardWithName:@"WDPersonInfoVC" bundle:nil]instantiateInitialViewController];
    
    vc.isMine = NO;
    vc.user = self.user;
    
    if ([self.user.type isEqualToString:@"2"]) {
        vc.isZLT = YES;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)ClickFansButton:(UIButton *)sender {
    
    if ([self.model.is_fllow integerValue] == 1) {
        [self delFans];
    }else{
        [self addFans];
    }
    
}
- (IBAction)ClickFriendButton:(UIButton *)sender {
    
    if (self.isSendFriend) {
        
        CustomAlertView *alertView = [CustomAlertView defaultCustomAlertView:@"已经发送申请"];
        [self lew_presentPopupView:alertView animation:[LewPopupViewAnimationSpring new]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
        });
    }else {
        // 点击 加为好友
        if ([self.model.is_friend integerValue] == 1) {
            
            [self MesFriend];
        }else{
            [self addFriend];
        }
    }
    
}

- (IBAction)clickshareButton:(UIButton *)sender {
    
    [self showShareActionSheet:self.view];
}

/** 跳转粉丝列表 */
- (IBAction)clickFasnList:(UIControl *)sender {
    
    FansListVC *vc = [FansListVC new];
    
    vc.title = @"粉丝列表";
    vc.user = self.user;
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)clickAttentionList:(UIControl *)sender {
    
    AttentionListVC *vc = [AttentionListVC new];
    
    vc.title = @"关注列表";
    vc.user = self.user;
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 点击关注内容
- (IBAction)ClickgznrButton:(UIButton *)sender {
    
    FocusContentVC *vc = [FocusContentVC new];
    vc.isOther = YES;
    vc.user = self.user;
//    self.navigationController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - 按钮tableView
- (void)setupTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //有数据才有分割线
    self.tableView.tableFooterView = [[UIImageView alloc]init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
    //    tableView.backgroundColor = [UIColor redColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49 + 10, 0);
}
//- (void)setuptableView
//{
//    
//    [self.view layoutIfNeeded];
//    
//    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.midView.gly_y + self.midView.glh_height + 0 + 0, GLScreenW, 344) style:UITableViewStylePlain];
//    
//    
//    if (self.tableView.superview == nil) {
//        
//        UIView *footview = [UIView new];
//        footview.frame = CGRectMake(0, 0, GLScreenW, 12);
//        footview.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
//        
//        UIView *fengexian000 = [UIView new];
//        [footview addSubview:fengexian000];
//        fengexian000.frame = CGRectMake(0, 0, GLScreenW, 1);
//        fengexian000.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"e5e5e5"];
//        
//        
//        tableView.tableFooterView = footview;
//        
//        tableView.gly_y = self.midView.gly_y + self.midView.glh_height + 0 + 0;
//        
//        if (!self.isZLT) {
//            tableView.glh_height = 344 - 44;
//        }else {
//            tableView.glh_height = 344;
//        }
//        
////        tableView.glh_height += 12;
//        
//        self.contentScrV.contentSize = CGSizeMake(0, tableView.gly_y + tableView.glh_height + + self.midView.glh_height + 0 + 9 - 64);
//        self.contentViewSH.constant = tableView.gly_y + tableView.glh_height + + self.midView.glh_height + 0 + 9 - 64;
//        
//        [self.contentScrV addSubview:tableView];
//        
//        //        NSLog(@"t1t1t1%f",self.contentViewSH.constant);
//        //        NSLog(@"t333333333%f--%f--%f",tableView.gly_y,self.tableView.glh_height,self.midView.glh_height);
//    }else {
//        self.tableView.gly_y = self.midView.gly_y + self.midView.glh_height + 0 + 0 ;
//        self.tableView.glh_height = 344;
//        
//        if (!self.isZLT) {
//            self.tableView.glh_height = 344 - 44;
//        }else {
//            self.tableView.glh_height = 344;
//        }
//        
////        self.tableView.glh_height += 12;
//        
//        self.contentScrV.contentSize = CGSizeMake(0, tableView.gly_y + self.tableView.glh_height + + self.midView.glh_height + 0 + 9 - 64);
//        self.contentViewSH.constant = tableView.gly_y + self.tableView.glh_height + + self.midView.glh_height + 0 + 9 - 64;
//        
//        //        NSLog(@"t2t2t2%f",self.contentViewSH.constant);
//        //        NSLog(@"t44444%f--%f--%f",tableView.gly_y,self.tableView.glh_height,self.midView.glh_height);
//        
//        return ;
//    }
//    //    NSLog(@"222222222222%@",self.tableView.superview);
//    
//    tableView.dataSource = self;
//    tableView.delegate = self;
//    
//    tableView.scrollEnabled = NO;
//    
//    [tableView registerNib:[UINib nibWithNibName:@"WDRootCell" bundle:nil] forCellReuseIdentifier:ID];
//    
//    self.tableView = tableView;
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    /**  必有数据 */
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /** 首页 必有数据 */
    AppDelegate *appD = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        
//        if (!appD.checkpay) {
//            return 1;
//        }else {
            NSInteger num = 3;
            
            if (!self.isZLT) {
                num = num - 1;
            }
            
            if (self.isTeacher) {
                
            }else {
                num = num - 1;
            }
            
            return num;
      //  }
        
    }
    
    return 0;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        
        if (self.panNameS == nil) {
            self.panNameS = @" ";
        }
        
        if (self.user.pain == nil) {
            self.user.pain = @" ";
        }
        
//        cell = [tableView dequeueReusableCellWithIdentifier:@"WDPainCell" forIndexPath:indexPath];
//        WDPainCell *WDcell = (WDPainCell *)cell;
//        WDcell.painLabel.text = [NSString stringWithFormat:@"%@",self.panNameS];
//        WDcell.painValueLabel.text = [NSString stringWithFormat:@"%@",self.user.pain];
//        
//        if (self.panNameS == nil) {
//            self.panNameS = @"☺";
//        }
//        
//        cell = [tableView dequeueReusableCellWithIdentifier:@"WDPainCell" forIndexPath:indexPath];
//        WDPainCell *WDcell = (WDPainCell *)cell;
//        WDcell.painLabel.text = [NSString stringWithFormat:@"%@%@",self.panNameS,self.user.pain];
        PainTableViewCell *paincell = [tableView dequeueReusableCellWithIdentifier:@"PainCell"];
        if (!paincell) {
            paincell = [[PainTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PainCell"];
        }
        if (!paincell.painView) {
            paincell.painView = self.painView;
            [paincell.contentView addSubview:paincell.painView];
        }
        [self.painLabel setFrame:CGRectMake(85,12, GLScreenW - 85 - 20, cellHeight - 22)];
        [self.painView setFrame:CGRectMake(0, 0, GLScreenW, cellHeight)];
        label.text = self.panNameS;
        [label sizeToFit];
        paincell.selectionStyle = UITableViewCellSelectionStyleNone;
        return paincell;

    }else if (indexPath.section == 1) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"WDPushCell" forIndexPath:indexPath];
        
        WDPushCell *Pushcell = (WDPushCell *)cell;
        
        AppDelegate *appD = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
        
//        if (!appD.checkpay) {
//            Pushcell.iconImageVIew.image = [UIImage imageNamed:@"WDZY_KC"];
//            Pushcell.TtitleLabel.text = @"金牌课程";
//        }else {
            if (self.isTeacher) {
                if (indexPath.row == 0) {
                    Pushcell.iconImageVIew.image = [UIImage imageNamed:@"WDZY_KC"];
                    Pushcell.TtitleLabel.text = @"金牌课程";
                }else if (indexPath.row == 1) {
                    Pushcell.iconImageVIew.image = [UIImage imageNamed:@"WDZY_SQ"];
                    Pushcell.TtitleLabel.text = @"参与社群";
                }else if (indexPath.row == 2) {
                    Pushcell.iconImageVIew.image = [UIImage imageNamed:@"WDZY_XM"];
                    Pushcell.TtitleLabel.text = @"服务项目";
                }
            }else {
                if (indexPath.row == 0) {
                    Pushcell.iconImageVIew.image = [UIImage imageNamed:@"WDZY_SQ"];
                    Pushcell.TtitleLabel.text = @"参与社群";
                }else if (indexPath.row == 1) {
                    Pushcell.iconImageVIew.image = [UIImage imageNamed:@"WDZY_XM"];
                    Pushcell.TtitleLabel.text = @"服务项目";
                }
            }
     //   }
        
    }

        /** //    WDRootCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
         //
         //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
         
         //     if (indexPath.section == 0) {
         //
         //        if (indexPath.row == 0) {
         //            cell.imageNameView.image = [UIImage imageNamed:@"WD_TALK"];
         //            cell.titleNameLabel.text = @"参与话题";
         //        }else if (indexPath.row == 1) {
         //            cell.imageNameView.image = [UIImage imageNamed:@"WD_GRDT"];
         //            cell.titleNameLabel.text = @"个人动态";
         //        }else if (indexPath.row == 2) {
         //            cell.imageNameView.image = [UIImage imageNamed:@"WD_SQ"];
         //            cell.titleNameLabel.text = @"参与社群";
         //        }
         //
         //    }else if (indexPath.section == 1) {
         //        if (indexPath.row == 0) {
         //            cell.imageNameView.image = [UIImage imageNamed:@"WD_KC"];
         //            cell.titleNameLabel.text = @"金牌课程";
         //        }else if (indexPath.row == 1) {
         //            cell.imageNameView.image = [UIImage imageNamed:@"WD_GZ"];
         //            cell.titleNameLabel.text = @"关注内容";
         //        }else if (indexPath.row == 2) {
         //            cell.imageNameView.image = [UIImage imageNamed:@"WD_SJ"];
         //            cell.titleNameLabel.text = @"商机资源";
         //        }else if (indexPath.row == 3) {
         //            cell.imageNameView.image = [UIImage imageNamed:@"WD_XM"];
         //            cell.titleNameLabel.text = @"服务项目";
         //        }
         //    }
         
         //    cell.item = self.dataSource[indexPath.row]; */

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AppDelegate *appD = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    
//    if (!appD.checkpay) {
//        [self pushMyCourseVC];
//    }else {
        if (self.isTeacher) {
            if (indexPath.section == 0) {
            }else if (indexPath.section == 1) {
                if (indexPath.row == 0) {
                    [self pushMyCourseVC];
                    //             [self pushPerAskAndAnswerVC];
                    //  @"金牌课程";
                }else if (indexPath.row == 1) {
                    
                    
                    
                    [SVProgressHUD showInfoWithStatus:@"功能暂未开发,敬请期待"];
                    //  @"参与社区";
                }else if (indexPath.row == 2) {
                    [SVProgressHUD showInfoWithStatus:@"功能暂未开发,敬请期待"];
                    
                    //  @"服务项目";
                }
            }
        }else {
            
        }
   // }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return cellHeight;        
    }else if (indexPath.section == 1) {
        return 44;
    }else  {
        return 44;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, GLScreenW, GLScreenH);
    view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
    
    UIView *fengexian99 = [UIView new];
    if (section == 1) {
        fengexian99.frame = CGRectMake(0, 15, GLScreenW, 1);
    }else {
        fengexian99.frame = CGRectMake(0, 10, GLScreenW, 1);
    }
    
    [view addSubview:fengexian99];
    fengexian99.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"dfdfdf"];
    
    UIView *fengexian00 = [UIView new];
    
    fengexian00.frame = CGRectMake(0,0, GLScreenW, 1);
    
    [view addSubview:fengexian00];
    fengexian00.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"dfdfdf"];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else if (section == 1) {
        return 15;
    }
    return 0;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [UIView new];
//    view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
//    
//    //    view.backgroundColor = [UIColor redColor];
//    
//    UIView *topview = [UIView new];
//    UIView *botview = [UIView new];
//    
//    [view addSubview:topview];
//    [view addSubview:botview];
//    
//    topview.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"e5e5e5"];
//    botview.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"e5e5e5"];
//    
//    topview.frame = CGRectMake(0, 0, GLScreenW, 1);
//    
//    botview.frame = CGRectMake(0, 11, GLScreenW, 1);
//    
//    return view;
//}


/**
 *  显示分享菜单
 *
 *  @param view 容器视图
 */
- (void)showShareActionSheet:(UIView *)view
{
    
    /** 还没有分享 */
    return ;
    
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
    __weak PublicOtherPersonVC *theController = self;
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"shareImage"]];
    [shareParams SSDKSetupShareParamsByText:nil
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"http://bang.jianzhongbang.com/index.php/Share/Question/info/id/%@.html",@"1"]]
                                      title:nil//title:@"分享标题-欢迎下载【建众帮】"
                                       type:SSDKContentTypeWebPage];
    
    //1.2、自定义分享平台（非必要）
    NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:[ShareSDK activePlatforms]];
    //添加一个自定义的平台（非必要）
    SSUIShareActionSheetCustomItem *item = [SSUIShareActionSheetCustomItem itemWithIcon:[UIImage imageNamed:@"Icon.png"]
                                                                                  label:@"自定义"
                                                                                onClick:^{
                                                                                    
                                                                                    //自定义item被点击的处理逻辑
                                                                                    NSLog(@"=== 自定义item被点击 ===");
                                                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"自定义item被点击"
                                                                                                                                        message:nil
                                                                                                                                       delegate:nil
                                                                                                                              cancelButtonTitle:@"确定"
                                                                                                                              otherButtonTitles:nil];
                                                                                    [alertView show];
                                                                                }];
    [activePlatforms addObject:item];
    
    //设置分享菜单栏样式（非必要）
    //            [SSUIShareActionSheetStyle setActionSheetBackgroundColor:[UIColor colorWithRed:249/255.0 green:0/255.0 blue:12/255.0 alpha:0.5]];
    //            [SSUIShareActionSheetStyle setActionSheetColor:[UIColor colorWithRed:21.0/255.0 green:21.0/255.0 blue:21.0/255.0 alpha:1.0]];
    //            [SSUIShareActionSheetStyle setCancelButtonBackgroundColor:[UIColor colorWithRed:21.0/255.0 green:21.0/255.0 blue:21.0/255.0 alpha:1.0]];
    //            [SSUIShareActionSheetStyle setCancelButtonLabelColor:[UIColor whiteColor]];
    //            [SSUIShareActionSheetStyle setItemNameColor:[UIColor whiteColor]];
    //            [SSUIShareActionSheetStyle setItemNameFont:[UIFont systemFontOfSize:10]];
    //            [SSUIShareActionSheetStyle setCurrentPageIndicatorTintColor:[UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1.0]];
    //            [SSUIShareActionSheetStyle setPageIndicatorTintColor:[UIColor colorWithRed:62/255.0 green:62/255.0 blue:62/255.0 alpha:1.0]];
    
    //2、分享
    [ShareSDK showShareActionSheet:view
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                       {
                           [theController showLoadingView:YES];
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                           //Facebook Messenger、WhatsApp等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
                           if (platformType == SSDKPlatformTypeFacebookMessenger)
                           {
                               break;
                           }
                           
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、短信应用没有设置帐号；2、设备不支持短信应用；3、短信应用在iOS 7以上才能发送带附件的短信。"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、邮件应用没有设置帐号；2、设备不支持邮件应用；"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
//                           [alertView show];
                           break;
                       }
                       default:
                           break;
                   }
                   
                   if (state != SSDKResponseStateBegin)
                   {
                       [theController showLoadingView:NO];
//                       [theController.tableView reloadData];
                   }
                   
               }];
    
    //另附：设置跳过分享编辑页面，直接分享的平台。
    //        SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:view
    //                                                                         items:nil
    //                                                                   shareParams:shareParams
    //                                                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
    //                                                           }];
    //
    //        //删除和添加平台示例
    //        [sheet.directSharePlatforms removeObject:@(SSDKPlatformTypeWechat)];
    //        [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
    
}

/**
 *  显示加载动画
 *
 *  @param flag YES 显示，NO 不显示
 */
- (void)showLoadingView:(BOOL)flag
{
    if (flag)
    {
        [self.view addSubview:self.panelView];
        [self.loadingView startAnimating];
    }
    else
    {
        [self.panelView removeFromSuperview];
    }
}

- (CGSize)getStringRect:(NSString*)aString

{
    
    CGSize size;
    
    NSAttributedString* atrString = [[NSAttributedString alloc] initWithString:aString];
    
    NSRange range = NSMakeRange(0, atrString.length);
    
    NSDictionary* dic = [atrString attributesAtIndex:0 effectiveRange:&range];
    
    CGFloat textW;
    
    
    textW = [UIScreen mainScreen].bounds.size.width - 80;
    
    
    size = [aString boundingRectWithSize:CGSizeMake(textW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return  size;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //    if (path.row == self.dataSource.count - 1) {
    //        self.tableView.bounces = YES;
    //    }
    if (((int)scrollView.contentOffset.y) < 10) {
        self.tableView.bounces = NO;
    }else{
        self.tableView.bounces = YES;
    }
    
}

- (void)tapUserAvaImageView
{
    
    if (!self.user.avatar) return;
    
    CGRect rect1 = self.userAvaImageView.frame;
    
    NSMutableArray* tmp = [NSMutableArray array];
    
    //    [[LWImageBrowser alloc] initWithParentViewController:self style:LWImageBrowserAnimationStyleScale imageModels:tmp currentIndex:0];
    
    
    LWImageBrowserModel *imageModel = [[LWImageBrowserModel alloc]initWithLocalImage:[LocalDataRW getImageWithDirectory:Directory_BQ RetalivePath:[[ValuesFromXML getValueWithName:@"Images_Absolute_Address" WithKind:XMLTypeNetPort] stringByAppendingPathComponent:self.user.avatar]] imageViewSuperView:self.userAvaImageView.superview positionAtSuperView:CGRectFromString(NSStringFromCGRect(rect1)) index:0];
    [tmp addObject:imageModel];
    
    LWImageBrowser* imageBrowser = [[LWImageBrowser alloc] initWithParentViewController:self style:LWImageBrowserAnimationStyleScale imageModels:tmp currentIndex:0];
    
    imageBrowser.view.backgroundColor = [UIColor blackColor];
    
    [imageBrowser show];
}

@end