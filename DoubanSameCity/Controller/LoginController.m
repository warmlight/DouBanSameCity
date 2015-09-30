//
//  LoginController.m
//  DoubanSameCity
//
//  Created by yiban on 15/9/23.
//  Copyright © 2015年 yiban. All rights reserved.
//

#import "LoginController.h"
#import <MBProgressHUD.h>
#import "API.h"
#import "Config.h"
#import "Toast.h"
#import "SettingController.h"


#define mainSize    [UIScreen mainScreen].bounds.size

#define offsetLeftHand      60

#define rectLeftHand        CGRectMake(61-offsetLeftHand, 90, 40, 65)
#define rectLeftHandGone    CGRectMake(mainSize.width / 2 - 100, vLogin.frame.origin.y - 22, 40, 40)

#define rectRightHand       CGRectMake(imgLogin.frame.size.width / 2 + 60, 90, 40, 65)
#define rectRightHandGone   CGRectMake(mainSize.width / 2 + 62, vLogin.frame.origin.y - 22, 40, 40)


@interface LoginController ()<UITextFieldDelegate>
{
    UITextField* txtUser;
    UITextField* txtPwd;
    
    UIImageView* imgLeftHand;
    UIImageView* imgRightHand;
    
    UIImageView* imgLeftHandGone;
    UIImageView* imgRightHandGone;
    
    UIButton* loginButton;
    
