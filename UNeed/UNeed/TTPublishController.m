//
//  TTPublishController.m
//  UNeed
//
//  Created by wcshinestar on 12/26/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//
#define kTabHeight 64
#define kPadding 10
#define kItemHeight 40
#import "TTPublishController.h"
#import "TTGlobals.h"
#import "TTTools.h"
#import "UIView+Toast.h"
#import "AFNetworking.h"

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>


@interface TTPublishController ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
@property(nonatomic,strong)BMKLocationService* locationService;
@property(nonatomic,assign)CGFloat latitude;
@property(nonatomic,assign)CGFloat longitude;
@property(nonatomic,strong)NSString* address;
//地理编码
@property(nonatomic,strong)BMKGeoCodeSearch* search;



//UI 控件
/*
 lab_location：手动写的位置
 lab_info：需求或者服务的描述
 lab_private：是否隐私
 lab_distance：过滤范围，以米为单位
 lab_which：需求还是服务
 */
@property(nonatomic,weak)UILabel *lab_location,*lab_info,*lab_private,*lab_distance,*lab_which;
@property(nonatomic,weak)UITextField *tf_location,*tf_info,*tf_distance;
@property(nonatomic,weak)UIButton *btn_private,*btn_which,*btn_publish;

@end

@implementation TTPublishController

bool isPrivate = NO;
bool isCommand = YES;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.address = @"";
    self.locationService = [[BMKLocationService alloc] init];
    self.locationService.delegate = self;
    self.locationService.distanceFilter = 2.0;
    [self.locationService startUserLocationService];
    //地理编码
    self.search = [[BMKGeoCodeSearch alloc] init];
    self.search.delegate = self;
    
    [self buildUI];
}

