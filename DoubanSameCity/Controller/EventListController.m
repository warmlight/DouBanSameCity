//
//  EventListController.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/17.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "EventListController.h"

@interface EventListController ()

@end

@implementation EventListController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"access token :%@", [Config loadAccount].access_token);
    NSLog(@"user id:%@", [Config getLoginUserId]);
    NSLog(@"user largeAvatar :%@", [Config loadUser].large_avatar);
    
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0xFFAEB9);
    self.navigationController.navigationBar.alpha = 0.3;
    
    self.view.backgroundColor = [UIColor blackColor];
    self.eventsArray = [[NSMutableArray alloc] init];
    [self initUI];
    
    self.type = All;
    self.day_type = Future;
    self.locName = [[NSMutableString alloc] init];
    
    [self.locName appendString:@"shanghai"];

    
//    [self initLocationManager];
    
    
    //table下拉刷新
    __weak typeof(self) weakSelf = self;
    [self.tabelView addLegendHeaderWithRefreshingBlock:^{
        dispatch_queue_t queueToDown =  dispatch_queue_create("myqueue", NULL);
        dispatch_async(queueToDown, ^{
            [weakSelf latestEvent:weakSelf.locName type:weakSelf.type day_type:weakSelf.day_type];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [weakSelf afterRefresh];
            });
        });
    }];
    //table上拉刷新
    [self.tabelView addLegendFooterWithRefreshingBlock:^{
        dispatch_queue_t queueToUp =  dispatch_queue_create("myqueue", NULL);
        dispatch_async(queueToUp, ^{
            [weakSelf getMoreEvent:weakSelf.locName type:weakSelf.type day_type:weakSelf.day_type];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [weakSelf afterRefresh];
            });
        });
    }];
    
    //接收消息
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(receivedNotificaion:) name:@"push_left" object:nil];
    [nc addObserver:self selector:@selector(receivedNotificaion_pushAboutMe:) name:@"push_AboutMe" object:nil];
    [nc addObserver:self selector:@selector(receivedNotificaion_pushSetting:) name:@"push_Setting" object:nil];

    
}

- (void)receivedNotificaion:(NSNotification *)nofiticaiton{
    OAutoController *oauto = [[OAutoController alloc] init];
    [self presentViewController:oauto animated:NO completion:nil];
    [self.sideMenuViewController hideMenuViewController];
}

- (void)receivedNotificaion_pushAboutMe:(NSNotification *)nofiticaiton{
    AboutMeController *aboutMe = [[AboutMeController alloc] init];
    [self.navigationController pushViewController:aboutMe animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

- (void)receivedNotificaion_pushSetting:(NSNotification *)nofiticaiton{
    SettingController *setting = [[SettingController alloc] init];
    [self.navigationController pushViewController:setting animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

- (void)fristTimeReload{
    //显示页面的时候异步加载
    dispatch_queue_t queue =  dispatch_queue_create("myqueue", NULL);
    dispatch_async(queue, ^{
        [self latestEvent:self.locName type:self.type day_type:self.day_type];
        dispatch_sync(dispatch_get_main_queue(), ^{
            //首次得到数据隐藏等待界面
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self afterRefresh];
        });
    });

}

#pragma mark location
- (void)initLocationManager{
     //开始定位时给予等待页面
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"努力加载中";                    // 设置文字
    hud.labelFont = [UIFont systemFontOfSize:14];

    if([CLLocationManager locationServicesEnabled]){
        [[[[Toast makeText:@"正在定位"] setGravity:ToastGravityBottom] setDuration:ToastDurationShort] show];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 300;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [self.locationManager requestWhenInUseAuthorization];//ios8要添加 还要在plist里添加
    }
        [self.locationManager startUpdatingLocation];
    }else{
        [[[[Toast makeText:@"定位失败，请手动选择地址"] setGravity:ToastGravityBottom] setDuration:ToastDurationShort] show];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder  reverseGeocodeLocation:currentLocation completionHandler:^(NSArray
                                                                          *placemarks, NSError *error) {
        for (CLPlacemark *place in placemarks)
        {
            NSRange range = [place.locality rangeOfString:@"市"];
            NSString *loc = [[place.locality substringToIndex:range.location] transformToPinyin];
            NSArray *array = [loc componentsSeparatedByString:@" "];
            //只执行一次
            static dispatch_once_t predicate; dispatch_once(&predicate, ^{
            
                for (int i = 0; i < array.count; i ++) {
                    [self.locName appendString:array[i]];
                }
                [manager stopUpdatingLocation];
                [self fristTimeReload];
            });
        }
    }];
  
}

- (void)initUI{
    UIImageView *image = [[UIImageView alloc] initWithFrame:self.view.frame];
    image.image = [UIImage imageNamed:@"bkg.png"];
    
    CGFloat tableX = 0;
    CGFloat tableY = 0;
    CGFloat tableW = self.view.frame.size.width;
    CGFloat tableH = self.view.frame.size.height;
    self.tabelView = [[UITableView alloc] initWithFrame:CGRectMake(tableX, tableY, tableW, tableH)];
    self.tabelView.delegate = self;
    self.tabelView.dataSource = self;
    self.tabelView.backgroundView = image;
   
//    self.tabelView.backgroundColor = UIColorFromRGB(0xEEEF98);
    [self.view addSubview:self.tabelView];
    [self.tabelView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];//隐藏没有内容的cell的分割线
}

#pragma mark getEvent
- (void)latestEvent:(NSString *)loc type:(NSString *)type day_type:(NSString *)day_type{
        self.page = 0;
//        [self.eventsArray removeAllObjects];
        EventList *eventlist = [API get_eventlist:[NSNumber numberWithInt:10] star:[NSNumber numberWithInt:self.page] loc:loc type:type day_type:day_type];
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[eventlist.events mutableCopy]];
        NSMutableArray *events = [SameCityUtils get_eventArray:array];
        [self.eventsArray insertObjects:events atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, events.count)]];
        if (self.eventsArray.count > Count) {
            [self.eventsArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(events.count + 1, events.count - 1)]];
        }
        self.totalEvent = eventlist.total;
        self.page ++;
}

