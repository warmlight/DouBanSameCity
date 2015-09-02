//
//  EventListController.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/17.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "EventListController.h"
#import "SelectPopoverController.h"
#import "UIScrollView+MJRefresh.h"
#import "MJRefresh.h"
#import "ResponseCode.h"
#import "ShareEvent.h"

@interface EventListController ()
@property (strong, nonatomic) SelectPopoverController *popoverVC;
@property (strong, nonatomic) NSMutableArray *wishEvents;
@property (strong, nonatomic) NSMutableArray *participateEvents;
@property (assign, nonatomic) NSUInteger wishPage;
@property (assign, nonatomic) NSUInteger participatePage;
@property (assign, nonatomic) BOOL wishHasNext;         //是否还可以继续请求更多
@property (assign, nonatomic) BOOL participateHasNext;  //是否还可以继续请求更多

@end

@implementation EventListController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"access token :%@", [Config loadAccount].access_token);
    NSLog(@"user id:%@", [Config getLoginUserId]);
    NSLog(@"user largeAvatar :%@", [Config loadUser].large_avatar);

//    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0xFFAEB9);
//    self.navigationController.navigationBar.alpha = 0.3;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"add.png"] forBarMetrics:UIBarMetricsCompact];//图片可随便设置？？
    self.automaticallyAdjustsScrollViewInsets = NO; //让view的y从0开始而不是从64开始
    
    //消除黑线
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list = self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView = (UIImageView *)obj;
                imageView.hidden = YES;
            }
        }
    }
    self.view.backgroundColor = [UIColor blackColor];
    self.eventsArray = [[NSMutableArray alloc] init];
    self.wishPage = 0;
    self.wishHasNext = YES;
    self.participateHasNext = YES;
    [self initUI];
    
    //默认的请求类型、请求时间
    self.type = All;
    self.day_type = Future;
    self.locName = [[NSMutableString alloc] init];
    
    [self.locName appendString:@"shanghai"];
    
    
