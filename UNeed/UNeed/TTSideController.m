//
//  TTSideController.m
//  UNeed
//
//  Created by wcshinestar on 12/25/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import "TTSideController.h"
#import "ResideMenu.h"

#import "TThomeController.h"
#import "TTPublishController.h"
#import "TTRecordController.h"
#import "TTProfileController.h"
#import "TTChatController.h"

static NSString *ID = @"Cell";

@interface TTSideController ()

@end

@implementation TTSideController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    self.tableView.bounces = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = @[@"主  页",@"发  布",@"足  迹",@"设  置",@"通  话"][indexPath.row];
    cell.textLabel.textColor = [UIColor purpleColor];
    cell.textLabel.font = [UIFont systemFontOfSize:24];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger which = indexPath.row;
    switch (which) {
        case 0:
            [self switchToViewController:[[TThomeController alloc] init]];
            break;
        case 1:
            [self switchToViewController:[[TTPublishController alloc] init]];
            break;
        case 2:
            [self switchToViewController:[[TTRecordController alloc] init]];
            break;
        case 3:
            [self switchToViewController:[[TTProfileController alloc] init]];
            break;
        case 4:
            [self switchToViewController:[[TTChatController alloc] init]];
            break;
            
        default:
            break;
    }
}

- (void)switchToViewController:(UIViewController*)viewController{
    
    
    [self.sideMenuViewController setContentViewController:[self setNavWrappViewController:viewController]];
    [self.sideMenuViewController hideMenuViewController];
    
}


- (UINavigationController *)setNavWrappViewController:(UIViewController*)viewController{
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar-sidebar"] style:UIBarButtonItemStylePlain target:self action:@selector(switchToSideMenu)];
    return nav;
}

- (void)switchToSideMenu{
    [self.sideMenuViewController presentLeftMenuViewController];
}


@end
