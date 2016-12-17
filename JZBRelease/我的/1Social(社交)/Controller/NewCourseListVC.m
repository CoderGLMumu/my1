//
//  NewBusinessListVC.m
//  JZBRelease
//
//  Created by Apple on 16/11/2.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "NewCourseListVC.h"
#import "CommerChanceCell.h"

#import "MoreCommerChanceVC.h"
#import "BBActivityDetailVC.h"
#import "CommerChanceCellModel.h"
#import "MJRefresh.h"
#import "pushNotificationCell.h"
#import "BCH_Alert.h"
#import "ApplyVipVC.h"

#import "LiveVideoViewController.h"

#import "HttpManager.h"
#import "GetCourseTimeListModel.h"

@interface NewCourseListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) NSInteger tag;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** num */
@property (nonatomic, assign) int pageN;

@end

@implementation NewCourseListVC

static NSString *ID = @"NewCourseCell";

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"学吧动态";
    
    self.pageN = 1;
    self.pageN = 0;
    
    [self setupTableView];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)setupTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, GLScreenW, GLScreenH - 64) style:UITableViewStylePlain];
    
    
    [tableView registerNib:[UINib nibWithNibName:@"pushNotificationCell" bundle:nil] forCellReuseIdentifier:ID];
    

    //有数据才有分割线
    tableView.tableFooterView = [[UIImageView alloc]init];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
    tableView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"f8f8f8"];
    //    tableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    // 告诉tabelView在编辑模式下可以多选
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
}

#pragma mark - 更新数据源-数据
- (void)loadData
{
    NSArray *arr1 = [NSKeyedUnarchiver unarchiveObjectWithFile:CachesNotificationLiveTime];
    NSArray *arr2 = [NSKeyedUnarchiver unarchiveObjectWithFile:CachesNotificationCourseNow];
    
    [self.dataSource removeAllObjects];
    
    [self.dataSource addObjectsFromArray:arr1];
    [self.dataSource addObjectsFromArray:arr2];
    
    [self.tableView reloadData];
  
}


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /** 全部列表页面的空数据占位图片 */
    notDataShowView *view;
    
    if (self.dataSource.count) {
        if ([notDataShowView sharenotDataShowView].superview) {
            [[notDataShowView sharenotDataShowView] removeFromSuperview];
        }
    }else {
        view = [notDataShowView sharenotDataShowView:tableView];
        [tableView addSubview:view];
        
    }
    
    return self.dataSource.count;
}

- (pushNotificationCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    pushNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.item = self.dataSource[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (!appD.vip) {
        [UIView bch_showWithTitle:@"提示" message:@"查看课程详情要先加入建众帮会员哦！" buttonTitles:@[@"取消",@"确定"] callback:^(id sender, NSUInteger buttonIndex) {
            if (1 == buttonIndex) {
                
                ApplyVipVC *applyVipVC = [[ApplyVipVC alloc]init];
                [self.navigationController pushViewController:applyVipVC animated:YES];
              
            }
        }];
        return;
    };
    
    if (self.dataSource.count > indexPath.row) {
        PushextrasItem *item = self.dataSource[indexPath.row];
        GLLog(@"%@",item.id)
        
        LiveVideoViewController *vc = [[LiveVideoViewController alloc]init];
       

        HttpBaseRequestItem *Reitem = [HttpBaseRequestItem new];
        Reitem.access_token = [[LoginVM getInstance]readLocal].token;
        Reitem.id = item.id;
        NSDictionary *parameters = Reitem.mj_keyValues;

        [SVProgressHUD showWithStatus:@"正在读取..."];

        [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Study/getClass"] parameters:parameters success:^(id json) {

            [SVProgressHUD dismiss];
            
            publicBaseDJsonItem *item = [publicBaseDJsonItem mj_objectWithKeyValues:json];

        if ([item.state isEqual:@(0)]) {
            [SVProgressHUD showInfoWithStatus:item.info];
            return ;
        }
            
            CourseTimeModel *liveListItem = [CourseTimeModel mj_objectWithKeyValues:item.data];
            
            if (liveListItem.id == nil) {
                return ;
            }
            
            vc.item = liveListItem;
            
            if ([liveListItem.type isEqualToString:@"1"] ||[liveListItem.type isEqualToString:@"2"]) {
                vc.isBackVideo = YES;
            }
            
            [self.navigationController pushViewController:vc animated:YES];
            [self setHidesBottomBarWhenPushed:YES];

//            NSLog(@"TTT--json%@",json);
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
        
//        vc.item = item.id;
        
        
    }
    
}

//分隔线左对齐
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataSource.count > indexPath.row) {
        
        PushextrasItem *item = self.dataSource[indexPath.row];
        
        return 47 + [self getStringRect:item.content].height;
    }
    return 0;
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



@end
