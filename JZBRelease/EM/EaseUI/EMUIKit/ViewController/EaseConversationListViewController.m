/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseConversationListViewController.h"

#import "EaseEmotionEscape.h"
#import "EaseConversationCell.h"
#import "EaseConvertToCommonEmoticonsHelper.h"
#import "EaseMessageViewController.h"
#import "NSDate+Category.h"
#import "EaseLocalDefine.h"

#import "HXFriendDataSource.h"
#import "Users.h"
#import "DataBaseHelperSecond.h"

#import "LocalDataRW.h"
#import "SendAndGetDataFromNet.h"
#import "MessageListVC.h"
#import "MessageRequestModel.h"

#import "ApplyFriendNoticeVC.h"
#import "ApplyGruopNoticeVC.h"
#import "NewBusinessListVC.h"
#import "NewQuestionListVC.h"

#import "updateTabBarBadge.h"
#import "NewReferrerVC.h"
#import "NewCourseListVC.h"

@interface EaseConversationListViewController ()

/** FMDBTool */
@property (nonatomic, strong) GLFMDBToolSDK *FMDBTool;

/** user */
@property (nonatomic, strong) Users *user;

/** dynamicBadge */
@property (nonatomic, assign) NSInteger dynamicBadge;
/** dynamicBadge */
@property (nonatomic, assign) NSInteger societyGroupBadge;
/** avatarBadge */
@property (nonatomic, assign) NSInteger avatarBadge;

@property (nonatomic, assign) NSInteger unapplyCount;

/** numBlock */
@property (nonatomic, assign) BOOL numBlock;

@end

@implementation EaseConversationListViewController

- (Users *)user
{
    if (_user == nil) {
        _user = [[Users alloc] init];
    }
    return _user;
}

- (GLFMDBToolSDK *)FMDBTool
{
    if (_FMDBTool == nil) {
        _FMDBTool = [GLFMDBToolSDK shareToolsWithCreateDDL:nil];
    }
    return _FMDBTool;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updatabadge];
    
    DataBaseHelperSecond *db = [DataBaseHelperSecond getInstance];
    [db initDataBaseDB];
    self.user.uid = [[[LoginVM getInstance]readLocal] _id];
    self.user = (Users *)[db getModelFromTabel:self.user];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateTabBarBadge];
}

/** 判断 清空聊吧badge */
- (void)updateTabBarBadge
{
    
    NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
    NSInteger PInfoavatarBadge = [udefault integerForKey:@"PInfoavatarBadge"];
    
    NSInteger unapplyCount = 1;
    unapplyCount = [udefault integerForKey:@"MessageFriend"];
    
    NSInteger activity_newNum = [udefault integerForKey:@"Message_activity_newNum"];
    
    NSInteger question_newNum = [udefault integerForKey:@"Message_question_newNum"];
    
    NSInteger reference_newNum = [udefault integerForKey:@"Message_reference_newNum"];
    
    NSInteger course_LivenewNum = [udefault integerForKey:@"Message_course_LivenewNum"];
    
    NSInteger course_NownewNum = [udefault integerForKey:@"Message_course_NownewNum"];
    
//    NSInteger question_newNum233 = [udefault integerForKey:@"Message_question_newNum233"];

//    self.avatarBadge -= cell.avatarView.badge;
    NSLog(@"dynamicBadge=%ldavatarBadge=%ld--unapplyCount=%ld",self.dynamicBadge,PInfoavatarBadge,unapplyCount);
    if ((course_NownewNum + course_LivenewNum + reference_newNum + question_newNum + activity_newNum + self.dynamicBadge + PInfoavatarBadge + unapplyCount + self.societyGroupBadge) == 0) {
        self.navigationController.tabBarItem.badgeValue = nil;
    }
    self.numBlock = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self unregisterNotifications];
}

