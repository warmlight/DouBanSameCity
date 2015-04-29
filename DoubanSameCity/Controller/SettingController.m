//
//  SettingController.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/29.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "SettingController.h"

@interface SettingController ()

@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkTmpSize];
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
    
    
    CGFloat outY = screenSize.height - Span - ButtonH;
    CGFloat outX = 2 * Span;
    CGFloat outW = screenSize.width - 4 * Span;
    CGFloat outH = ButtonH;
    self.loginOutButton = [[UIButton alloc] initWithFrame:CGRectMake(outX, outY, outW, outH)];
    [self.loginOutButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
    self.loginOutButton.backgroundColor = UIColorFromRGB(0xB4EEB4);
    [self.loginOutButton addTarget:self action:@selector(logOutAccount:) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGFloat switchX = outX;
    CGFloat switchY = outY - Span - ButtonH;
    CGFloat switchW = outW;
    CGFloat switchH = ButtonH;
    self.switchButton = [[UIButton alloc] initWithFrame:CGRectMake(switchX, switchY, switchW, switchH)];
    [self.switchButton setTitle:@"切换账号" forState:UIControlStateNormal];
    self.switchButton.backgroundColor = UIColorFromRGB(0xB4EEB4);
    [self.switchButton addTarget:self action:@selector(switchAccount:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)logOutAccount:(UIButton *)sender{
    
}

- (void)switchAccount:(UIButton *)sender{
    
}

#pragma mark -tableDelegate Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return  1;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifer];
    }
    cell.textLabel.text = @"清除图片缓存";
    cell.detailTextLabel.text = @"23333";
    return cell;
}


-(float)checkTmpSize {
    __weak typeof(self) weakSelf = self;
    [SDWebImageManager.sharedManager.imageCache
     calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
         weakSelf.totalSize = totalSize;
     }];
    
//    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:diskCachePath];
//    for (NSString *fileName in fileEnumerator) {
//        NSString *filePath = [diskCachePath stringByAppendingPathComponent:fileName];
//        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
//        unsigned long long length = [attrs fileSize];
//        totalSize += length / 1024.0 / 1024.0;
//    } // NSLog(@"tmp size is %.2f",totalSize); return totalSize;
    NSLog(@"%u", self.totalSize);
    return self.totalSize;
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
