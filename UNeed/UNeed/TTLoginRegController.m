//
//  TTLoginRegController.m
//  UNeed
//
//  Created by wcshinestar on 12/26/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//
#define kPadding 10
#define kItemHeight 44

#import "TTLoginRegController.h"
#import "TTGlobals.h"
#import "TTTools.h"
#import "UIView+Toast.h"
#import "TTRootViewController.h"
#import "TTRegController.h"
#import "AFNetworking.h"
#import <RongIMKit/RongIMKit.h>

@interface TTLoginRegController ()<UITextFieldDelegate>

@property(nonatomic,weak)UITextField* user;
@property(nonatomic,weak)UITextField* password;
@property(nonatomic,weak)UIButton* login;
@property(nonatomic,weak)UIButton* skip;
@property(nonatomic,weak)UIButton* reginst;

@end

@implementation TTLoginRegController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
    [self buildUI];
}

- (void)buildUI {
    CGFloat center = tHeight/2.0;
    CGFloat halfWidth = tWidth/2.0;
    CGFloat bottomWidth = (tWidth - 3*kPadding)/2.0;
    //添加用户名
    UITextField *user = [[UITextField alloc] initWithFrame:CGRectMake(kPadding, center - kPadding - 2*kItemHeight, tWidth - 2*kPadding, kItemHeight)];
    [self.view addSubview:user];
    self.user = user;
    self.user.backgroundColor = [UIColor whiteColor];
    self.user.textAlignment = NSTextAlignmentCenter;
    self.user.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.user.adjustsFontSizeToFitWidth = YES;
    self.user.placeholder = @"填写您的邮箱";
    self.user.layer.cornerRadius = 5;
    self.user.delegate = self;
    //添加密码
    UITextField *password = [[UITextField alloc] initWithFrame:CGRectMake(kPadding, center - kItemHeight, tWidth - 2*kPadding, kItemHeight)];
    [self.view addSubview:password];
    self.password = password;
    self.password.backgroundColor = [UIColor whiteColor];
    self.password.textAlignment = NSTextAlignmentCenter;
    self.password.secureTextEntry = YES;
    self.password.placeholder = @"填写您的密码";
    self.password.layer.cornerRadius = 5;
    self.password.delegate = self;
    //添加登陆
    UIButton *login = [[UIButton alloc] initWithFrame:CGRectMake(halfWidth/2, center + kPadding, halfWidth, kItemHeight)];
    [self.view addSubview:login];
    self.login = login;
    self.login.backgroundColor = [UIColor orangeColor];
    [self.login setTitle:@"登 陆" forState:UIControlStateNormal];
    self.login.layer.cornerRadius = 5;
    [self.login addTarget:self action:@selector(beginLogin) forControlEvents:UIControlEventTouchUpInside];
    //添加跳过
    UIButton *skip = [[UIButton alloc] initWithFrame:CGRectMake(kPadding, tHeight - kPadding - kItemHeight,bottomWidth , kItemHeight)];
    [self.view addSubview:skip];
    self.skip = skip;
    self.skip.layer.cornerRadius = 5;
    [self.skip setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.skip setTitle:@"跳 过" forState:UIControlStateNormal];
    [self.skip addTarget:self action:@selector(beginSkip) forControlEvents:UIControlEventTouchUpInside];
    //添加注册
    UIButton *regist = [[UIButton alloc] initWithFrame:CGRectMake(bottomWidth + 2*kPadding, tHeight - kPadding - kItemHeight, bottomWidth, kItemHeight)];
    [self.view addSubview:regist];
    self.reginst = regist;
    self.reginst.layer.cornerRadius = 5;
    [self.reginst setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.reginst setTitle:@"注 册" forState:UIControlStateNormal];
    [self.reginst addTarget:self action:@selector(beginRegister) forControlEvents:UIControlEventTouchUpInside];
    
}

//处理登陆按钮点击事件
- (void)beginLogin {
    NSString *user = self.user.text;
    NSString *password = self.password.text;
    //判断内容是否为空
    if ([user isEqualToString:@""] || [password isEqualToString:@""]) {
        [self.view makeToast:@"邮箱和密码不能为空" duration:3.0 position:CSToastPositionCenter];
        return;
    }
    //判断邮箱格式是否正确
    
    if (![TTTools validateEmail:user]) {
        [self.view makeToast:@"您输入的邮箱格式不正确" duration:3.0 position:CSToastPositionCenter];
        return;
    }
    [self sendRegData:user password:password];
    
    
    
}

- (void)sendRegData:(NSString *)email password:(NSString *)password {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSString *URLString = @"http://youneed.duapp.com/login.php";
    NSDictionary *params = @{@"user_name":email,@"user_password": password};
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:params error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, NSDictionary *responseObject, NSError *error) {
        if (error) {
            [self.view makeToast:@"您的网络可能有问题" duration:3.0 position:CSToastPositionCenter];
        } else {
            NSString *code = responseObject[@"code"];
                    if ([code isEqualToString:@"ok"]) {
                        NSLog(@"token=%@",responseObject[@"token"]);
                        [TTTools setInfo:@"user_token" value:responseObject[@"token"]];
                        [TTTools setInfo:@"user_status" value:@"login"];
                        [TTTools setInfo:@"user_email" value:email];
                
                        [[RCIM sharedRCIM] connectWithToken:[TTTools obtainInfo:@"user_token"] success:^(NSString *userId) {
                                NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                            } error:^(RCConnectErrorCode status) {
                                
                            } tokenIncorrect:^{
                                NSLog(@"token错误");
                            }];
                        
                        [self enterMainPage];
                    }else if ([code isEqualToString:@"no"]){
                        [self.view makeToast:@"登陆失败" duration:3.0 position:CSToastPositionCenter];
                    }else if ([code isEqualToString:@"notactive"]){
                        [self.view makeToast:@"邮箱还未激活！" duration:3.0 position:CSToastPositionCenter];
                    }
        }
    }];
    [dataTask resume];
    


    
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSString *url = @"http://youneed.duapp.com/login.php";
//    NSDictionary *params = @{@"user_name":email,@"user_password": password};
//    [manager GET:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary  *responseObject) {
//        NSString *code = responseObject[@"code"];
//        if ([code isEqualToString:@"ok"]) {
//            [TTTools setInfo:@"user_status" value:@"login"];
//            [TTTools setInfo:@"user_email" value:email];
//            [self enterMainPage];
//        }else if ([code isEqualToString:@"no"]){
//            [self.view makeToast:@"登陆失败" duration:3.0 position:CSToastPositionCenter];
//        }else if ([code isEqualToString:@"notactive"]){
//            [self.view makeToast:@"邮箱还未激活！" duration:3.0 position:CSToastPositionCenter];
//        }
//        NSLog(@"response = %@",responseObject[@"code"]);
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        [self.view makeToast:@"您的网络可能有问题" duration:3.0 position:CSToastPositionCenter];
//    }];
}


- (void)beginSkip {
    [TTTools setInfo:@"user_state" value:@"skip"];
    [self enterMainPage];
}

- (void)beginRegister {
    [self presentViewController:[[TTRegController alloc] init] animated:YES completion:nil];
}

- (void)enterMainPage {
    [UIApplication sharedApplication].keyWindow.rootViewController = [[TTRootViewController alloc] init];
}

//取消键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.user resignFirstResponder];
    [self.password resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.user resignFirstResponder];
    [self.password resignFirstResponder];
    return YES;
}




@end