- (void)updatabadge
{
    NSNumber *messageCount = [LocalDataRW returnCountWithType:@"dynamic_reply"];
    self.dynamicBadge = messageCount.integerValue;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    NSInteger Gbadge = 0;
    NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
    Gbadge = [udefault integerForKey:@"aGroupIdBadge"];
    
    NSInteger Fbadge = 0;
    Fbadge = [udefault integerForKey:@"aGroupIdBadge"];
    
    if (Gbadge) {
//        self.navigationController.tabBarItem.badgeValue = @"G";
        self.navigationController.tabBarItem.badgeValue = [updateTabBarBadge updateTabBarBadgeNum];
    }else if (Fbadge) {
//    NSLog(<#NSString * _Nonnull format, ...#>)
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MessageComing) name:@"MessageComing" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MessageFriend_add:) name:@"MessageFriend_add" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MessageFriend_agree:) name:@"MessageFriend_agree" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MessageActivity_new:) name:@"Message_activity_new" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MessageQuestion_new:) name:@"Message_question_new" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MessageReference_new:) name:@"Message_reference_new" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MessageCourse_Livenew:) name:@"Message_course_Livenew" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MessageCourse_Nownew:) name:@"Message_course_Nownew" object:nil];
    
    [self registerNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)MessageComing{
    
    NSNumber *messageCount = [LocalDataRW returnCountWithType:@"dynamic_reply"];
    
    if ([messageCount intValue] != 0) {
        
        self.dynamicBadge = messageCount.integerValue;
        if (self.dynamicBadge) {
            [self tableViewDidTriggerHeaderRefresh];
        }
        
        return;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectiosnInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    if (section == 0) {
        
        if ([self.user.type isEqualToString:@"2"] && [self.user.znt_id isEqualToString:@"1"]) {
            return 6;
        }
        
        return 5;
    }
    
    self.avatarBadge = 0;
    NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
    [udefault setInteger:0 forKey:@"PInfoavatarBadge"];
    
    return [self.dataArray count];
    
}

/** 高林修改 消息界面的cell模型 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { // 头部cell
        if (indexPath.row == 5) {
            //            NSString *CellIdentifier = @"dynamic";
            //            EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            //            if (cell == nil) {
            //                cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            //            }
            //            // 这里修改图片
            //            cell.avatarView.image = [UIImage imageNamed:@"grzx_contacts_addfriend"];
            //            //            cell.titleLabel.text = NSLocalizedString(@"title.apply", @"Application and notification");
            //            cell.titleLabel.text = @"新动态";
            //
            //            cell.avatarView.badge = self.dynamicBadge;
            //
            //            return cell;
            
            NSString *CellIdentifier = @"referrer";
            EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            // 这里修改图片
            cell.avatarView.image = [UIImage imageNamed:@"newquestion"];
            //            cell.titleLabel.text = NSLocalizedString(@"title.apply", @"Application and notification");
            cell.titleLabel.text = @"审核列表";
            
            NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
            NSInteger activity_newNum = [udefault integerForKey:@"Message_reference_newNum"];
            
            if (!activity_newNum) {
                activity_newNum = 0;
            }
            
            if (activity_newNum == 0) {
                
            }else {
//                self.navigationController.tabBarItem.badgeValue = @"N";
                self.navigationController.tabBarItem.badgeValue = [updateTabBarBadge updateTabBarBadgeNum];

            }
            
            cell.avatarView.badge = activity_newNum;
            
            //            if (cell.avatarView.badge != activity_newNum) {
            //                self.navigationController.tabBarItem.badgeValue = @"N";
            //            }
            
            return cell;
            
        }else if (indexPath.row == 1) {
//            NSString *CellIdentifier = @"dynamic";
//            EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//            if (cell == nil) {
//                cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//            }
//            // 这里修改图片
//            cell.avatarView.image = [UIImage imageNamed:@"grzx_contacts_addfriend"];
//            //            cell.titleLabel.text = NSLocalizedString(@"title.apply", @"Application and notification");
//            cell.titleLabel.text = @"新动态";
//            
//            cell.avatarView.badge = self.dynamicBadge;
//            
//            return cell;
            
            NSString *CellIdentifier = @"Question";
            EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            // 这里修改图片
            cell.avatarView.image = [UIImage imageNamed:@"newquestion"];
            //            cell.titleLabel.text = NSLocalizedString(@"title.apply", @"Application and notification");
//            cell.titleLabel.text = @"新提问";
            cell.titleLabel.text = @"提问动态";
            
            NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
            NSInteger activity_newNum = [udefault integerForKey:@"Message_question_newNum"];
            
            if (!activity_newNum) {
                activity_newNum = 0;
            }
            
            if (activity_newNum == 0) {
                
            }else {
//                self.navigationController.tabBarItem.badgeValue = @"Q";
                self.navigationController.tabBarItem.badgeValue = [updateTabBarBadge updateTabBarBadgeNum];

            }
            
            cell.avatarView.badge = activity_newNum;
            
            //            if (cell.avatarView.badge != activity_newNum) {
            //                self.navigationController.tabBarItem.badgeValue = @"N";
            //            }
            
            return cell;
            
        }else if (indexPath.row == 2){
            NSString *CellIdentifier = @"opportunity";
            EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            // 这里修改图片
            cell.avatarView.image = [UIImage imageNamed:@"newbusiness"];
            //            cell.titleLabel.text = NSLocalizedString(@"title.apply", @"Application and notification");
//            cell.titleLabel.text = @"新商机";
            cell.titleLabel.text = @"商机动态";
            
            NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
            NSInteger activity_newNum = [udefault integerForKey:@"Message_activity_newNum"];
            
            if (!activity_newNum) {
                activity_newNum = 0;
            }
            
            if (activity_newNum == 0) {
                
            }else {
//                self.navigationController.tabBarItem.badgeValue = @"B";
                self.navigationController.tabBarItem.badgeValue = [updateTabBarBadge updateTabBarBadgeNum];

            }
            
            cell.avatarView.badge = activity_newNum;
            
//            if (cell.avatarView.badge != activity_newNum) {
//                self.navigationController.tabBarItem.badgeValue = @"N";
//            }

            return cell;
        }else if (indexPath.row == 3){
            NSString *CellIdentifier = @"addFriend";
            EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            // 这里修改图片
            cell.avatarView.image = [UIImage imageNamed:@"newfriends"];
            //            cell.titleLabel.text = NSLocalizedString(@"title.apply", @"Application and notification");
            cell.titleLabel.text = @"新好友";
//            cell.avatarView.badge = self.unapplyCount;
            
//            if (cell.avatarView.badge != 0) {
//                self.navigationController.tabBarItem.badgeValue = @"F";
//            }
            
            NSInteger badge = 1;
            NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
            badge = [udefault integerForKey:@"MessageFriend"];
            cell.avatarView.badge = badge;
            
            if (!badge) {
                badge = 0;
            }
            
            if (badge == 0) {
                
            }else {
//                self.navigationController.tabBarItem.badgeValue = @"F";
                self.navigationController.tabBarItem.badgeValue = [updateTabBarBadge updateTabBarBadgeNum];

            }

            
            return cell;
        }else if (indexPath.row == 4){
            NSString *CellIdentifier = @"societyGroup";
            EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            // 这里修改图片
            cell.avatarView.image = [UIImage imageNamed:@"newassociation"];
            //            cell.titleLabel.text = NSLocalizedString(@"title.apply", @"Application and notification");
            cell.titleLabel.text = @"新社群";
            
            NSInteger badge = 1;
            NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
            badge = [udefault integerForKey:@"aGroupIdBadge"];
            cell.avatarView.badge = badge;
            
            if (!badge) {
                badge = 0;
            }
            
            if (badge == 0) {
                
            }else {
                //                self.navigationController.tabBarItem.badgeValue = @"G";
                self.navigationController.tabBarItem.badgeValue = [updateTabBarBadge updateTabBarBadgeNum];
                
            }
            
            self.societyGroupBadge = badge;
            return cell;
        }else if (indexPath.row == 0){
            NSString *CellIdentifier = @"CourseNew";
            EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            // 这里修改图片
            cell.avatarView.image = [UIImage imageNamed:@"newassociation"];
            //            cell.titleLabel.text = NSLocalizedString(@"title.apply", @"Application and notification");
            cell.titleLabel.text = @"学吧动态";
            
            NSInteger badge = 1;
            NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
            NSInteger badge1 = [udefault integerForKey:@"Message_course_NownewNum"];
            NSInteger badge2 = [udefault integerForKey:@"Message_course_LivenewNum"];
            badge = badge1 + badge2;
            cell.avatarView.badge = badge;
            
            if (!badge) {
                badge = 0;
            }
            
            if (badge == 0) {
                
            }else {
                //                self.navigationController.tabBarItem.badgeValue = @"G";
                self.navigationController.tabBarItem.badgeValue = [updateTabBarBadge updateTabBarBadgeNum];
                
            }
            
            self.societyGroupBadge = badge;
            return cell;
        }

    }
    
    NSString *CellIdentifier = [EaseConversationCell cellIdentifierWithModel:nil];
    EaseConversationCell *cell = (EaseConversationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[EaseConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([self.dataArray count] <= indexPath.row) {
        return cell;
    }
    
    id<IConversationModel> model = [self.dataArray objectAtIndex:indexPath.row];
    
    // 传入DDL 创建表打开数据库
    self.FMDBTool = [GLFMDBToolSDK shareToolsWithCreateDDL:nil];
    
    // 查询数据【banner】
    NSString *query_sql = @"select * from t_HXFriendDataSource";
    
    FMResultSet *result = [self.FMDBTool queryWithSql:query_sql];
    HXFriendDataSource *profileEntity = [HXFriendDataSource new];
    while ([result next]) { // next方法返回yes代表有数据可取
        
        profileEntity.HXid = [result stringForColumn:@"HXid"];
        
        if ([profileEntity.HXid isEqualToString:model.title]) {
            
            model.title = [result stringForColumn:@"nickname"];
            profileEntity.UserModel = [NSKeyedUnarchiver unarchiveObjectWithData:[result dataNoCopyForColumn:@"UserModel"]];
            if (profileEntity.UserModel.avatarURLPath) {
                model.avatarURLPath = profileEntity.UserModel.avatarURLPath;
            }
        }
    }
    
    /** 高林修改默认占位图像 */
    if (model.conversation.type == EMConversationTypeChat) {
        model.avatarImage = [UIImage imageNamed:@"HX_img_head"];
    }
    else{
        model.avatarImage = [UIImage imageNamed:@"grzx_contacts_qun"];
    }
//    model.avatarImage = [UIImage imageNamed:@"HX_img_head"];
    cell.model = model;
    
    if (!self.numBlock) {
        self.avatarBadge += cell.avatarView.badge;
    }
    

    NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];

    [udefault setInteger:self.avatarBadge forKey:@"PInfoavatarBadge"];
    self.avatarBadge = [udefault integerForKey:@"PInfoavatarBadge"];
    
    if (self.avatarBadge != 0) {
//        self.navigationController.tabBarItem.badgeValue = @"N";
        self.navigationController.tabBarItem.badgeValue = [updateTabBarBadge updateTabBarBadgeNum];

    }
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(conversationListViewController:latestMessageTitleForConversationModel:)]) {
//        self.avatarBadge -= cell.avatarView.badge;
        NSMutableAttributedString *attributedText = [[_dataSource conversationListViewController:self latestMessageTitleForConversationModel:model] mutableCopy];
        [attributedText addAttributes:@{NSFontAttributeName : cell.detailLabel.font} range:NSMakeRange(0, attributedText.length)];
        cell.detailLabel.attributedText =  attributedText;
    } else {
        cell.detailLabel.attributedText =  [[EaseEmotionEscape sharedInstance] attStringFromTextForChatting:[self _latestMessageTitleForConversationModel:model]textFont:cell.detailLabel.font];
    }
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(conversationListViewController:latestMessageTimeForConversationModel:)]) {
        cell.timeLabel.text = [_dataSource conversationListViewController:self latestMessageTimeForConversationModel:model];
    } else {
        cell.timeLabel.text = [self _latestMessageTimeForConversationModel:model];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else{
        return 22;
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [EaseConversationCell cellHeightWithModel:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.numBlock = YES;
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 99) {
                __block typeof (self) wself = self;
                
                dispatch_async(dispatch_queue_create("", nil), ^{
                    SendAndGetDataFromNet *send = [[SendAndGetDataFromNet alloc]init];
                    send.returnArray = ^(NSArray *ary){
                        MessageListVC *messageListVC = [[MessageListVC alloc]init];
                        messageListVC.dataAry = [[NSMutableArray alloc]initWithArray:ary];
                        [wself.navigationController pushViewController:messageListVC animated:YES];
                        wself.tabBarController.tabBar.hidden = YES;
                    };
                    MessageRequestModel *requestModel = [[MessageRequestModel alloc]init];
                    requestModel.access_token = [[LoginVM getInstance] readLocal].token;
                    requestModel.type = @"2";
                    [send dictDataFromNet:requestModel WithRelativePath:@"Get_Dynamic_MessageList"];
                });
            
//            ApplyFriendNoticeVC *applyFriendNoticeVC = [ApplyFriendNoticeVC new];
//            
//            applyFriendNoticeVC.hidesBottomBarWhenPushed = YES;
//            
//            [self.navigationController pushViewController:applyFriendNoticeVC animated:YES];
        }else if (row == 5)
        {
            // 点击了审核列表
            
            NewReferrerVC *newReferrerVC = [NewReferrerVC new];
            
            NSInteger badge = 0;
            NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
            [udefault setInteger:badge forKey:@"Message_reference_newNum"];
            
            newReferrerVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:newReferrerVC animated:YES];
            
            if ([self.navigationController.tabBarItem.badgeValue isEqualToString:@"G"]){
                
                //                self.navigationController.tabBarItem.badgeValue = @"N";
                self.navigationController.tabBarItem.badgeValue = [updateTabBarBadge updateTabBarBadgeNum];
            }
            
            
        }else if (row == 0)
        {
            // 点击了 学吧动态
            
            NewCourseListVC *newCourseListVC = [NewCourseListVC new];
            
            NSInteger badge = 0;
            NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
            [udefault setInteger:badge forKey:@"Message_course_LivenewNum"];
            [udefault setInteger:badge forKey:@"Message_course_NownewNum"];
            
            newCourseListVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:newCourseListVC animated:YES];
            
            if ([self.navigationController.tabBarItem.badgeValue isEqualToString:@"G"]){
                
                //                self.navigationController.tabBarItem.badgeValue = @"N";
                self.navigationController.tabBarItem.badgeValue = [updateTabBarBadge updateTabBarBadgeNum];
            }
            
            
        }else if (row == 1)
        {
            // 点击了新 提问
            
            NSInteger badge = 0;
            NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
            [udefault setInteger:badge forKey:@"Message_question_newNum"];
            
            NewQuestionListVC *vc = [NewQuestionListVC new];
            
            
            //            applyFriendNoticeVC.hidesBottomBarWhenPushed = YES;
            //
            [self.navigationController pushViewController:vc animated:YES];
            
            if ([self.navigationController.tabBarItem.badgeValue isEqualToString:@"Q"]){
                
//                self.navigationController.tabBarItem.badgeValue = @"N";
                self.navigationController.tabBarItem.badgeValue = [updateTabBarBadge updateTabBarBadgeNum];
            }
            
        }else if (row == 2)
        {
            // 点击了新 商机
            
            NSInteger badge = 0;
            NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
            [udefault setInteger:badge forKey:@"Message_activity_newNum"];
            
            NewBusinessListVC *vc = [NewBusinessListVC new];
            
            
            //            applyFriendNoticeVC.hidesBottomBarWhenPushed = YES;
            //
            [self.navigationController pushViewController:vc animated:YES];
            
            if ([self.navigationController.tabBarItem.badgeValue isEqualToString:@"B"]){
                
//                self.navigationController.tabBarItem.badgeValue = @"N";
                self.navigationController.tabBarItem.badgeValue = [updateTabBarBadge updateTabBarBadgeNum];
            }
            
        }else if (row == 3)
        {
            ApplyFriendNoticeVC *applyFriendNoticeVC = [ApplyFriendNoticeVC new];
            
            NSInteger badge = 0;
            NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
            [udefault setInteger:badge forKey:@"MessageFriend"];
            
            applyFriendNoticeVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:applyFriendNoticeVC animated:YES];
            if ([self.navigationController.tabBarItem.badgeValue isEqualToString:@"F"]){
                
//                self.navigationController.tabBarItem.badgeValue = @"N";
                self.navigationController.tabBarItem.badgeValue = [updateTabBarBadge updateTabBarBadgeNum];
            }
            
        }
        else if (row == 4)
        {
            ApplyGruopNoticeVC *applyGruopNoticeVC = [ApplyGruopNoticeVC new];
            
            NSInteger badge = 0;
            NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
            [udefault setInteger:badge forKey:@"aGroupIdBadge"];
            
            applyGruopNoticeVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:applyGruopNoticeVC animated:YES];
            
            if ([self.navigationController.tabBarItem.badgeValue isEqualToString:@"G"]){
                
//                self.navigationController.tabBarItem.badgeValue = @"N";
                self.navigationController.tabBarItem.badgeValue = [updateTabBarBadge updateTabBarBadgeNum];
            }

            //            ApplyGruopNoticeVC *applyGruopNoticeVC = [ApplyGruopNoticeVC new];
            //
            //            applyGruopNoticeVC.hidesBottomBarWhenPushed = YES;
            //
            //            [self.navigationController pushViewController:applyGruopNoticeVC animated:YES];
            
        }
        else if (row == 998)
        {
            
        }

    }else {
        if (_delegate && [_delegate respondsToSelector:@selector(conversationListViewController:didSelectConversationModel:)]) {
            EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
            [_delegate conversationListViewController:self didSelectConversationModel:model];
        } else {
            EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
            EaseMessageViewController *viewController = [[EaseMessageViewController alloc] initWithConversationChatter:model.conversation.conversationId conversationType:model.conversation.type];
            viewController.title = model.title;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    
        NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
        NSInteger PInfoavatarBadge = [udefault integerForKey:@"PInfoavatarBadge"];
        EaseConversationCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        PInfoavatarBadge -= cell.avatarView.badge;
        cell.avatarView.badge = 0;
//        NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
        [udefault setInteger:PInfoavatarBadge forKey:@"PInfoavatarBadge"];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [[EMClient sharedClient].chatManager deleteConversation:model.conversation.conversationId deleteMessages:YES];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - data

-(void)refreshAndSortView
{
    if ([self.dataArray count] > 1) {
        if ([[self.dataArray objectAtIndex:0] isKindOfClass:[EaseConversationModel class]]) {
            NSArray* sorted = [self.dataArray sortedArrayUsingComparator:
                               ^(EaseConversationModel *obj1, EaseConversationModel* obj2){
                                   EMMessage *message1 = [obj1.conversation latestMessage];
                                   EMMessage *message2 = [obj2.conversation latestMessage];
                                   if(message1.timestamp > message2.timestamp) {
                                       return(NSComparisonResult)NSOrderedAscending;
                                   }else {
                                       return(NSComparisonResult)NSOrderedDescending;
                                   }
                               }];
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:sorted];
        }
    }
    [self.tableView reloadData];
}

- (void)tableViewDidTriggerHeaderRefresh
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSArray* sorted = [conversations sortedArrayUsingComparator:
                       ^(EMConversation *obj1, EMConversation* obj2){
                           EMMessage *message1 = [obj1 latestMessage];
                           EMMessage *message2 = [obj2 latestMessage];
                           if(message1.timestamp > message2.timestamp) {
                               return(NSComparisonResult)NSOrderedAscending;
                           }else {
                               return(NSComparisonResult)NSOrderedDescending;
                           }
                       }];
    
    
    
    [self.dataArray removeAllObjects];
    for (EMConversation *converstion in sorted) {
        EaseConversationModel *model = nil;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(conversationListViewController:modelForConversation:)]) {
            model = [self.dataSource conversationListViewController:self
                                                   modelForConversation:converstion];
        }
        else{
            model = [[EaseConversationModel alloc] initWithConversation:converstion];
        }
        
        if (model) {
            [self.dataArray addObject:model];
        }
    }
    
    [self.tableView reloadData];
    [self tableViewDidFinishTriggerHeader:YES reload:NO];
}