- (void)buildUI {
    CGFloat labWidth = (tWidth - 3*kPadding)/4*1;
    CGFloat tfWidth = (tWidth - 3*kPadding)/4*3;
    
    //所在位置
    UILabel *lab_location = [[UILabel alloc] init];
    [self.view addSubview:lab_location];
    self.lab_location = lab_location;
    self.lab_location.text = @"所在位置:";
    self.lab_location.frame = CGRectMake(kPadding,kTabHeight + 1*kPadding + 0*kItemHeight, labWidth, kItemHeight);
    
    UITextField *tf_location = [[UITextField alloc] init];
    [self.view addSubview:tf_location];
    self.tf_location = tf_location;
    self.tf_location.frame = CGRectMake(kPadding*2 + labWidth,kTabHeight +  1*kPadding + 0*kItemHeight, tfWidth, kItemHeight);
    self.tf_location.backgroundColor = [UIColor orangeColor];
    //过滤距离
    UILabel *lab_distance = [[UILabel alloc] init];
    [self.view addSubview:lab_distance];
    self.lab_distance = lab_distance;
    self.lab_distance.text = @"过滤距离:";
    self.lab_distance.frame = CGRectMake(kPadding,kTabHeight +  2*kPadding + 1*kItemHeight, labWidth, kItemHeight);
    
    UITextField *tf_distance = [[UITextField alloc] init];
    [self.view addSubview:tf_distance];
    self.tf_distance = tf_distance;
    self.tf_distance.frame = CGRectMake(kPadding*2 + labWidth,kTabHeight +  2*kPadding + 1*kItemHeight, tfWidth, kItemHeight);
    self.tf_distance.backgroundColor = [UIColor orangeColor];
    //信息描述
    UILabel *lab_info = [[UILabel alloc] init];
    [self.view addSubview:lab_info];
    self.lab_info = lab_info;
    self.lab_info.text = @"信息描述:";
    self.lab_info.frame = CGRectMake(kPadding,kTabHeight +  3*kPadding + 2*kItemHeight, labWidth, kItemHeight);
    
    UITextField *tf_info = [[UITextField alloc] init];
    [self.view addSubview:tf_info];
    self.tf_info = tf_info;
    self.tf_info.frame = CGRectMake(kPadding*2 + labWidth,kTabHeight +  3*kPadding + 2*kItemHeight, tfWidth, kItemHeight);
    self.tf_info.backgroundColor = [UIColor orangeColor];
    //是否隐私
    UILabel *lab_private = [[UILabel alloc] init];
    [self.view addSubview:lab_private];
    self.lab_private = lab_private;
    self.lab_private.text = @"是否隐私:";
    self.lab_private.frame = CGRectMake(kPadding,kTabHeight +  4*kPadding + 3*kItemHeight, labWidth, kItemHeight);
    
    UIButton *btn_private = [[UIButton alloc] init];
    [self.view addSubview:btn_private];
    self.btn_private = btn_private;
    self.btn_private.frame = CGRectMake(kPadding*2 + labWidth,kTabHeight +  4*kPadding + 3*kItemHeight, kItemHeight, kItemHeight);
    self.btn_private.layer.cornerRadius = kItemHeight/2;
    self.btn_private.backgroundColor = [UIColor grayColor];
    [self.btn_private addTarget:self action:@selector(changePrivacy) forControlEvents:UIControlEventTouchUpInside];
    //种类
    UILabel *lab_which = [[UILabel alloc] init];
    [self.view addSubview:lab_which];
    self.lab_which = lab_which;
    self.lab_which.text = @"选择种类:";
    self.lab_which.frame = CGRectMake(kPadding,kTabHeight +  5*kPadding + 4*kItemHeight, labWidth, kItemHeight);
    
    UIButton *btn_which = [[UIButton alloc] init];
    [self.view addSubview:btn_which];
    self.btn_which = btn_which;
    self.btn_which.frame = CGRectMake(kPadding*2 + labWidth,kTabHeight +  5*kPadding + 4*kItemHeight, tfWidth/2, kItemHeight);
    [self.btn_which setTitle:@"需  求" forState:UIControlStateNormal];
    self.btn_which.layer.cornerRadius = kPadding;
    self.btn_which.backgroundColor = [UIColor orangeColor];
    [self.btn_which addTarget:self action:@selector(changeWhich) forControlEvents:UIControlEventTouchUpInside];
    //发布
    UIButton *btn_publish = [[UIButton alloc] init];
    [self.view addSubview:btn_publish];
    self.btn_publish = btn_publish;
    self.btn_publish.layer.cornerRadius = 10.0;
    self.btn_publish.frame = CGRectMake(tWidth/2-40, tHeight-64, 80, kItemHeight);
    [self.btn_publish setTitle:@"发 布" forState:UIControlStateNormal];
    [self.btn_publish setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.btn_publish addTarget:self action:@selector(beginPublish) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    NSLog(@"heading is %@",userLocation.heading);
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    self.latitude = userLocation.location.coordinate.latitude;
    self.longitude = userLocation.location.coordinate.longitude;
    NSLog(@"lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [self reverseLocation:self.latitude longitude:self.longitude];
}



- (void)reverseLocation:(CGFloat)latitude longitude:(CGFloat)longitude {
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){self.latitude,self.longitude};
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    option.reverseGeoPoint = pt;
    BOOL flag = [self.search reverseGeoCode:option];
    if (flag) {
        NSLog(@"反geo检索成功");
    }
        else{
        NSLog(@"反geo检索失败");
    }
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    
    if (error == BMK_SEARCH_NO_ERROR) {
        NSLog(@"address=%@",result.address);
        self.address = result.address;
        for (BMKPoiInfo *info in result.poiList) {
           NSLog(@"address=%@,name=%@",info.address,info.name);
        }
    }else {
        NSLog(@"error happends");
    }
    
}

- (void)changePrivacy {
    isPrivate = !isPrivate;
    if (isPrivate) {
        self.btn_private.backgroundColor = [UIColor redColor];
    }else if (!isPrivate){
        self.btn_private.backgroundColor = [UIColor grayColor];
    }
}

- (void)changeWhich {
    isCommand = !isCommand;
    if (isCommand) {
        [self.btn_which setTitle:@"需  求" forState:UIControlStateNormal];
    }else if (!isCommand){
        [self.btn_which setTitle:@"服  务" forState:UIControlStateNormal];
    }
}

- (void)beginPublish {
    
    NSLog(@"beginPublish");
    NSString *location = self.tf_location.text;
    NSString *distance = self.tf_distance.text;
    NSString *info = self.tf_info.text;
    
    if ([location isEqualToString:@""]) {
        [self.view makeToast:@"位置不能为空" duration:3.0 position:CSToastPositionCenter];
        return;
    }
    
    if ([distance isEqualToString:@""]) {
        [self.view makeToast:@"过滤距离不能为空" duration:3.0 position:CSToastPositionCenter];
        return;
    }
    
    if ([info isEqualToString:@""]) {
        [self.view makeToast:@"描述信息不能为空" duration:3.0 position:CSToastPositionCenter];
        return;
    }
    
    if (![TTTools isPureFloat:distance]) {
        [self.view makeToast:@"你填写的过滤距离错误" duration:3.0 position:CSToastPositionCenter];
        return;
    }
    
    //判断所有条件符合后处理：
    
    
    NSString *state = [TTTools obtainInfo:@"user_status"];
    if ([state isEqualToString:@"skip"]) {
        [self.view makeToast:@"您是游客，还没有登陆" duration:3.0 position:CSToastPositionCenter];
        return;
    }
    
    if ([self.address isEqualToString: @""]) {
        [self.view makeToast:@"还没有定位完成" duration:3.0 position:CSToastPositionCenter];
        return;
    }
    
    CGFloat realDistance = [distance floatValue];
    NSString *email = [TTTools obtainInfo:@"user_email"];
    
    
    NSInteger private = isPrivate ? 0 : 1 ;
    NSInteger command = isCommand ? 0 : 1 ;
    
    [self uploadDatawithemail:email location:location locationA:self.address info:info private:private type:command distance:realDistance longitude:self.longitude latitude:self.latitude];
    
}

- (void)uploadDatawithemail:(NSString *)email location:(NSString *)location locationA:(NSString *)locationA info:(NSString *)info private:(NSInteger)private type:(NSInteger)type distance:(CGFloat)distance longitude:(CGFloat)longitude latitude:(CGFloat)latitude {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSString *URLString = @"http://youneed.duapp.com/publish.php";
     NSDictionary *params = @{@"user_email":email,@"publish_location": location,@"publish_locationA":locationA,@"publish_info":info,@"publish_private":[NSNumber numberWithInteger:private],@"publish_type":[NSNumber numberWithInteger:type],@"publish_distance":[NSNumber numberWithFloat:distance],@"publish_longitude":[NSNumber numberWithFloat:longitude],@"publish_latitude":[NSNumber numberWithFloat:latitude]};
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:params error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, NSDictionary *responseObject, NSError *error) {
        if (error) {
            [self.view makeToast:@"您的网络可能有问题" duration:3.0 position:CSToastPositionCenter];
        } else {
            NSString *code = responseObject[@"code"];
            if ([code isEqualToString:@"ok"]) {
                self.tf_location.text = @"";
                self.tf_distance.text = @"";
                self.tf_info.text = @"";
            }else if ([code isEqualToString:@"no"]){
                [self.view makeToast:@"发布失败，再次发送" duration:3.0 position:CSToastPositionCenter];
            }

        }
    }];
    [dataTask resume];
    
    
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSString *url = @"http://youneed.duapp.com/publish.php";
//    NSDictionary *params = @{@"user_email":email,@"publish_location": location,@"publish_locationA":locationA,@"publish_info":info,@"publish_private":[NSNumber numberWithInteger:private],@"publish_type":[NSNumber numberWithInteger:type],@"publish_distance":[NSNumber numberWithFloat:distance],@"publish_longitude":[NSNumber numberWithFloat:longitude],@"publish_latitude":[NSNumber numberWithFloat:latitude]};
//    [manager GET:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary  *responseObject) {
//        NSString *code = responseObject[@"code"];
//        if ([code isEqualToString:@"ok"]) {
//            self.tf_location.text = @"";
//            self.tf_distance.text = @"";
//            self.tf_info.text = @"";
//        }else if ([code isEqualToString:@"no"]){
//            [self.view makeToast:@"发布失败，再次发送" duration:3.0 position:CSToastPositionCenter];
//        }
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        [self.view makeToast:@"您的网络可能有问题" duration:3.0 position:CSToastPositionCenter];
//    }];
//
}
@end
