//
//  TThomeController.m
//  UNeed
//
//  Created by wcshinestar on 12/25/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//
#define kWidth 300
#define kHeight 120
#import "TThomeController.h"
#import "TTSettingView.h"
#import "TTGlobals.h"
#import "TTDetail.h"
#import "TTDetailCell.h"
#import "TTTools.h"

#import "AFNetworking.h"
#import "UIView+Toast.h"
#import <RongIMKit/RongIMKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>


@interface TThomeController ()<settingViewDelegate,BMKLocationServiceDelegate,DetailCellDelegate>

@property(nonatomic,strong)BMKLocationService* locationService;
@property(nonatomic,weak)UISearchBar* search;
@property(nonatomic,assign)CGFloat latitude;
@property(nonatomic,assign)CGFloat longitude;
@property(nonatomic,assign)CGFloat filterDistance;
@property(nonatomic,assign)NSInteger choiceType;

@property(nonatomic,strong)NSMutableArray* dictArray;

@end

@implementation TThomeController

- (NSMutableArray *)dictArray {
    if (_dictArray == nil) {
        _dictArray = [NSMutableArray array];
    }
    return _dictArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildNavigationUI];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[TTDetailCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.filterDistance = 10000 * 10000;
    
    self.locationService = [[BMKLocationService alloc] init];
    self.locationService.delegate = self;
    self.locationService.distanceFilter = 64.0;
    [self.locationService startUserLocationService];
    
}

- (void)buildNavigationUI {
    UISearchBar *search = [[UISearchBar alloc] init];
    self.navigationItem.titleView = search;
    self.search = search;
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(beginSetting)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStyleDone target:self action:@selector(beginSearch)];
    self.navigationItem.rightBarButtonItems = @[item1,item2];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dictArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TTDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[TTDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.clickDelegate = self;
    cell.detail = [self.dictArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 32 * 4;
}

-(void)settingView:(TTSettingView *)settingView distance:(CGFloat)distance type:(NSInteger)type {
    if (settingView.superview != nil) {
        [settingView.superview removeFromSuperview];
    }
    self.filterDistance = distance;
    self.choiceType = type;
}

- (void)beginSearch {
    
    [self obtainData:self.longitude latitude:self.latitude filterDist:self.filterDistance type:self.choiceType keyword:self.search.text];
    
}

- (void)beginSetting {
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tWidth, tHeight)];
    TTSettingView *settingView = [[TTSettingView alloc] initWithFrame:CGRectMake( (tWidth - kWidth)/2, 64, kWidth, kHeight)];
    settingView.clickDelegate = self;
    [maskView addSubview:settingView];
    [self.view.window addSubview:maskView];
}

//mark :location

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    self.latitude = userLocation.location.coordinate.latitude;
    self.longitude = userLocation.location.coordinate.longitude;
    
    
    [self obtainData:self.longitude latitude:self.latitude filterDist:self.filterDistance type:2 keyword:@"all"];
    
}

- (void)DetailBtnClick:(TTDetailCell *)detailCell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:detailCell];
    TTDetail *detail = [self.dictArray objectAtIndex:indexPath.row];
    NSString *email = detail.detail_email;
    NSLog(@"%@",email);
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType = ConversationType_PRIVATE;
    conversationVC.targetId = email;
    
    NSString *own = [TTTools obtainInfo:@"user_email"];
    NSString *realTitle = [own isEqualToString:email] ? @"自己" : email;
    conversationVC.title = realTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)obtainData:(CGFloat)longitude latitude:(CGFloat)latitude filterDist:(CGFloat)filterDist type:(NSInteger)type keyword:(NSString *)keyword {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSString *URLString = @"http://youneed.duapp.com/details.php";
    NSDictionary *params = @{@"publish_longitude":[NSNumber numberWithFloat:longitude],@"publish_latitude":[NSNumber numberWithFloat:latitude],@"filter_distance":[NSNumber numberWithFloat:filterDist],@"publish_keyword":keyword,@"choice_type":[NSNumber numberWithInteger:type]};
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:params error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, NSArray *responseObject, NSError *error) {
        if (error) {
            [self.view makeToast:@"您的网络可能有问题" duration:3.0 position:CSToastPositionCenter];
        } else {
            if (responseObject.count > 0) {
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dict in responseObject) {
                    TTDetail *detail = [TTDetail detailWithDict:dict];
                    [array addObject:detail];
                }
                self.dictArray = array;
                [self.tableView reloadData];
            } else {
                [self.dictArray removeAllObjects];
                [self.tableView reloadData];
            }
        }
    }];
    [dataTask resume];
    
}



@end