#pragma mark - EMGroupManagerDelegate

- (void)didUpdateGroupList:(NSArray *)groupList
{
    [self tableViewDidTriggerHeaderRefresh];
}

#pragma mark - registerNotifications
-(void)registerNotifications{
    
//    [self unregisterNotifications];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].groupManager removeDelegate:self];
}

- (void)dealloc{
    [self unregisterNotifications];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MessageComing" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MessageFriend_add" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MessageFriend_agree" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Message_activity_new" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Message_question_new" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Message_reference_new" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Message_course_Livenew" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Message_course_Nownew" object:nil];
   
}

#pragma mark - private
- (NSString *)_latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTitle = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = NSEaseLocalizedString(@"message.image1", @"[image]");
            } break;
            case EMMessageBodyTypeText:{
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = NSEaseLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = NSEaseLocalizedString(@"message.location1", @"[location]");
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = NSEaseLocalizedString(@"message.video1", @"[video]");
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = NSEaseLocalizedString(@"message.file1", @"[file]");
            } break;
            default: {
            } break;
        }
    }
    return latestMessageTitle;
}

- (NSString *)_latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        double timeInterval = lastMessage.timestamp ;
        if(timeInterval > 140000000000) {
            timeInterval = timeInterval / 1000;
        }
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        latestMessageTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    }
    return latestMessageTime;
}

