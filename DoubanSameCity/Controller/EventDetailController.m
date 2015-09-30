//
//  EventDetailController.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/22.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "EventDetailController.h"
#import "API.h"
#import "Toast.h"
#import "Config.h"
#import "shareView.h"


@interface EventDetailController ()
@property (strong, nonatomic) UIView *headView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UIButton *rightBtn;
@property (strong, nonatomic) UIButton *senderButton;    //暂存被点击的参加、感兴趣按钮
@end

@implementation EventDetailController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.titleLabel.hidden = YES;
    NSLog(@"%@", self.navigationController.viewControllers);
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
//    self.leftBtn.hidden = YES;
    
    self.rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"share_right"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
//    self.rightBtn.hidden = YES;
}

- (void)leftBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnAction:(UIButton *)sender {
    __block id<ISSContent> publishContent;
    __block Event *blockEvent = self.event;
    
    shareView *menuView = [[shareView alloc] init];
    
    [menuView addIconWithTiltle:@"新浪" icon:[UIImage imageNamed:@"icon-sina"] selectedBlock:^{
        publishContent = [ShareSDK content:@"一起去吧"
                            defaultContent:blockEvent.title
                                     image:[ShareSDK imageWithUrl:blockEvent.image]
                                     title:blockEvent.title
                                       url:blockEvent.adapt_url
                               description:@"测试"
                                 mediaType:SSPublishContentMediaTypeNews];
        
        
    [ShareSDK shareContent:publishContent
                      type:ShareTypeSinaWeibo
               authOptions:nil
              shareOptions:nil
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSPublishContentStateSuccess)
                        {
                            NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            NSLog(NSLocalizedString(@"TEXT_SHARE_FAI ", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                        }
                        
                    }];

    }];
    
    [menuView addIconWithTiltle:@"QQ" icon:[UIImage imageNamed:@"icon-qq"] selectedBlock:^{
        publishContent = [ShareSDK content:@"一起去吧"
                            defaultContent:blockEvent.title
                                     image:[ShareSDK imageWithUrl:blockEvent.image]
                                     title:blockEvent.title
                                       url:blockEvent.adapt_url
                               description:@"测试"
                                 mediaType:SSPublishContentMediaTypeNews];
        
        
        [ShareSDK shareContent:publishContent
                          type:ShareTypeQQ
                   authOptions:nil
                  shareOptions:nil
                 statusBarTips:YES
                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                            if (state == SSPublishContentStateSuccess)
                            {
                                NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                            }
                            else if (state == SSPublishContentStateFail)
                            {
                                NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                            }
                            
                        }];
    }];
    
    [menuView addIconWithTiltle:@"微信" icon:[UIImage imageNamed:@"icon-weixin"] selectedBlock:^{
        publishContent = [ShareSDK content:@"一起去吧"
                            defaultContent:blockEvent.title
                                     image:[ShareSDK imageWithUrl:blockEvent.image]
                                     title:blockEvent.title
                                       url:blockEvent.adapt_url
                               description:@"测试"
                                 mediaType:SSPublishContentMediaTypeNews];
        
        
        [ShareSDK shareContent:publishContent
                          type:ShareTypeWeixiSession
                   authOptions:nil
                  shareOptions:nil
                 statusBarTips:YES
                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                            if (state == SSPublishContentStateSuccess)
                            {
                                NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                            }
                            else if (state == SSPublishContentStateFail)
                            {
                                NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                            }
                            
                        }];

    }];
    
//    [menuView addIconWithTiltle:@"豆瓣" icon:[UIImage imageNamed:@"icon-douban"] selectedBlock:^{
//        publishContent = [ShareSDK content:@"一起去吧"
//                            defaultContent:blockEvent.title
//                                     image:[ShareSDK imageWithUrl:blockEvent.image]
//                                     title:blockEvent.title
//                                       url:blockEvent.adapt_url
//                               description:@"测试"
//                                 mediaType:SSPublishContentMediaTypeNews];
//        
//        
//        [ShareSDK shareContent:publishContent
//                          type:ShareTypeDouBan
//                   authOptions:nil
//                  shareOptions:nil
//                 statusBarTips:YES
//                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                            if (state == SSPublishContentStateSuccess)
//                            {
//                                NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
//                            }
//                            else if (state == SSPublishContentStateFail)
//                            {
//                                NSInteger erroCode = [error errorCode];
//                                NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
//                            }
//                            
//                        }];
//    }];
    
    [menuView show];

    
}