//    [self initLocationManager];
    
    
    //table下拉刷新
    __block __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        dispatch_queue_t queueToDown =  dispatch_queue_create("myqueue", NULL);
        dispatch_async(queueToDown, ^{
            weakSelf.wishHasNext = YES;
            weakSelf.participateHasNext = YES;
            [weakSelf.wishEvents removeAllObjects];
            [weakSelf.participateEvents removeAllObjects];
            while (weakSelf.wishHasNext) {
                [weakSelf getWishEvent:[NSNumber numberWithInt:Count]];
            }
            while (weakSelf.participateHasNext) {
                [weakSelf getParticipateEvents:[NSNumber numberWithInt:Count]];
            }
            [weakSelf latestEvent:weakSelf.locName type:weakSelf.type day_type:weakSelf.day_type];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [weakSelf afterRefresh];
            });
        });
    }];
    
    //table上拉刷新
    [self.tableView addLegendFooterWithRefreshingBlock:^{
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
    [nc addObserver:self selector:@selector(receivedNotification_timeType:) name:@"time_type" object:nil];
    [nc addObserver:self selector:@selector(receivedNotification_type:) name:@"type" object:nil];
    [nc addObserver:self selector:@selector(receivedNotification_login:) name:@"push_reloadData" object:nil];
    [nc addObserver:self selector:@selector(receivedNotification_addWishEvent:) name:@"addWishEvent" object:nil];
    [nc addObserver:self selector:@selector(receivedNotification_deleteWishEvent:) name:@"deleteWishEvent" object:nil];
    [nc addObserver:self selector:@selector(receivedNotification_addParticipateEvent:) name:@"addParticipateEvent" object:nil];
    [nc addObserver:self selector:@selector(receivedNotification_deleteParticipateEvent:) name:@"deleteParticipateEvent" object:nil];

}

#pragma mark -notification
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

- (void)receivedNotification_timeType:(NSNotification *)notification{
    self.day_type = notification.object;
    NSString *buttonTitle;
    //选择时间段后，按钮上的字相应改变
    if ([self.day_type isEqualToString:Future]) {
        buttonTitle = @"所有时间段";
    }else if ([self.day_type isEqualToString:Week]){
        buttonTitle = @"最近一周";
    }else if ([self.day_type isEqualToString:Weekend]){
        buttonTitle = @"周末";
    }else if ([self.day_type isEqualToString:Tomorrow]){
        buttonTitle = @"明天";
    }else if ([self.day_type isEqualToString:Today]){
        buttonTitle = @"今天";
    }
    [self.day_typeButton setTitle:buttonTitle forState:UIControlStateNormal];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"努力加载中";                    // 设置文字
    hud.labelFont = [UIFont systemFontOfSize:14];
    [self fristTimeReload];
    [self.popoverVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)receivedNotification_type:(NSNotification *)notification {
    self.type = notification.object;
    NSString *selectedType;
    //选择时间段后，按钮上的字相应改变
    if ([self.type isEqualToString:All]) {
        selectedType = @"所有类型";
    }else if ([self.type isEqualToString:Music]){
        selectedType = @"音乐";
    }else if ([self.type isEqualToString:XiJu]){
        selectedType = @"话剧";
    }else if ([self.type isEqualToString:ZhanLan]){
        selectedType = @"展览";
    }else if ([self.type isEqualToString:JiangZuo]){
        selectedType = @"讲座";
    }else if ([self.type isEqualToString:JuHui]){
        selectedType = @"聚会";
    }else if ([self.type isEqualToString:YunDong]){
        selectedType = @"运动";
    }else if ([self.type isEqualToString:LuXing]){
        selectedType = @"旅行";
    }else if ([self.type isEqualToString:GongYi]){
        selectedType = @"公益";
    }
    [self.type_Button setTitle:selectedType forState:UIControlStateNormal];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"努力加载中";                    // 设置文字
    hud.labelFont = [UIFont systemFontOfSize:14];
    [self fristTimeReload];
    [self.popoverVC dismissViewControllerAnimated:YES completion:nil];
}

//通过消息传递来添加、删除感兴趣或者参加的活动，而不是通过再一次的网络请求。
- (void)receivedNotification_addWishEvent:(NSNotification *)notification {
    Event *event = notification.object;
    ShareEvent *shareEvent = [ShareEvent sharedInstance];
    [shareEvent.wishArray addObject:event];
//    [self.wishEvents addObject:event];
}

- (void)receivedNotification_addParticipateEvent:(NSNotification *)notification {
    Event *event = notification.object;
    ShareEvent *shareEvent = [ShareEvent sharedInstance];
    [shareEvent.joinArray addObject:event];
//    [self.participateEvents addObject:event];
}

- (void)receivedNotification_deleteWishEvent:(NSNotification *)notification {
    Event *event = notification.object;
    ShareEvent *shareEvent = [ShareEvent sharedInstance];
    
    for (int i = 0; i < shareEvent.wishArray.count; i++) {
        Event *e = shareEvent.wishArray[i];
        if ([e.id isEqualToString:event.id]) {
            [shareEvent.wishArray removeObject:e];
            break;
        }
    }
    
//    for (int i = 0; i < self.wishEvents.count; i++) {
//        Event *e = self.wishEvents[i];
//        if (e.id == event.id) {
//            [self.wishEvents removeObject:e];
//            break;
//        }
//    }
}

- (void)receivedNotification_deleteParticipateEvent:(NSNotification *)notification {
    Event *event = notification.object;
    ShareEvent *shareEvent = [ShareEvent sharedInstance];
    
    for (int i = 0; i < shareEvent.joinArray.count; i++) {
        Event *e = shareEvent.joinArray[i];
        if ([e.id isEqualToString:event.id]) {
            [shareEvent.joinArray removeObject:e];
            break;
        }
    }
    
//    for (int i = 0; i < self.participateEvents.count; i++) {
//        Event *e = self.participateEvents[i];
//        if (e.id == event.id) {
//            [self.participateEvents removeObject:e];
//            break;
//        }
//    }
}
//登陆后要重新拉一遍感兴趣的数据
- (void)receivedNotification_login:(NSNotification *)notification {
    self.wishHasNext = YES;
    self.participateHasNext = YES;
//    [self.wishEvents removeAllObjects];
//    [self.participateEvents removeAllObjects];
    ShareEvent *shareEvent = [ShareEvent sharedInstance];
    [shareEvent.joinArray removeAllObjects];
    [shareEvent.wishArray removeAllObjects];
    while (self.wishHasNext) {
        [self getWishEvent:[NSNumber numberWithInt:Count]];
    }
    while (self.participateHasNext) {
        [self getParticipateEvents:[NSNumber numberWithInt:Count]];
    }
}

- (void)fristTimeReload{
    //显示页面的时候异步加载
    __block __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue =  dispatch_queue_create("myqueue", NULL);
    dispatch_async(queue, ^{
        [weakSelf latestEvent:self.locName type:self.type day_type:self.day_type];
        while (weakSelf.wishHasNext) {
            [weakSelf getWishEvent:[NSNumber numberWithInt:Count]];
        }
        while (weakSelf.participateHasNext) {
            [weakSelf getParticipateEvents:[NSNumber numberWithInt:Count]];
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            //首次得到数据隐藏等待界面
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [weakSelf afterRefresh];
        });
    });
}

#pragma mark -get wish event
- (void) getWishEvent:(NSNumber *)count {
    EventList *list = [API get_wishedEvent:count start:[NSNumber numberWithInt:(int)self.wishPage *Count] status:@"ongoing"];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[list.events mutableCopy]];
    NSMutableArray *events = [SameCityUtils get_eventArray:array];
    ShareEvent *shareEvent = [ShareEvent sharedInstance];
    shareEvent.wishArray = events;
//    self.wishEvents = events;
    if (events.count >= 10) {
        self.wishPage ++;
    }else {
        self.wishHasNext = NO;
    }
}