- (void)getMoreEvent:(NSString *)loc type:(NSString *)type day_type:(NSString *)day_type{
    int starPage = self.page *Count;
    EventList *eventlist = [API get_eventlist:[NSNumber numberWithInt:10] star:[NSNumber numberWithInt:starPage] loc:loc type:type day_type:day_type];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[eventlist.events mutableCopy]];
    NSMutableArray *events = [SameCityUtils get_eventArray:array];
    [self.eventsArray insertObjects:events atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(starPage, events.count)]];
    self.page ++;
}

- (void)afterRefresh{
    [self.tabelView reloadData];
    if ([self.tabelView.header isRefreshing]) {
        [self.tabelView.header endRefreshing];
        [[[Toast makeText:[NSString stringWithFormat:@"一共找到%@个活动", self.totalEvent]] setGravity:ToastGravityBottom] show];
    }else if ([self.tabelView.footer isRefreshing]){
        [self.tabelView.footer endRefreshing];
    }
}

#pragma mark -tableview delegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.eventsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[EventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.tag = indexPath.row + 100;
    Event *event = self.eventsArray[indexPath.row];
    cell.singleEvent = event;
    cell.titleLabel.text = [NSString stringWithFormat:@" %@", event.title];
    cell.bengin_event_time_Label.text = event.begin_time;
    cell.end_event_time_Label.text = event.end_time;
    cell.eventTypeLabel.text = event.category_name;
    cell.eventAdressLabel.text = event.address;
    cell.wish_count_Label.text = [NSString stringWithFormat:@"%@", event.wisher_count];
    cell.participant_count_label.text = [NSString stringWithFormat:@"%@", event.participant_count];
    [cell.eventImage sd_setImageWithURL:[NSURL URLWithString:event.image] placeholderImage:[UIImage imageNamed:@"place_hold_image.png"]];
    [cell createFrame];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Event *event = self.eventsArray[indexPath.row];
    return [EventCell cellHeight:event];
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    //去除有内容的Cell分割线
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
    //点击时背景色
    UIColor *color = UIColorFromRGB(0xEAEAEA);//通过RGB来定义自己的颜色
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = color;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EventCell *cell = (EventCell *)[tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    EventDetailController *detailCon = [[EventDetailController alloc] init];
    [detailCon initUI:cell.singleEvent];
    [self.navigationController pushViewController:detailCon animated:YES];
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