- (void)wish:(UIButton *)sender{
    self.senderButton = sender;
    UIButton *wishButton = sender;
    __block ResponseCode *code;
    __block Account *account;
    __weak typeof(self) weakSelf = self;
    if (wishButton.selected) {
        dispatch_queue_t queueToWish =  dispatch_queue_create("wishQueue", NULL);
        dispatch_async(queueToWish, ^{
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"deleteWishEvent" object:weakSelf.event];
            [nc postNotificationName:@"wishDelete" object:weakSelf.event];
            code = [API didNotWish:weakSelf.event.id];
            NSNumber *codeNumber = [NSNumber numberWithInt:202];
            if (([code.code compare:codeNumber] == NSOrderedSame)) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    sender.selected = !sender.selected;
                    if (!sender.selected) {
                        [[[[Toast makeText:@"取消感兴趣成功"] setGravity:ToastGravityBottom] setDuration:ToastDurationShort] show];
                    }
                });
            }else if (([code.code compare:[NSNumber numberWithInt:106]] == NSOrderedSame)) {
                //accesstoken过期，更新
                //TODO:验证是否对
                dispatch_queue_t queueToWish =  dispatch_queue_create("refreshToken", NULL);
                dispatch_async(queueToWish, ^{
                    account = [API update_access_token];
                    NSLog(@"*************************更新后的accesstoken = %@", account.access_token);
                    [Config saveAccount:account];
                    [weakSelf wish:weakSelf.senderButton];
                });
            }else {
                [[[[Toast makeText:@"未知错误"] setGravity:ToastGravityBottom] setDuration:ToastDurationShort] show];

            }
        });
    }else{
        dispatch_queue_t queueToDown =  dispatch_queue_create("wishQueue", NULL);
        dispatch_async(queueToDown, ^{
            code = [API wishEvent:weakSelf.event.id];
            NSLog(@"code.code = %@", code.code);
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"addWishEvent" object:weakSelf.event];
            [nc postNotificationName:@"deleteParticipateEvent" object:weakSelf.event];
            
            [nc postNotificationName:@"wishAdd" object:weakSelf.event];
            [nc postNotificationName:@"joinDelete" object:weakSelf.event];
            NSNumber *codeNumber = [NSNumber numberWithInt:202];
            if ([code.code compare:codeNumber] == NSOrderedSame) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    sender.selected = !sender.selected;
                    if (sender.selected) {
                        [[[[Toast makeText:@"感兴趣成功"] setGravity:ToastGravityBottom] setDuration:ToastDurationShort] show];
                        weakSelf.scrollerView.joinButton.selected = NO; //感兴趣和参加不能同时，后台会自动处理为一个
                    }
                });
            }else if (([code.code compare:[NSNumber numberWithInt:106]] == NSOrderedSame)) {
                //accesstoken过期，更新
                dispatch_queue_t queueToWish =  dispatch_queue_create("refreshToken", NULL);
                dispatch_async(queueToWish, ^{
                    account = [API update_access_token];
                    NSLog(@"************************更新后的accesstoken = %@", account.access_token);
                    [Config saveAccount:account];
                    [weakSelf wish:weakSelf.senderButton];
                });
            }else {
                [[[[Toast makeText:@"未知错误"] setGravity:ToastGravityBottom] setDuration:ToastDurationShort] show];

            }
        });
    }
}

- (void)participate:(UIButton *)sender{
    self.senderButton = sender;
    UIButton *joinButton = sender;
    __block ResponseCode *code;
    __block Account *account;
    __weak typeof(self) weakSelf = self;
    if (joinButton.selected) {
        dispatch_queue_t queueToJoin = dispatch_queue_create("joinQueue", NULL);
        dispatch_async(queueToJoin, ^{
            code = [API didNotParticipate:weakSelf.event.id];
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"deleteParticipateEvent" object:weakSelf.event];
            [nc postNotificationName:@"joinDelete" object:weakSelf.event];
            
            NSNumber *codeNumber = [NSNumber numberWithInt:202];
            if (([code.code compare:codeNumber] == NSOrderedSame)) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    sender.selected = !sender.selected;
                    if (!sender.selected) {
                        [[[[Toast makeText:@"退出参加成功！"] setGravity:ToastGravityBottom] setDuration:ToastDurationShort] show];
                    }
                });
            }else if (([code.code compare:[NSNumber numberWithInt:106]] == NSOrderedSame)) {
                //accesstoken过期，更新
                dispatch_queue_t queueToWish =  dispatch_queue_create("refreshToken", NULL);
                dispatch_async(queueToWish, ^{
                    account = [API update_access_token];
                    NSLog(@"更新后的accesstoken = %@", account.access_token);
                    [Config saveAccount:account];
                    [weakSelf wish:weakSelf.senderButton];
                });
            }else {
                [[[[Toast makeText:@"未知错误"] setGravity:ToastGravityBottom] setDuration:ToastDurationShort] show];
                
            }
        });
    }else{
        dispatch_queue_t queueToJoin = dispatch_queue_create("joinQueue", NULL);
        dispatch_async(queueToJoin, ^{
            code = [API participateEvent:weakSelf.event.id];
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"addParticipateEvent" object:weakSelf.event];
            [nc postNotificationName:@"deleteWishEvent" object:weakSelf.event];
            
            [nc postNotificationName:@"joinAdd" object:weakSelf.event];
            [nc postNotificationName:@"wishDelete" object:weakSelf.event];
            
            NSNumber *codeNumber = [NSNumber numberWithInt:202];
            if ([code.code compare:codeNumber] == NSOrderedSame) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    sender.selected = !sender.selected;
                    if (sender.selected) {
                        [[[[Toast makeText:@"参加成功"] setGravity:ToastGravityBottom] setDuration:ToastDurationShort] show];
                        weakSelf.scrollerView.wishButton.selected = NO; //感兴趣和参加不能同时，后台会自动处理为一个
                    }
                });
            }else if (([code.code compare:[NSNumber numberWithInt:106]] == NSOrderedSame)) {
                //accesstoken过期，更新
                dispatch_queue_t queueToWish =  dispatch_queue_create("refreshToken", NULL);
                dispatch_async(queueToWish, ^{
                    account = [API update_access_token];
                    NSLog(@"更新后的accesstoken = %@", account.access_token);
                    [Config saveAccount:account];
                    [weakSelf wish:weakSelf.senderButton];
                });
            }else {
                [[[[Toast makeText:@"未知错误"] setGravity:ToastGravityBottom] setDuration:ToastDurationShort] show];
            }
        });
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.titleLabel.hidden = NO;
//    self.rightBtn.hidden = NO;
//    self.leftBtn.hidden = NO;
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
//    self.leftBtn.alpha = alpha;
//    self.rightBtn.alpha = alpha;
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
