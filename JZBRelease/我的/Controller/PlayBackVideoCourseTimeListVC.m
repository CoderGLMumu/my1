//
//  PlayBackVideoCourseTimeListVC.m
//  JZBRelease
//
//  Created by cl z on 16/9/21.
//  Copyright © 2016年 zjapple. All rights reserved.
//


#import "PlayBackVideoCourseTimeListVC.h"

#import "MJRefresh.h"
#import "HttpManager.h"
#import "GetCourseTimeListModel.h"
#import "Defaults.h"
#import "XBLiveVideoCell.h"
#import "CourseTimeModel.h"
#import "CourseTimeVC.h"
#import "AliVcMoiveViewController.h"
#import <AliyunPlayerSDK/AliVcMediaPlayer.h>
#import "AlivcLiveViewController.h"
#import <AlivcLiveVideo/AlivcLiveVideo.h>
#import "AskAnswerItem.h"
#import "XBVideoPlayerVC.h"
#import "LiveVideoDetailItem.h"
#import "VideoDetailXGKCCell.h"

@interface PlayBackVideoCourseTimeListVC ()<UITableViewDelegate,UITableViewDataSource,AliVcAccessKeyProtocol>{
    //NSMutableArray *courseAry;
    BOOL footerFresh;
    
    NSInteger pageNum;
    NSInteger requestCount;
}

@property(nonatomic,assign) NSInteger requestCount;
@property(nonatomic,strong) NSMutableArray *courseAry;

/** item */
@property (nonatomic, strong) LiveVideoDetailItem *liveitem;

@end

@implementation PlayBackVideoCourseTimeListVC

- (void)viewDidLoad {
    
    pageNum = 0;
    requestCount = 0;
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"课程录像列表";
    //[self configNav];
    [self createTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)configNav
{
    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 35, 28)];
    [sendBtn setImage:[UIImage imageNamed:@"BQ_DT_release"] forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(addCourseTime) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    UIBarButtonItem *sendBarBtn = [[UIBarButtonItem alloc]initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem = sendBarBtn;
}

- (void) addCourseTime{
    CourseTimeVC *courseTimeVC = [[CourseTimeVC alloc]init];
    courseTimeVC.course_id = self.course_id;
    __weak typeof (self) wself = self;
    courseTimeVC.returnAction = ^(){
        [wself.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:courseTimeVC animated:YES];
}

- (void)createTableView{
    NSLog(@"self.view.frame.size.height %f",self.view.frame.size.height);
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f2f2f2"];
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    __unsafe_unretained UITableView *tableView1 = self.tableView;
    
    // 下拉刷新
    tableView1.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self createData];
        footerFresh = NO;
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView1.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            // 结束刷新
        //            [tableView1.mj_footer endRefreshing];
        //        });
        footerFresh = YES;
        [self createFootData];
    }];
    [tableView1.mj_header beginRefreshing];
}

- (void)createData{
    NSLog(@"-----------头部刷新数据-----------");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self downloadData];
        
    });
    
}

- (void)createFootData{
    NSLog(@"-----------尾部加载更多数据-----------");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        for (int i = 200; i < 210; i ++) {
        //            [self.dataSource addObject:[NSString stringWithFormat:@"%d",i]];
        //        }
        [self downloadData];
        
        //        [_refresh endRefresh];
    });
}

- (void)downloadData {
    dispatch_async(dispatch_queue_create("", nil), ^{
        [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
            if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
                GetCourseTimeListModel *model = [[GetCourseTimeListModel alloc]init];
                model.access_token = [[LoginVM getInstance] readLocal].token;
                model.id = @"0";
                model.course_id = self.course_id;
                model.t = @"3";
                model.type = @"3";
                if (footerFresh) {
                    pageNum++;
                    
                    model.page = [NSString stringWithFormat:@"%ld",(long)pageNum];
                }else{
                    pageNum = 0;
                    model.page = [NSString stringWithFormat:@"%ld",(long)pageNum];
                }
                model.limit = @"10";
                model.user_id = [[LoginVM getInstance]readLocal]._id;
                model.my = @"1";
               
                SendAndGetDataFromNet *send = [[SendAndGetDataFromNet alloc]init];
                __block typeof (send) wsend = send;
                __weak typeof (self) wself = self;
                send.returnArray = ^(NSArray *ary){
                    if (!ary) {
                        if (wself.requestCount > 1) {
                            [wself refreshComplete];
                            [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:0.8];
                            return ;
                        }
                        [LoginVM getInstance].isGetToken = ^(){
                            model.access_token = [[LoginVM getInstance] readLocal].token;
                            [wsend commenDataFromNet:model WithRelativePath:@"Get_CourseTime_List_URL"];
                            wself.requestCount ++;
                        };
                        [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
                        
                    }else{
                        wself.requestCount = 0;
                        
                        if (footerFresh) {
                            //                            NSInteger beginCount = self.courseAry.count - 1;
                            //[self.fakeDatasource insertObjects:ary atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(beginCount, ary.count)]];
                            
                            for (int i = 0; i < ary.count; i ++) {
                                CourseTimeModel *courseTimeModel = [CourseTimeModel mj_objectWithKeyValues:[ary objectAtIndex:i]];
                                if ([courseTimeModel isKindOfClass:[CourseTimeModel class]]) {
                                    if (courseTimeModel) {
                                        [self.courseAry addObject:courseTimeModel];
                                    }
                                }
                            }
                            
                        }else{
                            
                            if (!self.courseAry) {
                                self.courseAry = [[NSMutableArray alloc]init];
                            }
                            [self.courseAry removeAllObjects];
                            for (int i = 0; i < ary.count; i ++) {
                                CourseTimeModel *courseTimeModel = [CourseTimeModel mj_objectWithKeyValues:[ary objectAtIndex:i]];
                                if ([courseTimeModel isKindOfClass:[CourseTimeModel class]]) {
                                    if (courseTimeModel) {
                                        [self.courseAry addObject:courseTimeModel];
                                    }
                                }
                            }
                        }
                        [self downloadData1];
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [self refreshComplete];
//                            
//                        });
                    }
                };
                [send dictDataFromNet:model WithRelativePath:@"Get_CourseTime_List_URL"];
                
            }else{
                [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:1.2];
            }
        }];
    });
}


