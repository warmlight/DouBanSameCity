//
//  TimeTable.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/30.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "TimeTable.h"

@implementation TimeTable
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.timeTypes = [[NSMutableArray alloc] init];
        self.separatorStyle = UITableViewCellSelectionStyleNone;
        self.scrollEnabled = NO;
        
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
    cell.textLabel.textColor = [UIColor lightGrayColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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


- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
//    //去除有内容的Cell分割线
//    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
    
    UIColor *CellColor = [UIColor clearColor];
    cell.backgroundColor = CellColor;
    //点击时背景色
//    UIColor *color = UIColorFromRGB(0xEAEAEA);//通过RGB来定义自己的颜色
//    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//    cell.selectedBackgroundView.backgroundColor = color;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
