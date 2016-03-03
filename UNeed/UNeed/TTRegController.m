//
//  TTRegController.m
//  UNeed
//
//  Created by wcshinestar on 12/26/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//
#define kPadding 10
#define kItemHeight 44
#import "TTRegController.h"
#import "TTGlobals.h"
#import "TTTools.h"
#import "UIView+Toast.h"
#import "AFNetworking.h"

@interface TTRegController ()<UITextFieldDelegate>

@property(nonatomic,weak)UITextField* user;
@property(nonatomic,weak)UITextField* password;
@property(nonatomic,weak)UITextField* confirmPass;
@property(nonatomic,weak)UIButton* regist;
@property(nonatomic,weak)UIButton* notRegist;

@end

@implementation TTRegController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.616 green:0.776 blue:0.243 alpha:1];
    [self buildUI];
}

- (void)buildUI {
    CGFloat center = tHeight/2.0;
    CGFloat btnWidth = (tWidth - 3*kPadding)/2.0;
    
    //添加用户名
    UITextField *user = [[UITextField alloc] initWithFrame:CGRectMake(kPadding, center - 2*kPadding - 3*kItemHeight, tWidth - 2*kPadding, kItemHeight)];
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
    UITextField *password = [[UITextField alloc] initWithFrame:CGRectMake(kPadding, center - 2*kItemHeight - kPadding, tWidth - 2*kPadding, kItemHeight)];
    [self.view addSubview:password];
    self.password = password;
    self.password.backgroundColor = [UIColor whiteColor];
    self.password.textAlignment = NSTextAlignmentCenter;
    self.password.secureTextEntry = YES;
    self.password.placeholder = @"填写您的密码";
    self.password.layer.cornerRadius = 5;
    self.password.delegate = self;
    //添加确认密码
    UITextField *confirmPass = [[UITextField alloc] initWithFrame:CGRectMake(kPadding, center - kItemHeight, tWidth - 2*kPadding, kItemHeight)];
    [self.view addSubview:confirmPass];
    self.confirmPass = confirmPass;
    self.confirmPass.backgroundColor = [UIColor whiteColor];
    self.confirmPass.textAlignment = NSTextAlignmentCenter;
    self.confirmPass.secureTextEntry = YES;
    self.confirmPass.placeholder = @"确认您的密码";
    self.confirmPass.layer.cornerRadius = 5;
    self.confirmPass.delegate = self;
    
    //添加注册
    UIButton *regist = [[UIButton alloc] initWithFrame:CGRectMake(kPadding,center + kPadding,btnWidth , kItemHeight)];
    [self.view addSubview:regist];
    self.regist = regist;
    self.regist.layer.cornerRadius = 5;
    [self.regist setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.regist.backgroundColor = [UIColor orangeColor];
    [self.regist setTitle:@"注 册" forState:UIControlStateNormal];
    [self.regist addTarget:self action:@selector(beginRegister) forControlEvents:UIControlEventTouchUpInside];
    //添加注册
    UIButton *notRegist = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth + 2*kPadding, center + kPadding, btnWidth, kItemHeight)];
    [self.view addSubview:notRegist];
    self.notRegist = notRegist;
    self.notRegist.layer.cornerRadius = 5;
    self.notRegist.backgroundColor = [UIColor orangeColor];
    [self.notRegist setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.notRegist setTitle:@"已有账号" forState:UIControlStateNormal];
    [self.notRegist addTarget:self action:@selector(beginLogin) forControlEvents:UIControlEventTouchUpInside];
}

- (void)beginRegister {
    NSLog(@"begin");
    NSString *user = self.user.text;
    NSString *password = self.password.text;
    NSString *confirmPass = self.confirmPass.text;
    if ([user isEqualToString:@""] || [password isEqualToString:@""] || [confirmPass isEqualToString:@""]) {
        [self.view makeToast:@"邮箱和密码不可为空" duration:3.0 position:CSToastPositionCenter];
        return;
    }
    if (![password isEqualToString:confirmPass]) {
        [self.view makeToast:@"密码不一致" duration:3.0 position:CSToastPositionCenter];
        return;
    }
    if (![TTTools validateEmail:user]) {
        [self.view makeToast:@"邮件格式不正确" duration:3.0 position:CSToastPositionCenter];
        return;
    }
    [self sendRegData:user password:password];
    
}

- (void)sendRegData:(NSString *)email password:(NSString *)password {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSString *URLString = @"http://youneed.duapp.com/register.php";
    NSDictionary *params = @{@"user_name":email,@"user_password": password};
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:params error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, NSDictionary *responseObject, NSError *error) {
        if (error) {
            [self.view makeToast:@"您的网络可能有问题" duration:3.0 position:CSToastPositionCenter];
        } else {
            NSString *code = responseObject[@"code"];
            if ([code isEqualToString:@"ok"]) {
                [self.view makeToast:@"注册成功，请激活邮箱" duration:3.0 position:CSToastPositionCenter];
            }else if ([code isEqualToString:@"no"]){
                [self.view makeToast:@"注册失败" duration:3.0 position:CSToastPositionCenter];
            }else if ([code isEqualToString:@"repeat"]){
                [self.view makeToast:@"该账号已经存在" duration:3.0 position:CSToastPositionCenter];
            }
        }
    }];
    [dataTask resume];
    
    
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSString *url = @"http://youneed.duapp.com/register.php";
//    NSDictionary *params = @{@"user_name":email,@"user_password": password};
//    [manager GET:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary  *responseObject) {
//        NSString *code = responseObject[@"code"];
//        if ([code isEqualToString:@"ok"]) {
//            [self.view makeToast:@"注册成功，请激活邮箱" duration:3.0 position:CSToastPositionCenter];
//        }else if ([code isEqualToString:@"no"]){
//            [self.view makeToast:@"注册失败" duration:3.0 position:CSToastPositionCenter];
//        }else if ([code isEqualToString:@"repeat"]){
//            [self.view makeToast:@"该账号已经存在" duration:3.0 position:CSToastPositionCenter];
//        }
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        [self.view makeToast:@"您的网络可能有问题" duration:3.0 position:CSToastPositionCenter];
//    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.user resignFirstResponder];
    [self.password resignFirstResponder];
    [self.confirmPass resignFirstResponder];
}



- (void)beginLogin {
    [self dismissViewControllerAnimated:YES completion:nil];
}





@end
