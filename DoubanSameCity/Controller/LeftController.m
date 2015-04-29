//
//  LeftController.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/17.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "LeftController.h"

@interface LeftController ()

@end

@implementation LeftController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self initUI];

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(receivedNotification:) name:@"push_reloadData" object:nil];
    // Do any additional setup after loading the view.
}

- (void)receivedNotification:(NSNotification *)notification{
    [self.tableView reloadData];
}

- (void)initUI{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat tableX = 0;
    CGFloat tableY = 0;
    CGFloat tableW = screenSize.width;
    CGFloat tableH = screenSize.height;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(tableX, tableY, tableW, tableH)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = [[LeftHeadView alloc] init];

    [self.view addSubview:self.tableView];

    CGFloat headW = 100;
    CGFloat headH = headW;
    CGFloat headX = (screenSize.width / 5 * 3 - headW) / 2;
    CGFloat headY = 70;
    self.headView = [[HeadPortraitView alloc] initWithFrame:CGRectMake(headX, headY, headW, headH)];
    
    self.headView.userInteractionEnabled = YES;
    CGFloat nameX = 0;
    CGFloat nameY = headY + headH + 20;
    CGFloat nameW = screenSize.width / 5 * 3;
    CGFloat nameH = 40;
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameX, nameY, nameW, nameH)];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:15];
    self.nameLabel.tag = 99;
    
    CGFloat btnX = 20;
    CGFloat btnY = screenSize.height - 100;
    CGFloat btnW = screenSize.width /5 * 3 - 20 * 2;
    CGFloat btnH = 40;
    self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
    [self.loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [self.loginButton setBackgroundColor:UIColorFromRGB(0xB4EEB4)];
    [self.loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchDown];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([Config getLoginUserId]) {
        return 3;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    switch (indexPath.row) {
        case 0:{
            cell.highlighted = NO;
            for (UIView *v in cell.contentView.subviews){
                [v removeFromSuperview];
            }
            [cell.contentView addSubview:self.headView];
            [cell.contentView addSubview:self.nameLabel];

            if ([Config getLoginUserId]) {
                User *user = [Config loadUser];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHead:)];
                [self.headView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"place_hold_image.png"]];
                [self.headView addGestureRecognizer:tap];
                self.headView.userInteractionEnabled = YES;
                self.nameLabel.text = user.name;
            }else{
                self.headView.image = [UIImage imageNamed:@"place_hold_image.png"];
                self.nameLabel.text = @"登陆一下吧!";
                [cell.contentView addSubview:self.loginButton];
            }
        }
            break;
        case 1:{
            cell.textLabel.text = @"设置";
        }
            break;
        case 2:{
            cell.textLabel.text = @"关于我";
        }
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    switch (indexPath.row) {
        case 0:
            if ([Config getLoginUserId]) {
                return screenSize.height - 2 * 40;
            }else{
                return screenSize.height - 40;
            }
            break;
        default:
            return 40;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 2) {
        NSNotificationCenter *nc =[NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"push_AboutMe" object:nil];
    }
    if (indexPath.row == 1) {
        NSNotificationCenter *nc =[NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"push_Setting" object:nil];
    }
    
}


- (void)tapHead:(UITapGestureRecognizer *)sender{
    [FullScreenLargeImageShowUtils showImage:self.headView large_image_url:[Config loadUser].large_avatar];
}

- (void)login:(UIButton *)sender{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"push_left" object:nil];
    
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
