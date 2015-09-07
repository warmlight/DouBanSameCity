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
@property (strong, nonatomic) UIView *headView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *leftBtn;
@end

@implementation EventDetailController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.titleLabel.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSheetView:) name:@"showSheetView" object:nil];
    // Do any additional setup after loading the view.
}

- (void)showSheetView:(NSNotification *)notification {
    UIAlertController *sheetController = notification.object;
    [self presentViewController:sheetController animated:YES completion:nil];
}

- (void)initUI:(Event *)event{
    self.event = event;
    self.scrollerView = [[EventDetailScrollerVIew alloc] init];
    self.scrollerView.delegate = self;
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
    
    //模拟一个navigationbar
    CGRect headFrame = CGRectMake(0, 0, self.view.frame.size.width, 64);
    self.headView = [[UIView alloc] initWithFrame:headFrame];
    self.headView.alpha = 0;
    self.headView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.headView];
    
    self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.titleLabel.textColor=[UIColor blackColor];
    self.titleLabel.text = @"活动详情";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = self.titleLabel;
    self.navigationItem.titleView.alpha = 0;
    
    self.leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [self.leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    self.leftBtn.hidden = YES;
}

- (void)leftBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

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


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.titleLabel.hidden = NO;
    self.leftBtn.hidden = NO;
    CGFloat yOffset  = scrollView.contentOffset.y;
//    CGFloat xOffset = (yOffset + 300)/2;
//
//    if (yOffset < -364) {
//
//        CGRect rect = self.scrollerView.effectView.frame;
//        rect.origin.y = yOffset;
//        rect.size.height =  -yOffset ;
//        rect.origin.x = xOffset;
//        rect.size.width = self.view.frame.size.width + fabs(xOffset)*2;
//
//        self.scrollerView.effectView.frame = rect;
//    }
//    
//    
    CGFloat alpha = yOffset / 300;
//    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[[UIColor orangeColor]colorWithAlphaComponent:alpha]] forBarMetrics:UIBarMetricsDefault];
    self.headView.alpha = alpha;
    self.titleLabel.alpha = alpha;
    self.leftBtn.alpha = alpha;
    alpha=fabs(alpha);
    alpha=fabs(1-alpha);
    
    alpha=alpha<0.2? 0:alpha-0.2;

}

- (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();

    return theImage;
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