/** 接收到加好友的信息 */
- (void)MessageFriend_add:(NSNotification *)note
{
    NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
    NSInteger num = [udefault integerForKey:@"MessageFriend"];
    self.unapplyCount = num;
    
//    self.navigationController.tabBarItem.badgeValue = @"F";
    self.navigationController.tabBarItem.badgeValue = [updateTabBarBadge updateTabBarBadgeNum];
    
//    NSInteger Fbadge = [udefault integerForKey:@"Fbadge"];
    //    self.navigationController.tabBarItem.badgeValue = @"N";
    [self.tableView reloadData];
}

- (void)MessageFriend_agree:(NSNotification *)note
{
    NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
    NSInteger num = [udefault integerForKey:@"MessageFriend"];
    self.unapplyCount = num;
    
//    self.navigationController.tabBarItem.badgeValue = @"F";
    self.navigationController.tabBarItem.badgeValue = [updateTabBarBadge updateTabBarBadgeNum];
    
//    NSInteger Fbadge = [udefault integerForKey:@"Fbadge"];
    //    self.navigationController.tabBarItem.badgeValue = @"N";
    [self.tableView reloadData];
}

#pragma mark - 新商机回调信息展示
- (void)MessageActivity_new:(NSNotification *)note
{
    
    NSMutableArray *arrM = [NSMutableArray array];
    NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
    [arrM addObjectsFromArray:[udefault objectForKey:@"Message_activity_new"]];
    
    NSInteger num = [udefault integerForKey:@"Message_activity_newNum"];
    
    if (num) {
//        self.navigationController.tabBarItem.badgeValue = @"B";
        self.navigationController.tabBarItem.badgeValue = [updateTabBarBadge updateTabBarBadgeNum];
    }
    
    //    NSInteger Fbadge = [udefault integerForKey:@"Fbadge"];
    //    self.navigationController.tabBarItem.badgeValue = @"N";
    [self.tableView reloadData];
}

