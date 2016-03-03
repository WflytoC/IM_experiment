//
//  TTRootViewController.m
//  UNeed
//
//  Created by wcshinestar on 12/26/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import "TTRootViewController.h"
#import "TThomeController.h"
#import "TTSideController.h"

@interface TTRootViewController ()

@end

@implementation TTRootViewController

-(instancetype)init{
    self  = [super init];
    if (self != nil) {
        self.parallaxEnabled = NO;
        self.scaleContentView = YES;
        self.contentViewScaleValue = 0.95;
        self.scaleMenuView = NO;
        self.contentViewShadowEnabled = YES;
        TThomeController *home = [[TThomeController alloc] init];
        home.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar-sidebar"] style:UIBarButtonItemStylePlain target:self action:@selector(switchToSideMenu)];
        self.contentViewController = [[UINavigationController alloc] initWithRootViewController:home];
        self.leftMenuViewController = [[TTSideController alloc] init];
        
        
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
}

- (void)switchToSideMenu{
    [self presentLeftMenuViewController];
}


@end
