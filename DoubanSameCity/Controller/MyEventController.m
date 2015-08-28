//
//  MyEventController.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/17.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "MyEventController.h"
#import "EventCell.h"
#import "MJRefresh.h"
#import "API.h"
#import <UIImageView+WebCache.h>
#import "SameCityUtils.h"
#import "EventDetailController.h"

#define Count 10
@interface MyEventController ()
@property (strong, nonatomic) UISegmentedControl *segment;
@property (strong, nonatomic) UITableView *wishTableView;
@property (strong, nonatomic) UITableView *participateTableView;
@property (strong, nonatomic) NSMutableArray *wishEvents;
@property (strong, nonatomic) NSMutableArray *participateEvents;
@property (assign, nonatomic) NSUInteger wishPage;
@property (assign, nonatomic) NSUInteger participatePage;
@end

@implementation MyEventController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的活动";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //segmentedControl
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect segmentRect = CGRectMake((screenSize.width - 200) / 2, 74, 200, 25);
    self.segment = [[UISegmentedControl alloc] initWithFrame:segmentRect];
    [self.segment insertSegmentWithTitle:@"我感兴趣的" atIndex:0 animated:NO];
    [self.segment insertSegmentWithTitle:@"我参加的" atIndex:1 animated:NO];
    self.segment.selected = YES;
    self.segment.selectedSegmentIndex = 0;
    //添加segmentedControler的点击事件
    [self.segment addTarget:self action:@selector(controlPressed:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segment];
    
    CGRect tableFrame = CGRectMake(0, 110, screenSize.width, screenSize.height - 110);
    self.wishTableView = [[UITableView alloc] initWithFrame:tableFrame];
    self.wishTableView.tag = 100;
    self.wishTableView.delegate = self;
    self.wishTableView.dataSource = self;
    [self.view addSubview:self.wishTableView];
    self.wishTableView.hidden = NO;
    
    self.participateTableView = [[UITableView alloc] initWithFrame:tableFrame];
    self.participateTableView.delegate = self;
    self.participateTableView.dataSource = self;
    [self.view addSubview:self.participateTableView];
    self.participateTableView.hidden = YES;
    
    //wish table下拉刷新
    __block __weak typeof(self) weakSelf = self;
    [self.wishTableView addLegendHeaderWithRefreshingBlock:^{
        dispatch_queue_t queueToDown =  dispatch_queue_create("myqueue", NULL);
        dispatch_async(queueToDown, ^{
            [weakSelf getWishEvents:[NSNumber numberWithInt:Count]];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [weakSelf.wishTableView reloadData];
                if ([weakSelf.wishTableView.header isRefreshing]) {
                    [weakSelf.wishTableView.header endRefreshing];
                }
            });
        });
    }];
    
    //table上拉刷新
    [self.wishTableView addLegendFooterWithRefreshingBlock:^{
        dispatch_queue_t queueToUp =  dispatch_queue_create("myqueue", NULL);
        dispatch_async(queueToUp, ^{
            [weakSelf getMoreWishEvents:[NSNumber numberWithInt:Count]];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [weakSelf.wishTableView reloadData];
                if ([weakSelf.wishTableView.footer isRefreshing]) {
                    [weakSelf.wishTableView.footer endRefreshing];
                }
            });
        });
    }];
    
    //participate table下拉刷新
    [self.participateTableView addLegendHeaderWithRefreshingBlock:^{
        dispatch_queue_t queueToDown =  dispatch_queue_create("myqueue", NULL);
        dispatch_async(queueToDown, ^{
            [weakSelf getParticipateEvents:[NSNumber numberWithInt:Count]];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [weakSelf.participateTableView reloadData];
                if ([weakSelf.participateTableView.header isRefreshing]) {
                    [weakSelf.participateTableView.header endRefreshing];
                }
            });
        });
    }];
    
    //table上拉刷新
    [self.participateTableView addLegendFooterWithRefreshingBlock:^{
        dispatch_queue_t queueToUp =  dispatch_queue_create("myqueue", NULL);
        dispatch_async(queueToUp, ^{
            [weakSelf getParticipateEvents:[NSNumber numberWithInt:Count]];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [weakSelf.participateTableView reloadData];
                if ([weakSelf.participateTableView.footer isRefreshing]) {
                    [weakSelf.participateTableView.footer endRefreshing];
                }
            });
        });
    }];
    
    //第一次进来时拉一遍数据
    dispatch_queue_t queueToDown =  dispatch_queue_create("myqueue", NULL);
    dispatch_async(queueToDown, ^{
        [weakSelf getWishEvents:[NSNumber numberWithInt:Count]];
        [weakSelf getParticipateEvents:[NSNumber numberWithInt:Count]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [weakSelf.wishTableView reloadData];
            [weakSelf.participateTableView reloadData];
            if ([weakSelf.wishTableView.header isRefreshing]) {
                [weakSelf.wishTableView.header endRefreshing];
            }
            if ([weakSelf.participateTableView.footer isRefreshing]) {
                [weakSelf.participateTableView.footer endRefreshing];
            }
        });
    });

    // Do any additional setup after loading the view.
}