#pragma mark - 新提问回调信息展示
- (void)MessageQuestion_new:(NSNotification *)note
{
    
    NSMutableArray *arrM = [NSMutableArray array];
    NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
    [arrM addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:CachesNotificationQuestion]];
    
    NSInteger num = [udefault integerForKey:@"Message_question_newNum"];
    
    if (num) {
//        self.navigationController.tabBarItem.badgeValue = @"Q";
        self.navigationController.tabBarItem.badgeValue = [updateTabBarBadge updateTabBarBadgeNum];
    }
    
    //    NSInteger Fbadge = [udefault integerForKey:@"Fbadge"];
    //    self.navigationController.tabBarItem.badgeValue = @"N";
    [self.tableView reloadData];
}

#pragma mark - 推荐人 
- (void)MessageReference_new:(NSNotification *)note
{
    
    NSMutableArray *arrM = [NSMutableArray array];
    NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
    [arrM addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:CachesNotificationReference]];
    
    NSInteger num = [udefault integerForKey:@"Message_reference_newNum"];
    
    if (num) {
//        self.navigationController.tabBarItem.badgeValue = @"N";
        self.navigationController.tabBarItem.badgeValue = [updateTabBarBadge updateTabBarBadgeNum];
    }
    
    //    NSInteger Fbadge = [udefault integerForKey:@"Fbadge"];
    //    self.navigationController.tabBarItem.badgeValue = @"N";
    [self.tableView reloadData];
}