    JxbLoginShowType showType;
}
@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView* imgLogin = [[UIImageView alloc] initWithFrame:CGRectMake(mainSize.width / 2 - 211 / 2, 100, 211, 109)];
    imgLogin.image = [UIImage imageNamed:@"owl-login"];
    imgLogin.layer.masksToBounds = YES;
    [self.view addSubview:imgLogin];

    
    imgLeftHand = [[UIImageView alloc] initWithFrame:rectLeftHand];
    imgLeftHand.image = [UIImage imageNamed:@"owl-login-arm-left"];
    [imgLogin addSubview:imgLeftHand];
    
    imgRightHand = [[UIImageView alloc] initWithFrame:rectRightHand];
    imgRightHand.image = [UIImage imageNamed:@"owl-login-arm-right"];
    [imgLogin addSubview:imgRightHand];
    
    UIView* vLogin = [[UIView alloc] initWithFrame:CGRectMake(15, 200, mainSize.width - 30, 160)];
    vLogin.layer.borderWidth = 0.5;
    vLogin.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    vLogin.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:vLogin];
    
    imgLeftHandGone = [[UIImageView alloc] initWithFrame:rectLeftHandGone];
    imgLeftHandGone.image = [UIImage imageNamed:@"icon_hand"];
    [self.view addSubview:imgLeftHandGone];
    
    imgRightHandGone = [[UIImageView alloc] initWithFrame:rectRightHandGone];
    imgRightHandGone.image = [UIImage imageNamed:@"icon_hand"];
    [self.view addSubview:imgRightHandGone];
    
    txtUser = [[UITextField alloc] initWithFrame:CGRectMake(30, 30, vLogin.frame.size.width - 60, 44)];
    txtUser.delegate = self;
    txtUser.layer.cornerRadius = 5;
    txtUser.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    txtUser.layer.borderWidth = 0.5;
    txtUser.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    txtUser.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
    imgUser.image = [UIImage imageNamed:@"iconfont-user"];
    [txtUser.leftView addSubview:imgUser];
    [vLogin addSubview:txtUser];
    
    txtPwd = [[UITextField alloc] initWithFrame:CGRectMake(30, 90, vLogin.frame.size.width - 60, 44)];
    txtPwd.delegate = self;
    txtPwd.layer.cornerRadius = 5;
    txtPwd.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    txtPwd.layer.borderWidth = 0.5;
    txtPwd.secureTextEntry = YES;
    txtPwd.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    txtPwd.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imgPwd = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
    imgPwd.image = [UIImage imageNamed:@"iconfont-password"];
    [txtPwd.leftView addSubview:imgPwd];
    [vLogin addSubview:txtPwd];
    
    loginButton = [[UIButton alloc] initWithFrame:CGRectMake(mainSize.width / 2 - 211 / 2, 400, 211, 30)];
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor lightGrayColor]];
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)loginButtonClick {
    if ([txtPwd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0|| [txtUser.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] == 0) {
        [[[[Toast makeText:@"请填写完整信息"] setGravity:ToastGravityBottom] setDuration:ToastDurationShort] show];
        
    }else {
        // 引入第三方框架"MBProgressHUD"添加页面加载提示
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.labelText = @"努力加载中";                    // 设置文字
        hud.labelFont = [UIFont systemFontOfSize:14];
        
        dispatch_queue_t queue =  dispatch_queue_create("myqueue", NULL);
        dispatch_async(queue, ^{
            NSInteger code = [API login:txtUser.text password:txtPwd.text];
            if (code != 200) {
                [[[[Toast makeText:@"登陆失败"] setGravity:ToastGravityBottom] setDuration:ToastDurationShort] show];
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if ([Config getLoginUserId]) {
                    NSUInteger index = self.navigationController.viewControllers.count;
                    SettingController *settingVC = self.navigationController.viewControllers[index - 2];
                    [self.navigationController popToViewController:settingVC animated:YES];
//                    [self dismissViewControllerAnimated:NO completion:nil];
                    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
                    [nc postNotificationName:@"push_reloadData" object:nil];
                }
            });
        });
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![txtUser isExclusiveTouch] || ![txtPwd isExclusiveTouch])
    {
        [txtUser resignFirstResponder];
        [txtPwd resignFirstResponder];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:txtUser]) {
        if (showType != JxbLoginShowType_PASS)
        {
            showType = JxbLoginShowType_USER;
            return;
        }
        showType = JxbLoginShowType_USER;
        [UIView animateWithDuration:0.5 animations:^{
            imgLeftHand.frame = CGRectMake(imgLeftHand.frame.origin.x - offsetLeftHand, imgLeftHand.frame.origin.y + 30, imgLeftHand.frame.size.width, imgLeftHand.frame.size.height);
            
            imgRightHand.frame = CGRectMake(imgRightHand.frame.origin.x + 48, imgRightHand.frame.origin.y + 30, imgRightHand.frame.size.width, imgRightHand.frame.size.height);
            
            
            imgLeftHandGone.frame = CGRectMake(imgLeftHandGone.frame.origin.x - 70, imgLeftHandGone.frame.origin.y, 40, 40);
            
            imgRightHandGone.frame = CGRectMake(imgRightHandGone.frame.origin.x + 30, imgRightHandGone.frame.origin.y, 40, 40);
            
            
        } completion:^(BOOL b) {
        }];
    }
    else if ([textField isEqual:txtPwd]) {
        if (showType == JxbLoginShowType_PASS)
        {
            showType = JxbLoginShowType_PASS;
            return;
        }
        showType = JxbLoginShowType_PASS;
        [UIView animateWithDuration:0.5 animations:^{
            imgLeftHand.frame = CGRectMake(imgLeftHand.frame.origin.x + offsetLeftHand, imgLeftHand.frame.origin.y - 30, imgLeftHand.frame.size.width, imgLeftHand.frame.size.height);
            imgRightHand.frame = CGRectMake(imgRightHand.frame.origin.x - 48, imgRightHand.frame.origin.y - 30, imgRightHand.frame.size.width, imgRightHand.frame.size.height);
            
            
            imgLeftHandGone.frame = CGRectMake(imgLeftHandGone.frame.origin.x + 70, imgLeftHandGone.frame.origin.y, 0, 0);
            
            imgRightHandGone.frame = CGRectMake(imgRightHandGone.frame.origin.x - 30, imgRightHandGone.frame.origin.y, 0, 0);
            
        } completion:^(BOOL b) {
        }];
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
