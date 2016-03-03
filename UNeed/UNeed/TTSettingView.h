//
//  TTSettingView.h
//  UNeed
//
//  Created by wcshinestar on 12/30/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTSettingView;
@protocol settingViewDelegate <NSObject>

- (void)settingView:(TTSettingView *)settingView distance:(CGFloat)distance type:(NSInteger)type;

@end

@interface TTSettingView : UIView

@property(nonatomic,weak)id<settingViewDelegate> clickDelegate;

@end
