//
//  TTTools.h
//  UNeed
//
//  Created by wcshinestar on 12/26/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTTools : NSObject
//验证邮箱格式是否正确
+ (BOOL) validateEmail:(NSString *)email;
//获取和设置用户偏好设置
+ (NSString *)obtainInfo:(NSString *)key;
+ (void)setInfo:(NSString *)key value:(NSString *)value;
//判断字符串是否是浮点数
+ (BOOL)isPureFloat:(NSString *)string;

@end
