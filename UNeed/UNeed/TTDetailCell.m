//
//  TTDetailCell.m
//  UNeed
//
//  Created by wcshinestar on 12/31/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//
#define kItemHeight 32
#define kBtnWidth 64
#import "TTDetailCell.h"
#import "TTGlobals.h"
#import "TTDetail.h"

@interface TTDetailCell()

@property(nonatomic,weak)UILabel* detail_info;
@property(nonatomic,weak)UILabel* detail_location;
@property(nonatomic,weak)UILabel* detail_locationA;
@property(nonatomic,weak)UILabel* detail_distance;
@property(nonatomic,weak)UIButton* detail_watch;

@end

@implementation TTDetailCell

-  (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //需求信息
        UILabel *detail_info = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 * kItemHeight, tWidth, kItemHeight)];
        [self addSubview:detail_info];
        self.detail_info = detail_info;
        //手写位置
        UILabel *detail_location = [[UILabel alloc] initWithFrame:CGRectMake(0, 1 * kItemHeight, tWidth, kItemHeight)];
        [self addSubview:detail_location];
        self.detail_location = detail_location;
        //定位位置
        UILabel *detail_locationA = [[UILabel alloc] initWithFrame:CGRectMake(0, 2 * kItemHeight, tWidth, kItemHeight)];
        [self addSubview:detail_locationA];
        self.detail_locationA = detail_locationA;
        //距离当前位置
        UILabel *detail_distance = [[UILabel alloc] initWithFrame:CGRectMake(0, 3 * kItemHeight, tWidth - kBtnWidth, kItemHeight)];
        [self addSubview:detail_distance];
        self.detail_distance = detail_distance;
        
        //详情按钮
        UIButton *detail_watch = [[UIButton alloc] initWithFrame:CGRectMake(tWidth - kBtnWidth, 3 * kItemHeight, kBtnWidth, kItemHeight)];
        [self addSubview:detail_watch];
        self.detail_watch = detail_watch;
        [self.detail_watch setTitle:@"详情" forState:UIControlStateNormal];
        [self.detail_watch setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.detail_watch addTarget:self action:@selector(clickDetail) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


- (void)setDetail:(TTDetail *)detail {
    _detail = detail;
    NSString *info = (detail.detail_type == 0) ? @"需求" : @"服务";
    self.detail_info.text = [NSString stringWithFormat:@" %@：%@",info,detail.detail_info];
    self.detail_location.text = [NSString stringWithFormat:@" 手写的位置：%@",detail.detail_location];
    self.detail_locationA.text = [NSString stringWithFormat:@" 定位的位置：%@",detail.detail_locationA];
    self.detail_distance.text = [NSString stringWithFormat:@" 距离当前的位置%f米",detail.detail_distance];
}

- (void)clickDetail {
    if ([self.clickDelegate respondsToSelector:@selector(DetailBtnClick:)]) {
        [self.clickDelegate DetailBtnClick:self];
    }
}


@end
