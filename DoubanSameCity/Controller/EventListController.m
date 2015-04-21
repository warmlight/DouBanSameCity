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
    self.title = @"活动";
    self.view.backgroundColor = [UIColor redColor];
    self.eventsArray = [[NSMutableArray alloc] init];
    [self initUI];
    
    //显示页面的时候异步加载 并给予等待页面
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"努力加载中";                    // 设置文字
    hud.labelFont = [UIFont systemFontOfSize:14];
    dispatch_queue_t queue =  dispatch_queue_create("myqueue", NULL);
    dispatch_async(queue, ^{
         [self latestEvent:@"shanghai" type:@"all" day_type:@"future"];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self afterRefresh];
        });
    });
    
    //table下拉刷新
    __weak typeof(self) weakSelf = self;
    [self.tabelView addLegendHeaderWithRefreshingBlock:^{
        dispatch_queue_t queueToDown =  dispatch_queue_create("myqueue", NULL);
        dispatch_async(queueToDown, ^{
            [weakSelf latestEvent:@"shanghai" type:@"all" day_type:@"future"];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [weakSelf afterRefresh];
            });
        });
    }];
    //table上拉刷新
    [self.tabelView addLegendFooterWithRefreshingBlock:^{
        dispatch_queue_t queueToUp =  dispatch_queue_create("myqueue", NULL);
        dispatch_async(queueToUp, ^{
            [weakSelf getMoreEvent:@"shanghai" type:@"all" day_type:@"future"];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [weakSelf afterRefresh];
            });
        });

    }];
    
    [self initLocationManager];
    
//    LocationUtils *location = [[LocationUtils alloc] init:Get_Place];
//    CLPlacemark *mark = [location getPlaceInfomation];
////    mark.location;
//    NSLog(@"%@", mark.locality);
    
//    LocationUtils *location = [[LocationUtils alloc] init];
//    [location initLocationManager];
    
    // Do any additional setup after loading the view.
}


- (void)initLocationManager{
        if([CLLocationManager locationServicesEnabled]){
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 300;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            [self.locationManager requestWhenInUseAuthorization];//ios8要添加 还要在plist里添加
        }
            [self.locationManager startUpdatingLocation];
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
           NSLog(@"name,%@",place.name);
            NSLog(@"thoroughfare,%@",place.thoroughfare);
            NSLog(@"subThoroughfare,%@",place.subThoroughfare);
            NSLog(@"locality,%@",place.locality);
            NSLog(@"subLocality,%@",place.subLocality);
            NSLog(@"country,%@",place.country);
            [manager stopUpdatingLocation];
        }
    }];
  
}



- (void)initUI{
    //没有效果
    UIImage * img = [UIImage imageNamed:@"menu"];
    UIBarButtonItem * menuButton = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    CGFloat tableX = 0;
    CGFloat tableY = 0;
    CGFloat tableW = self.view.frame.size.width;
    CGFloat tableH = self.view.frame.size.height - 64;
    self.tabelView = [[UITableView alloc] initWithFrame:CGRectMake(tableX, tableY, tableW, tableH)];
    self.tabelView.delegate = self;
    self.tabelView.dataSource = self;
    [self.view addSubview:self.tabelView];
    [self.tabelView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];//隐藏没有内容的cell的分割线
}

- (void)latestEvent:(NSString *)loc type:(NSString *)type day_type:(NSString *)day_type{
    self.page = 0;
    [self.eventsArray removeAllObjects];
    EventList *eventlist = [API get_eventlist:[NSNumber numberWithInt:10] star:[NSNumber numberWithInt:self.page] loc:loc type:type day_type:day_type];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[eventlist.events mutableCopy]];
    NSMutableArray *events = [SameCityUtils get_eventArray:array];
    [self.eventsArray insertObjects:events atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, events.count)]];
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
    cell.titleLabel.text = [NSString stringWithFormat:@" %@", event.title];
    cell.bengin_event_time_Label.text = event.begin_time;
    cell.end_event_time_Label.text = event.end_time;
    cell.eventTypeLabel.text = event.category_name;
    cell.eventAdressLabel.text = event.address;
    cell.wish_count_Label.text = [NSString stringWithFormat:@"%@", event.wisher_count];
    cell.participant_count_label.text = [NSString stringWithFormat:@"%@", event.participant_count];
    [cell.eventImage setImageWithURL:[NSURL URLWithString:event.image] placeholderImage:[UIImage imageNamed:@"bkg.png"]];
    [cell createFrame];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Event *event = self.eventsArray[indexPath.row];
    return [EventCell cellHeight:event];
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    UIColor *CellColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    cell.backgroundColor = CellColor;
    //去除有内容的Cell分割线
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
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
