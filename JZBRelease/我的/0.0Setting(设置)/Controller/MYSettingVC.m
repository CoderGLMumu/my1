//
//  MYSettingVC.m
//  JZBRelease
//
//  Created by zjapple on 16/8/23.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "MYSettingVC.h"
#import "LoginVC.h"

#import "AppDelegate.h"

#import "PlayerDowning.h"

#import "ZFDownloadManager.h"

@interface MYSettingVC ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *LogoutButton;

@end

@implementation MYSettingVC
/** 本页面及其子页面大都使用storyboard进行跳转 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setUpView];
}

- (void)setUpView
{
    self.LogoutButton.layer.cornerRadius = 25;
    self.LogoutButton.clipsToBounds = YES;
    if ([[[LoginVM getInstance] readLocal].account isEqualToString:@"13322223333"]) {
        [self.LogoutButton setTitle:@"登录" forState:UIControlStateNormal];
    }else{
        [self.LogoutButton setTitle:@"退出" forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
- (IBAction)exitBtnAction:(id)sender {
    if ([[[LoginVM getInstance] readLocal].account isEqualToString:@"13322223333"]) {
        [[PlayerDowning sharePlayerDowning]ClickAllPause:nil];
        
        [ZFDownloadManager sharedInstance].sessionModelsArray = nil;
        
        LoginVC *loginVC = [[LoginVC alloc]init];
        
        AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        appD.notAutoLogin = YES;
        NSUserDefaults *defautls = [NSUserDefaults standardUserDefaults];
        [defautls setBool:appD.notAutoLogin forKey:@"notAutoLogin"];
        
        loginVC.isClearPassword = YES;
        
        [self.navigationController pushViewController:loginVC animated:YES];
        
        EMError *error = [[EMClient sharedClient] logout:YES];
        if (!error) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //[SVProgressHUD showInfoWithStatus:@"退出成功"];
            });
        }
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"退出不会删除本地信息" message:@"仍然确定退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (1 == buttonIndex) {
        
        [[PlayerDowning sharePlayerDowning]ClickAllPause:nil];
        
        [ZFDownloadManager sharedInstance].sessionModelsArray = nil;
        
        LoginVC *loginVC = [[LoginVC alloc]init];
        
        AppDelegate *appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        appD.notAutoLogin = YES;
        NSUserDefaults *defautls = [NSUserDefaults standardUserDefaults];
        [defautls setBool:appD.notAutoLogin forKey:@"notAutoLogin"];
        
        loginVC.isClearPassword = YES;
        
        [self.navigationController pushViewController:loginVC animated:YES];
        
        EMError *error = [[EMClient sharedClient] logout:YES];
        if (!error) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD showInfoWithStatus:@"退出成功"];
            });
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 21;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

#pragma mark - Table view data source


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