#pragma mark - 直播通知
- (void)MessageCourse_Livenew:(NSNotification *)note
{
    
    NSMutableArray *arrM = [NSMutableArray array];
    NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
    [arrM addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:CachesNotificationLiveTime]];
    
    NSInteger num = [udefault integerForKey:@"Message_course_LivenewNum"];
    
    if (num) {
        //        self.navigationController.tabBarItem.badgeValue = @"N";
        self.navigationController.tabBarItem.badgeValue = [updateTabBarBadge updateTabBarBadgeNum];
    }
    
    //    NSInteger Fbadge = [udefault integerForKey:@"Fbadge"];
    //    self.navigationController.tabBarItem.badgeValue = @"N";
    [self.tableView reloadData];
}

#pragma mark - 音视频通知
- (void)MessageCourse_Nownew:(NSNotification *)note
{
    
    NSMutableArray *arrM = [NSMutableArray array];
    NSUserDefaults *udefault = [NSUserDefaults standardUserDefaults];
    [arrM addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:CachesNotificationCourseNow]];
    
    NSInteger num = [udefault integerForKey:@"Message_course_NownewNum"];
    
    if (num) {
        //        self.navigationController.tabBarItem.badgeValue = @"N";
        self.navigationController.tabBarItem.badgeValue = [updateTabBarBadge updateTabBarBadgeNum];
    }
    
    //    NSInteger Fbadge = [udefault integerForKey:@"Fbadge"];
    //    self.navigationController.tabBarItem.badgeValue = @"N";
    [self.tableView reloadData];
}

@end