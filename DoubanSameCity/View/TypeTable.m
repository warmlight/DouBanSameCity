//
//  StyleTable.m
//  DoubanSameCity
//
//  Created by yiban on 15/8/21.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "TypeTable.h"

@implementation TypeTable
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.types = [[NSMutableArray alloc] init];
        self.separatorStyle = UITableViewCellSelectionStyleNone;
        self.scrollEnabled = NO;
        [self.types addObject:@"所有类型"];
        [self.types addObject:@"音乐"];
        [self.types addObject:@"话剧"];
        [self.types addObject:@"展览"];
        [self.types addObject:@"讲座"];
        [self.types addObject:@"聚会"];
        [self.types addObject:@"运动"];
        [self.types addObject:@"旅行"];
        [self.types addObject:@"公益"];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.types.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    cell.textLabel.text = self.types[indexPath.row];
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
    if ([cell.textLabel.text isEqualToString:@"所有类型"]) {
        selectedType = All;
    }else if ([cell.textLabel.text isEqualToString:@"音乐"]){
        selectedType = Music;
    }else if ([cell.textLabel.text isEqualToString:@"话剧"]){
        selectedType = XiJu;
    }else if ([cell.textLabel.text isEqualToString:@"展览"]){
        selectedType = ZhanLan;
    }else if ([cell.textLabel.text isEqualToString:@"讲座"]){
        selectedType = JiangZuo;
    }else if ([cell.textLabel.text isEqualToString:@"聚会"]){
        selectedType = JuHui;
    }else if ([cell.textLabel.text isEqualToString:@"运动"]){
        selectedType = YunDong;
    }else if ([cell.textLabel.text isEqualToString:@"旅行"]){
        selectedType = LuXing;
    }else if ([cell.textLabel.text isEqualToString:@"公益"]){
        selectedType = GongYi;
    }
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"type" object:selectedType];
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

@end
