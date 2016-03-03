//
//  AppDelegate.m
//  UNeed
//
//  Created by wcshinestar on 12/25/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import "AppDelegate.h"
#import "TTLoginRegController.h"
#import "TTRootViewController.h"
#import "TTTools.h"

#import <RongIMKit/RongIMKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 要使用百度地图，请先启动BaiduMapManager,请求验证，验证的结果在代理方法中处理！
    self.mapManager = [[BMKMapManager alloc]init];
    [self.mapManager start:@"bAVC8VoESefHKnwIPQ3iOlGC" generalDelegate:self];
    
    //初始化融云
    [[RCIM sharedRCIM] initWithAppKey:@"c9kqb3rdkusvj"];
    
    if ([TTTools obtainInfo:@"user_token"] != NULL) {
        [[RCIM sharedRCIM] connectWithToken:[TTTools obtainInfo:@"user_token"] success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        } error:^(RCConnectErrorCode status) {
            
        } tokenIncorrect:^{
            NSLog(@"token错误");
        }];
        NSLog(@"user=%@",[TTTools obtainInfo:@"user_token"]);
    }else {
        NSLog(@"no");
    }
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    NSString *user_state = [TTTools obtainInfo:@"user_status"];
    
    if ([user_state isEqualToString:@"login"]) {
        self.window.rootViewController = [[TTRootViewController alloc] init];
    }else {
        self.window.rootViewController = [[TTLoginRegController alloc] init];
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [BMKMapView willBackGround];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [BMKMapView didForeGround];
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

//paragm mark -- BMKGeneralDelegate
-(void)onGetNetworkState:(int)iError{
    if (iError == 0) {
        NSLog(@"Network good");
    }else {
        NSLog(@"bad Network");
    }
}

-(void)onGetPermissionState:(int)iError{
    if (iError == 0) {
        NSLog(@"Permissioin ok");
    }else {
        NSLog(@"bad Permission");
    }
}

@end