#pragma mark -get wish event
- (void)getWishEvents:(NSNumber *)count {
    self.wishPage = 0;
    EventList *list = [API get_wishedEvent:count start:[NSNumber numberWithInt:0] status:@""];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[list.events mutableCopy]];
    NSMutableArray *events = [SameCityUtils get_eventArray:array];
    self.wishEvents = events;
    self.wishPage ++;
}

- (void)getMoreWishEvents:(NSNumber *)count {
    EventList *list = [API get_wishedEvent:count start:[NSNumber numberWithInt:(int)(Count * self.wishPage)] status:@""];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[list.events mutableCopy]];
    NSMutableArray *events = [SameCityUtils get_eventArray:array];
    if (events.count > 0) {
        [self.wishEvents insertObject:events atIndex:(NSUInteger)[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(Count *self.wishPage, events.count)]];
        self.wishPage++;
    }
}

#pragma mark -get participate event
- (void)getParticipateEvents:(NSNumber *)count {
    self.participatePage = 0;
    EventList *list = [API get_participateEvent:count start:[NSNumber numberWithInt:0] status:@""];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[list.events mutableCopy]];
    NSMutableArray *events = [SameCityUtils get_eventArray:array];
    self.participateEvents = events;
    self.participatePage ++;

}

- (void)getMoreParticipateEvents:(NSNumber *)count {
    EventList *list = [API get_participateEvent:count start:[NSNumber numberWithInt:(int)(Count * self.wishPage)] status:@""];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[list.events mutableCopy]];
    NSMutableArray *events = [SameCityUtils get_eventArray:array];
    if (events.count > 0) {
        [self.participateEvents insertObject:events atIndex:(NSUInteger)[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(Count *self.wishPage, events.count)]];
        self.participatePage++;
    }
}

#pragma mark -tableview delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        return self.wishEvents.count;
    }else {
        return self.participateEvents.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100) {
        static NSString *identifer = @"wish";
        EventCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (cell == nil) {
            cell = [[EventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        }
        Event *event = self.wishEvents[indexPath.row];
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
    }else {
        static NSString *identifer = @"participate";
        EventCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (cell == nil) {
            cell = [[EventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        }
        Event *event = self.participateEvents[indexPath.row];
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        Event *event = self.wishEvents[indexPath.row];
        return [EventCell cellHeight:event];
    }else {
        Event *event = self.participateEvents[indexPath.row];
        return [EventCell cellHeight:event];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EventCell *cell = (EventCell *)[tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    EventDetailController *detailCon = [[EventDetailController alloc] init];
    [detailCon initUI:cell.singleEvent];
    NSLog(@"%@",cell.singleEvent.id);
    [self.navigationController pushViewController:detailCon animated:YES];
    
}

//处理segmentController的点击
-(void)controlPressed:(id)sender{
    
    UISegmentedControl *control = (UISegmentedControl *)sender;
    if (control == self.segment) {
        int x = control.selectedSegmentIndex;
        switch (x) {
            case 0:
                self.participateTableView.hidden = YES;
                self.wishTableView.hidden = NO;
                break;
            case 1:
                self.wishTableView.hidden = YES;
                self.participateTableView.hidden = NO;
                break;
            default:
                break;
        }
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