- (void)refreshComplete {
    //[self.tableViewHeader refreshingAnimateStop];
    [UIView animateWithDuration:0.35f animations:^{
       // self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        [self.tableView reloadData];
        
        if (footerFresh) {
            footerFresh = NO;
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_header endRefreshing];
        }
    }];
}

- (void)downloadData1 {
    dispatch_async(dispatch_queue_create("", nil), ^{
        [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
            if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
                GetCourseTimeListModel *model = [[GetCourseTimeListModel alloc]init];
                model.access_token = [[LoginVM getInstance] readLocal].token;
                model.id = @"0";
                model.course_id = self.course_id;
                model.t = @"3";
                model.type = @"1";
                if (footerFresh) {
                    pageNum++;
                    
                    model.page = [NSString stringWithFormat:@"%ld",(long)pageNum];
                }else{
                    pageNum = 0;
                    model.page = [NSString stringWithFormat:@"%ld",(long)pageNum];
                }
                model.limit = @"10";
                model.user_id = [[LoginVM getInstance]readLocal]._id;
                model.my = @"1";
                
                SendAndGetDataFromNet *send = [[SendAndGetDataFromNet alloc]init];
                __block typeof (send) wsend = send;
                __weak typeof (self) wself = self;
                send.returnArray = ^(NSArray *ary){
                    if (!ary) {
                        if (wself.requestCount > 1) {
                            [wself refreshComplete];
                            [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:0.8];
                            return ;
                        }
                        [LoginVM getInstance].isGetToken = ^(){
                            model.access_token = [[LoginVM getInstance] readLocal].token;
                            [wsend commenDataFromNet:model WithRelativePath:@"Get_CourseTime_List_URL"];
                            wself.requestCount ++;
                        };
                        [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
                        
                    }else{
                        wself.requestCount = 0;
                        
                        if (footerFresh) {
                            //                            NSInteger beginCount = self.courseAry.count - 1;
                            //[self.fakeDatasource insertObjects:ary atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(beginCount, ary.count)]];
                            
                            for (int i = 0; i < ary.count; i ++) {
                                CourseTimeModel *courseTimeModel = [CourseTimeModel mj_objectWithKeyValues:[ary objectAtIndex:i]];
                                if ([courseTimeModel isKindOfClass:[CourseTimeModel class]]) {
                                    if (courseTimeModel) {
                                        [self.courseAry addObject:courseTimeModel];
                                    }
                                }
                            }
                            
                        }else{
                            
                            if (!self.courseAry) {
                                self.courseAry = [[NSMutableArray alloc]init];
                            }
                            
                            for (int i = 0; i < ary.count; i ++) {
                                CourseTimeModel *courseTimeModel = [CourseTimeModel mj_objectWithKeyValues:[ary objectAtIndex:i]];
                                if ([courseTimeModel isKindOfClass:[CourseTimeModel class]]) {
                                    if (courseTimeModel) {
                                        [self.courseAry addObject:courseTimeModel];
                                    }
                                }
                            }
                            
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self refreshComplete];
                            
                        });
                    }
                };
                [send dictDataFromNet:model WithRelativePath:@"Get_CourseTime_List_URL"];
                
            }else{
                [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:1.2];
            }
        }];
    });
}






