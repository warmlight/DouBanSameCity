//
//  EventDetailController.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/22.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "EventDetailController.h"
#import "API.h"


@interface EventDetailController ()

@end

@implementation EventDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.translucent = YES;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"table_bkg.png"] forBarMetrics:UIBarMetricsCompact];
    // Do any additional setup after loading the view.
}

- (void)initUI:(Event *)event{
    self.event = event;
    self.scrollerView = [[EventDetailScrollerVIew alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO; //让视图从{0， 0}开始显示 而不是从{0， 64}
    CGFloat contentSizeHeigth = [self.scrollerView setViewFrame_Content:event];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat scrollerX = 0;
    CGFloat scrollerY = 0;
    CGFloat scrollerW = screenWidth;
    CGFloat scrollerH = self.view.frame.size.height;
    self.scrollerView.frame = CGRectMake(scrollerX, scrollerY, scrollerW, scrollerH);
    self.scrollerView.contentSize = CGSizeMake(screenWidth, contentSizeHeigth);
    self.scrollerView.JoinWishdelegate = self;
    //    self.scrollerView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.scrollerView];
}
//@"wishAdd"
//@"wishDelete"
//@"joinAdd"
//@"joinDelete"

- (ResponseCode *)wish:(UIButton *)sender{
    UIButton *wishButton = sender;
    __block __weak ResponseCode *code;
    __block __weak typeof(self) weakSelf = self;
    if (wishButton.selected) {
        dispatch_queue_t queueToWish =  dispatch_queue_create("wishQueue", NULL);
        dispatch_async(queueToWish, ^{
            code = [API didNotWish:weakSelf.event.id];
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"deleteWishEvent" object:weakSelf.event];
            [nc postNotificationName:@"wishDelete" object:weakSelf.event];
            
        });
        return code;
    }else{
        dispatch_queue_t queueToDown =  dispatch_queue_create("wishQueue", NULL);
        dispatch_async(queueToDown, ^{
            code = [API wishEvent:weakSelf.event.id];
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"addWishEvent" object:weakSelf.event];
            [nc postNotificationName:@"deleteParticipateEvent" object:weakSelf.event];
            
            [nc postNotificationName:@"wishAdd" object:weakSelf.event];
            [nc postNotificationName:@"joinDelete" object:weakSelf.event];

        });
        return code;
    }
}

- (ResponseCode *)participate:(UIButton *)sender{
    UIButton *joinButton = sender;
    __block __weak ResponseCode *code;
    __block __weak typeof(self) weakSelf = self;
    if (joinButton.selected) {
        dispatch_queue_t queueToJoin = dispatch_queue_create("joinQueue", NULL);
        dispatch_async(queueToJoin, ^{
            code = [API didNotParticipate:weakSelf.event.id];
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"deleteParticipateEvent" object:weakSelf.event];
            [nc postNotificationName:@"joinDelete" object:weakSelf.event];

        });
        return code;
    }else{
        dispatch_queue_t queueToJoin = dispatch_queue_create("joinQueue", NULL);
        dispatch_async(queueToJoin, ^{
            code = [API participateEvent:weakSelf.event.id];
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"addParticipateEvent" object:weakSelf.event];
            [nc postNotificationName:@"deleteWishEvent" object:weakSelf.event];
            
            [nc postNotificationName:@"joinAdd" object:weakSelf.event];
            [nc postNotificationName:@"wishDelete" object:weakSelf.event];
            
        });
        return code;
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
