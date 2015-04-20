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
    UIImage * img = [UIImage imageNamed:@"menu"];
    UIBarButtonItem * menuButton = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    EventList *eventlist = [API get_eventlist:nil star:nil loc:@"shanghai" type:nil day_type:nil];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[eventlist.events mutableCopy]];
    self.eventsArray = [SameCityUtils get_eventArray:array];
    NSLog(@"%@",[self.eventsArray[0] toString]);
    
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)initUI{
    CGFloat tableX = 0;
    CGFloat tableY = 0;
    CGFloat tableW = self.view.frame.size.width;
    CGFloat tableH = self.view.frame.size.height - 64;
    self.tabelView = [[UITableView alloc] initWithFrame:CGRectMake(tableX, tableY, tableW, tableH)];
    self.tabelView.delegate = self;
    self.tabelView.dataSource = self;
    [self.view addSubview:self.tabelView];
}

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
    cell.titleLabel.text = event.title;
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