-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.courseAry) {
        
        /** 全部列表页面的空数据占位图片 */
        notDataShowView *view;
        
        if (self.courseAry.count) {
            if ([notDataShowView sharenotDataShowView].superview) {
                [[notDataShowView sharenotDataShowView] removeFromSuperview];
            }
        }else {
            view = [notDataShowView sharenotDataShowView:tableView];
            [tableView addSubview:view];
            
        }
        
        return self.courseAry.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"VideoDetailXGKCCell";
    VideoDetailXGKCCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        UINib *nib = [UINib nibWithNibName:@"VideoDetailXGKCCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellID];
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    }
    if (self.courseAry.count > indexPath.row) {
        cell.item = [self.courseAry objectAtIndex:indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //XBLiveVideoCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    CourseTimeModel *courseTimeModel;
    if (self.courseAry.count > indexPath.row) {
        
        courseTimeModel = [self.courseAry objectAtIndex:indexPath.row];
        //        NSLog(@"%ld--%@",(long)indexPath.row,[self.courseAry objectAtIndex:indexPath.row]);
    }
    
    dispatch_async(dispatch_queue_create("", nil), ^{
        [[HttpManager shareManager] netStatus:^(AFNetworkReachabilityStatus status) {
            if(status == AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi){
                GetCourseTimeListModel *model = [[GetCourseTimeListModel alloc]init];
                model.access_token = [[LoginVM getInstance] readLocal].token;
                model.id = courseTimeModel.id;
                model.course_id = self.course_id;
                if (footerFresh) {
                    
                }else{
                    model.page = @"0";
                }
                
                model.user_id = [[LoginVM getInstance]readLocal]._id;
                model.my = @"1";
                
                SendAndGetDataFromNet *send = [[SendAndGetDataFromNet alloc]init];
                __weak typeof (send) wsend = send;
                __weak typeof (self) wself = self;
                send.returnDict = ^(NSDictionary *dict){
                    if (!dict) {
                        if (wself.requestCount > 1) {
                            [wself refreshComplete];
                            [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:0.8];
                            return ;
                        }
                        [LoginVM getInstance].isGetToken = ^(){
                            model.access_token = [[LoginVM getInstance] readLocal].token;
                            [wsend commenDataFromNet:model WithRelativePath:@"Get_CourseTime_List_URL"];
                            wself.requestCount ++;
                        };
                        [[LoginVM getInstance] loginWithUserInfoForGetNewToken:[[LoginVM getInstance] readLocal]];
                        
                    }else{
                        wself.requestCount = 0;
                        
                        if (footerFresh) {
                            NSInteger beginCount = self.courseAry.count - 1;
                            //[self.fakeDatasource insertObjects:ary atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(beginCount, ary.count)]];
                            
                            footerFresh = NO;
                        }else{
                            if (!self.courseAry) {
                                self.courseAry = [[NSMutableArray alloc]init];
                            }
                            //                            [self.courseAry removeAllObjects];
                            
                            LiveVideoDetailItem *courseTimeModel = [LiveVideoDetailItem mj_objectWithKeyValues:dict[@"data"]];
                            
                            if ([courseTimeModel isKindOfClass:[LiveVideoDetailItem class]]) {
//                                XBVideoPlayerVC
                                XBVideoPlayerVC *mobilevideoShowVC = [[XBVideoPlayerVC alloc] init];
                                
                                mobilevideoShowVC.playUrl = courseTimeModel.play_paths[0];
                                mobilevideoShowVC.detailItem = courseTimeModel;
                                
                                mobilevideoShowVC.teacher = courseTimeModel.teacher;
                                mobilevideoShowVC.join_list_user = courseTimeModel.join_list;
                                mobilevideoShowVC.class_id = courseTimeModel.aid;
                                
                                self.liveitem.question = [AskAnswerItem mj_objectArrayWithKeyValuesArray:courseTimeModel.question];
                                
                                mobilevideoShowVC.question = courseTimeModel.question;
                                
                                [self presentViewController:mobilevideoShowVC animated:YES completion:nil ];
                            
                            }
                            
                            
//                            if ([courseTimeModel isKindOfClass:[CourseTimeModel class]]) {
//                                if (courseTimeModel) {
//                                    //                                        NSLog(@"gaolinTTT%@",courseTimeModel);
//                                    NSString *str = courseTimeModel.push_path;
//                                    
//                                    if (![str containsString:@"rtmp://"]) {
//                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推流地址格式错误，无法直播" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                                        [alert show];
//                                        return;
//                                    }
//                                    
//                                    AlivcLiveViewController *live = [[AlivcLiveViewController alloc] initWithNibName:@"AlivcLiveViewController" bundle:nil url:str];
//                                    live.isScreenHorizontal = NO;
//                                    
//                                    live.question = [AskAnswerItem mj_objectArrayWithKeyValuesArray:courseTimeModel.question];
//                                    live.class_id = courseTimeModel.id;
//                                    live.teacher = courseTimeModel.teacher;
//                                    live.join_list_user = courseTimeModel.join_list;
//                                    live.start_time = courseTimeModel.start_time;
//                                    live.end_time = courseTimeModel.end_time;
//                                    
//                                    [self presentViewController:live animated:YES completion:nil];
//                                }
//                            }
                        }
                        
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self refreshComplete];
                        
                    });
                    
                };
                [send dictFromNet:model WithRelativePath:@"Get_CourseTime_List_URL"];
                
            }else{
                [Toast makeShowCommen:@"您的网络有问题 " ShowHighlight:@"请重置" HowLong:1.2];
            }
        }];
    });
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 276;
}


@end
