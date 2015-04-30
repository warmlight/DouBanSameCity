//
//  TimeTable.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/30.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "TimeTable.h"

@implementation TimeTable
- (instancetype)init{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.timeTypes = [[NSMutableArray alloc] init];
//        NSDictionary *future = [[NSDictionary alloc] initWithObjectsAndKeys:@"所有时间段",Future, nil];
//        NSDictionary *week = [[NSDictionary alloc] initWithObjectsAndKeys:@"最近一周",Week, nil];
//        NSDictionary *weekend = [[NSDictionary alloc] initWithObjectsAndKeys:@"周末",Weekend, nil];
//        NSDictionary *tomorrow = [[NSDictionary alloc] initWithObjectsAndKeys:@"明天",Tomorrow, nil];
//        NSDictionary *today = [[NSDictionary alloc] initWithObjectsAndKeys:@"今天",Today, nil];
        [self.timeTypes addObject:@"所有时间段"];
        [self.timeTypes addObject:@"最近一周"];
        [self.timeTypes addObject:@"周末"];
        [self.timeTypes addObject:@"明天"];
        [self.timeTypes addObject:@"今天"];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.timeTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    cell.textLabel.text = self.timeTypes[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *selectedType = @"";
    if ([cell.textLabel.text isEqualToString:@"所有时间段"]) {
       selectedType = Future;
    }else if ([cell.textLabel.text isEqualToString:@"最近一周"]){
        selectedType = Week;
    }else if ([cell.textLabel.text isEqualToString:@"周末"]){
        selectedType = Weekend;
    }else if ([cell.textLabel.text isEqualToString:@"明天"]){
        selectedType = Tomorrow;
    }else if ([cell.textLabel.text isEqualToString:@"今天"]){
        selectedType = Today;
    }
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"time_type" object:selectedType];
    [self removeFromSuperview];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