#pragma mark -get participate event
- (void)getParticipateEvents:(NSNumber *)count {
    EventList *list = [API get_participateEvent:count start:[NSNumber numberWithInt:(int)self.wishPage *Count] status:@"ongoing"];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[list.events mutableCopy]];
    NSMutableArray *events = [SameCityUtils get_eventArray:array];
    ShareEvent *shareEvent = [ShareEvent sharedInstance];
    shareEvent.joinArray = events;
//    self.participateEvents = events;
    if (events.count >= 10) {
        self.participatePage ++;
    }else {
        self.participateHasNext = NO;
    }

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
    [geocoder  reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
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


#pragma mark -init
- (void)initUI{
    
    //navigationbar事实上是透明的 所以手动模拟创建一个不透明的
    UIVisualEffectView  *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    effectView.frame = headView.frame;
    [headView addSubview:effectView];
    
    //button顶部的分割线
    CGRect topLineFrame = CGRectMake(0, 63, self.view.frame.size.width, 0.5);
    UIView *topLine = [[UIView alloc] initWithFrame:topLineFrame];
    topLine.backgroundColor = [UIColor lightGrayColor];
    [effectView addSubview:topLine];
    
    //daybutton
    CGFloat dayBtnW = self.view.frame.size.width / 2;
    CGFloat dayBtnH = ButtonH;
    self.day_typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.day_typeButton setTitle:@"选择时间" forState:UIControlStateNormal];
    self.day_typeButton.backgroundColor = [UIColor clearColor];
    [self.day_typeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.day_typeButton.frame = CGRectMake(0, 0, dayBtnW, dayBtnH);
    self.day_typeButton.tag = 100;
    [self.day_typeButton addTarget:self action:@selector(showDayTypeTable:) forControlEvents:UIControlEventTouchUpInside];
    
    //两个button中间的分割线
    CGRect lineFrame = CGRectMake(self.day_typeButton.frame.size.width - 1, 4, 0.5, ButtonH - 8);
    UIView *lineView = [[UIView alloc] initWithFrame:lineFrame];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.day_typeButton addSubview:lineView];

    
    //typeButton
    self.type_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.type_Button setTitle:@"活动类型" forState:UIControlStateNormal];
    self.type_Button.backgroundColor = [UIColor clearColor];
    [self.type_Button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.type_Button.frame = CGRectMake(0, 0, dayBtnW, dayBtnH);
    self.type_Button.tag = 101;
    [self.type_Button addTarget:self action:@selector(showDayTypeTable:) forControlEvents:UIControlEventTouchUpInside];

    
    //daybuttonBkg
    CGFloat dayBtnX = 0;
    CGFloat dayBtnY = 64;
    UIVisualEffectView  *dayButtonBkg = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    dayButtonBkg.frame = CGRectMake(dayBtnX, dayBtnY, dayBtnW, dayBtnH);
    [dayButtonBkg addSubview:self.day_typeButton];
    
    UIVisualEffectView  *typeButtonBkg = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    typeButtonBkg.frame = CGRectMake(dayBtnW, dayBtnY, dayBtnW, dayBtnH);
    [typeButtonBkg addSubview:self.type_Button];
    
    
    //tableView
    UIImageView *image = [[UIImageView alloc] initWithFrame:self.view.frame];
    image.image = [UIImage imageNamed:@"bkg.png"];
    
    CGFloat tableX = 0;
    CGFloat tableY = 40;
    CGFloat tableW = self.view.frame.size.width;
    CGFloat tableH = self.view.frame.size.height - 40;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(tableX, tableY, tableW, tableH)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = image;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];//隐藏没有内容的cell的分割线
    //    self.tableView.backgroundColor = UIColorFromRGB(0xEEEF98);
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:headView];
    [self.view addSubview:dayButtonBkg];
    [self.view addSubview:typeButtonBkg];
    
}

