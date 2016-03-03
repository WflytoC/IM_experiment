//
//  TTDetail.h
//  UNeed
//
//  Created by wcshinestar on 12/31/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TTDetail : NSObject

@property(nonatomic,assign)CGFloat detail_distance;
@property(nonatomic,assign)NSInteger detail_type;
@property(nonatomic,strong)NSString* detail_location;
@property(nonatomic,strong)NSString* detail_locationA;
@property(nonatomic,strong)NSString* detail_info;
@property(nonatomic,strong)NSString* detail_email;


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)detailWithDict:(NSDictionary *)dict;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
