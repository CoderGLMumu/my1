//
//  ApplyFriendNoticeVC.m
//  JZBRelease
//
//  Created by zjapple on 16/8/6.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "ApplyFriendNoticeVC.h"
#import "HXApplyFriendCell.h"
#import "UserInfo.h"
#import "HXApplyFriendItem.h"
#import "SendAndGetDataFromNet.h"

#import "HXDataHelper.h"

@interface ApplyFriendNoticeVC ()
{
    UserInfo *userInfo;
}

/** HXapplyFriendItems */
@property (nonatomic, strong) NSMutableArray *HXapplyFriendItems;

/** FMDBTool */
@property (nonatomic, strong) GLFMDBToolSDK *FMDBTool;

@end

@implementation ApplyFriendNoticeVC

- (GLFMDBToolSDK *)FMDBTool
{
    if (_FMDBTool == nil) {
        _FMDBTool = [GLFMDBToolSDK shareToolsWithCreateDDL:nil];
    }
    return _FMDBTool;
}

- (NSMutableArray *)HXapplyFriendItems
{
    if (_HXapplyFriendItems == nil) {
        _HXapplyFriendItems = [NSMutableArray array];
    }
    return _HXapplyFriendItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.title = @"个人申请与通知";
    
    [self setuptitleView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HXApplyFriendCell" bundle:nil] forCellReuseIdentifier:@"applyFriendCell"];
    
    [self loadDataSource];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[HXDataHelper alloc]loadHXDataWithComplete:nil];
}

- (void)loadDataSource
{
    
    userInfo = [[LoginVM getInstance]readLocal];
    
    NSDictionary *parameters = @{
                                @"access_token":userInfo.token,
                                @"new":@"1"
                                 };
    
    
    
    [HttpToolSDK postWithURL:[[ValuesFromXML getValueWithName:abPath WithKind:XMLTypeNetPort] stringByAppendingPathComponent:@"Web/Message/friend"] parameters:parameters success:^(id json) {
        
        if ([json[@"state"] isEqual:@(1)]) {
            [HXApplyFriendItem new];
           NSArray *tempArr = [HXApplyFriendItem mj_objectArrayWithKeyValuesArray:json[@"data"]];
            
            // 查询数据【LBDarmaBanaerModel】
            NSString *query_sql = [NSString stringWithFormat:@"select * from t_HXapplyFriendItems where _id = '%@'",userInfo._id];
//            @"select * from t_HXapplyFriendItems";
            
            FMResultSet *result = [self.FMDBTool queryWithSql:query_sql];
            
            while ([result next]) { // next方法返回yes代表有数据可取
                HXApplyFriendItem *model = [HXApplyFriendItem new];
                model.recode_uid = [result stringForColumn:@"recode_uid"];
                model.message_content = [result stringForColumn:@"message_content"];
                model.recode_u_avatar = [result stringForColumn:@"recode_u_avatar"];
                model.recode_u_nickname = [result stringForColumn:@"recode_u_nickname"];
                model.create_time = [result stringForColumn:@"create_time"];
                model.status = [result stringForColumn:@"status"];
                model.type = [result stringForColumn:@"type"];
                model.ustate = [result stringForColumn:@"ustate"];
                model.isConfirm = [result boolForColumn:@"isConfirm"];
                [self.HXapplyFriendItems addObject:model];
            }
            
            [self.HXapplyFriendItems addObjectsFromArray:tempArr];
            
            /** FMDB缓存 */
            if (tempArr.count) {
                NSString *delete_sql = @"delete from t_HXapplyFriendItems";
                [self.FMDBTool deleteWithSql:delete_sql];
                for (HXApplyFriendItem *model in self.HXapplyFriendItems) {
                    NSString *insert_sql = [NSString stringWithFormat:@"insert into t_HXapplyFriendItems (_id,recode_uid,message_content,recode_u_avatar,recode_u_nickname,create_time,status,type,ustate,isConfirm) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%d');",userInfo._id,model.recode_uid,model.message_content,model.recode_u_avatar,model.recode_u_nickname,model.create_time,model.status,model.type,model.ustate,model.isConfirm];
                    [self.FMDBTool insertWithSql:insert_sql, nil];
                }
            }
        }
        
        [self.tableView reloadData];
//        NSLog(@"gaolinjson=%@",json);
    } failure:^(NSError *error) {
        
    }];
}


- (void)setuptitleView
{
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.glw_width - 112 * 2, 40)];
    titleLable.text = @"个人申请与通知";
    titleLable.textColor = [UIColor hx_colorWithHexRGBAString:@"ffffff"];
    titleLable.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLable;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    /** 全部列表页面的空数据占位图片 */
    notDataShowView *view;
    
    if (self.HXapplyFriendItems.count) {
        if ([notDataShowView sharenotDataShowView].superview) {
            [[notDataShowView sharenotDataShowView] removeFromSuperview];
        }
    }else {
        view = [notDataShowView sharenotDataShowView:tableView];
        [tableView addSubview:view];
        
    }
    
    return self.HXapplyFriendItems.count;
}


- (HXApplyFriendCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXApplyFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"applyFriendCell" forIndexPath:indexPath];
    
    cell.model = self.HXapplyFriendItems[indexPath.row];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
