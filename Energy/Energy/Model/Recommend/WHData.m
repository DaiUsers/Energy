//
//  WHData.m
//  Energy
//
//  Created by qianfeng on 15/11/5.
//  Copyright (c) 2015年 wheng. All rights reserved.
//

#import "WHData.h"

@implementation WHData

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"dataId",@"description":@"desc"}];
}

@end
