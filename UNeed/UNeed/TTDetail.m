//
//  TTDetail.m
//  UNeed
//
//  Created by wcshinestar on 12/31/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import "TTDetail.h"

@implementation TTDetail

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)detailWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