#pragma mark -show/remove timetable
- (void)showDayTypeTable:(UIButton *)sender{
    self.popoverVC = [[SelectPopoverController alloc] init];
    self.popoverVC.modalPresentationStyle = UIModalPresentationPopover;
    if (sender.tag == 100) {
        self.popoverVC.whitchTable = 1;
        self.popoverVC.popoverPresentationController.sourceView = self.day_typeButton;
        self.popoverVC.popoverPresentationController.sourceRect = self.day_typeButton.bounds;
    }else if (sender.tag == 101) {
        self.popoverVC.whitchTable = 2;
        self.popoverVC.popoverPresentationController.sourceView = self.type_Button;
        self.popoverVC.popoverPresentationController.sourceRect = self.type_Button.bounds;
    }

    self.popoverVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    self.popoverVC.popoverPresentationController.delegate = self;
    self.popoverVC.popoverPresentationController.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.7];
    [self presentViewController:self.popoverVC animated:YES completion:nil];
}

#pragma mark getEvent
- (void)latestEvent:(NSString *)loc type:(NSString *)type day_type:(NSString *)day_type{
    self.page = 0;
    EventList *eventlist = [API get_eventlist:[NSNumber numberWithInt:Count] star:[NSNumber numberWithInt:self.page] loc:loc type:type day_type:day_type];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[eventlist.events mutableCopy]];
    NSMutableArray *events = [SameCityUtils get_eventArray:array];
    if (self.eventsArray.count >= 10) {
        [self.eventsArray removeAllObjects];
    }
    [self.eventsArray addObjectsFromArray:events];
    self.totalEvent = eventlist.total;
    self.page ++;
}

- (void)getMoreEvent:(NSString *)loc type:(NSString *)type day_type:(NSString *)day_type{
    int starPage = self.page *Count;
    EventList *eventlist = [API get_eventlist:[NSNumber numberWithInt:Count] star:[NSNumber numberWithInt:starPage] loc:loc type:type day_type:day_type];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[eventlist.events mutableCopy]];
    NSMutableArray *events = [SameCityUtils get_eventArray:array];
    [self.eventsArray insertObjects:events atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(starPage, events.count)]];
    self.page ++;
}

- (void)afterRefresh{
    [self.tableView reloadData];
    if ([self.tableView.header isRefreshing]) {
        [self.tableView.header endRefreshing];
        [[[Toast makeText:[NSString stringWithFormat:@"一共找到%@个活动", self.totalEvent]] setGravity:ToastGravityBottom] show];
    }else if ([self.tableView.footer isRefreshing]){
        [self.tableView.footer endRefreshing];
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

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath {
    //去除有内容的Cell分割线
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
    //点击时背景色
    UIColor *color = UIColorFromRGB(0xEAEAEA);//通过RGB来定义自己的颜色
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = color;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EventDetailController *detailCon = [[EventDetailController alloc] init];
    EventCell *cell = (EventCell *)[tableView cellForRowAtIndexPath:indexPath];
       [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [detailCon initUI:cell.singleEvent];
   
    ShareEvent *shareEvent = [ShareEvent sharedInstance];
    
    for (int i = 0; i < shareEvent.wishArray.count; i ++) {
        Event *event = shareEvent.wishArray[i];
        if ([cell.singleEvent.id isEqualToString:event.id]) {
            detailCon.scrollerView.wishButton.selected = YES;
        }
    }
    for (int i = 0; i < shareEvent.joinArray.count; i ++) {
        Event *event = shareEvent.joinArray[i];
        if ([cell.singleEvent.id isEqualToString:event.id]) {
            detailCon.scrollerView.joinButton.selected = YES;
        }
    }

//    for (int i = 0; i < self.wishEvents.count; i ++) {
//        Event *event = self.wishEvents[i];
//        if ([cell.singleEvent.id isEqualToString:event.id]) {
//            detailCon.scrollerView.wishButton.selected = YES;
//        }
//    }
//    for (int i = 0; i < self.participateEvents.count; i ++) {
//        Event *event = self.participateEvents[i];
//        if ([cell.singleEvent.id isEqualToString:event.id]) {
//            detailCon.scrollerView.joinButton.selected = YES;
//        }
//    }
    NSLog(@"%@",cell.singleEvent.id);
    [self.navigationController pushViewController:detailCon animated:YES];
}

#pragma mark -UIPopoverPresentationControllerDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controlle {
    return UIModalPresentationNone;
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
