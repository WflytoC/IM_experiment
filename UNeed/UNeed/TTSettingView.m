//
//  TTSettingView.m
//  UNeed
//
//  Created by wcshinestar on 12/30/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//
#define kPadding 5
#define kTagBegin 1000
#import "TTSettingView.h"
#import "TTTools.h"
#import "UIView+Toast.h"

@interface TTSettingView()

@property(nonatomic,weak)UILabel *lab_distance,*lab_type;
@property(nonatomic,weak)UITextField *tf_distance;
@property(nonatomic,weak)UIButton *btn_command,*btn_service,*btn_all,*btn_finish;

@end

@implementation TTSettingView

NSInteger type = 0;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        //添加过滤距离
        UILabel *lab_distance = [[UILabel alloc] init];
        [self addSubview:lab_distance];
        self.lab_distance = lab_distance;
        self.lab_distance.text = @"过滤距离";
        
        UITextField *tf_distance = [[UITextField alloc] init];
        [self addSubview:tf_distance];
        self.tf_distance = tf_distance;
        self.tf_distance.backgroundColor = [UIColor whiteColor];
        
        
        //添加类型选择
        UILabel *lab_type = [[UILabel alloc] init];
        [self addSubview:lab_type];
        self.lab_type = lab_type;
        self.lab_type.text = @"类型选择";
        
        UIButton *btn_command = [[UIButton alloc] init];
        [self addSubview:btn_command];
        self.btn_command = btn_command;
        [self.btn_command setTitle:@"需求" forState:UIControlStateNormal];
        self.btn_command.tag = kTagBegin + 1;
        [self.btn_command addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn_command setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        UIButton *btn_service = [[UIButton alloc] init];
        [self addSubview:btn_service];
        self.btn_service = btn_service ;
        [self.btn_service setTitle:@"服务" forState:UIControlStateNormal];
        self.btn_service.tag = kTagBegin + 2;
        [self.btn_service addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn_all = [[UIButton alloc] init];
        [self addSubview:btn_all];
        self.btn_all = btn_all;
        [self.btn_all setTitle:@"全部" forState:UIControlStateNormal];
        self.btn_all.tag = kTagBegin + 3;
        [self.btn_all addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn_finish = [[UIButton alloc] init];
        [self addSubview:btn_finish];
        self.btn_finish = btn_finish;
        [self.btn_finish setTitle:@"完 成" forState:UIControlStateNormal];
        [self.btn_finish setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.btn_finish addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)layoutSubviews {
    
    CGFloat wAll = self.frame.size.width;
    CGFloat hAll = self.frame.size.height;
    CGFloat wSmall = (wAll - 3*kPadding)/4*1;
    CGFloat wBig = (wAll - 3*kPadding)/4*3;
    CGFloat hItem = (hAll - 4*kPadding)/3;
    
    CGFloat wBtn = (wBig - 2*kPadding)/3;
    
    self.lab_distance.frame = CGRectMake(kPadding, kPadding, wSmall, hItem);
    self.tf_distance.frame = CGRectMake(wSmall + 2*kPadding, kPadding, wBig, hItem);
    
    self.lab_type.frame = CGRectMake(kPadding, hItem + 2*kPadding, wSmall, hItem);
    
    self.btn_command.frame = CGRectMake(wSmall + 2*kPadding, hItem + 2*kPadding, wBtn, hItem);
    
    self.btn_command.layer.cornerRadius = kPadding;
    
    self.btn_service.frame = CGRectMake(wSmall + 3*kPadding  + wBtn, hItem + 2*kPadding, wBtn, hItem);
    self.btn_service.layer.cornerRadius = kPadding;
    
    self.btn_all.frame = CGRectMake(wSmall + 4*kPadding +  + wBtn * 2, hItem + 2 * kPadding, wBtn, hItem);
    self.btn_all.layer.cornerRadius = kPadding;
    
    self.btn_finish.frame = CGRectMake(kPadding, hItem * 2 + 3 * kPadding, wAll - 2*kPadding, hItem);
    

    
}

- (void)finishClick {
    
    if (![TTTools isPureFloat:self.tf_distance.text]) {
        [self makeToast:@"请输入数字"];
        return;
    }
    
    if ([self.tf_distance.text floatValue] <= 0.0) {
        [self makeToast:@"请输入大于0的数"];
        return;
    }
    
    if ([self.clickDelegate respondsToSelector:@selector(settingView:distance:type:)]) {
        [self.clickDelegate settingView:self distance:[self.tf_distance.text floatValue] type:type];
    }

}

- (void)chooseType:(id)sender {
    UIButton *targetBtn = (UIButton *)sender;
    NSInteger tag = targetBtn.tag;
    switch (tag) {
        case kTagBegin + 1:
            type = 0;
            //设置颜色
            [self.btn_command setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.btn_service setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.btn_all setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case kTagBegin + 2:
            type = 1;
            [self.btn_command setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.btn_service setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.btn_all setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case kTagBegin + 3:
            type = 2;
            [self.btn_command setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.btn_service setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.btn_all setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}




@end
