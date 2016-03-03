//
//  TTTools.m
//  UNeed
//
//  Created by wcshinestar on 12/26/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import "TTTools.h"

@implementation TTTools

+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (NSString *)obtainInfo:(NSString *)key {
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    return [users objectForKey:key];
}

+ (void)setInfo:(NSString *)key value:(NSString *)value{
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    [users setObject:value forKey:key];
}


+ (BOOL)isPureFloat:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}


@end
