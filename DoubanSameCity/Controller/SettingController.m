//
//  SettingController.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/29.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "SettingController.h"
#import "LoginController.h"

@interface SettingController ()

@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)initUI{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat tableX = 0;
    CGFloat tableY = 0;
    CGFloat tableW = screenSize.width;
    CGFloat tableH = screenSize.height / 2;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(tableX, tableY, tableW, tableH)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self. tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:self.tableView];
    
    
    CGFloat outY = screenSize.height - Span - ButtonH;
    CGFloat outX = 2 * Span;
    CGFloat outW = screenSize.width - 4 * Span;
    CGFloat outH = ButtonH;
    self.loginOutButton = [[UIButton alloc] initWithFrame:CGRectMake(outX, outY, outW, outH)];
    [self.loginOutButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
    self.loginOutButton.backgroundColor = UIColorFromRGB(0xB4EEB4);
    [self.loginOutButton addTarget:self action:@selector(logOutAccount:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginOutButton];
    
    
    CGFloat switchX = outX;
    CGFloat switchY = outY - Span - ButtonH;
    CGFloat switchW = outW;
    CGFloat switchH = ButtonH;
    self.switchButton = [[UIButton alloc] initWithFrame:CGRectMake(switchX, switchY, switchW, switchH)];
    [self.switchButton setTitle:@"切换账号" forState:UIControlStateNormal];
    self.switchButton.backgroundColor = UIColorFromRGB(0xB4EEB4);
    [self.switchButton addTarget:self action:@selector(switchAccount:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.switchButton];
    
    if (![Config getLoginUserId]) {
        self.loginOutButton.hidden = YES;
        self.switchButton.hidden = YES;
    }
}

- (void)logOutAccount:(UIButton *)sender{
    [Config logOut];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"push_reloadData" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)switchAccount:(UIButton *)sender{
//    OAutoController *oauto = [[OAutoController alloc] init];
    LoginController *oauto = [[LoginController alloc] init];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"push_reloadData" object:nil];
    [self presentViewController:oauto animated:YES completion:nil];
    
}

#pragma mark -tableDelegate Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return  1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifer];
    }
    if (indexPath.section == 0){
          __block float totals = 0;
        cell.textLabel.text = @"清除图片缓存";
        [SDWebImageManager.sharedManager.imageCache
         calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
             totals = (float)totalSize / 1024 / 1024;
              cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM", totals];
         }];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0 && indexPath.row == 0) {
        [[[SDWebImageManager sharedManager] imageCache] clearDisk];
        [[[SDWebImageManager sharedManager] imageCache] clearMemory];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        [[[[Toast makeText:@"清理完成"] setGravity:ToastGravityBottom] setDuration:ToastDurationShort] show];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
