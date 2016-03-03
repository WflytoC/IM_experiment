//
//  AppDelegate.h
//  UNeed
//
//  Created by wcshinestar on 12/25/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>
//BMKGeneralDelegate协议用于检测网络和授权验证

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)BMKMapManager* mapManager;

@end

