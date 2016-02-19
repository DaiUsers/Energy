//
//  WHConsumption.h
//  Energy
//
//  Created by qianfeng on 15/11/5.
//  Copyright (c) 2015年 wheng. All rights reserved.
//

#import "JSONModel.h"

@interface WHConsumption : JSONModel

@property (nonatomic, assign) NSInteger collectionCount;

@property (nonatomic, assign) NSInteger shareCount;

@property (nonatomic, assign) NSInteger replyCount;

@property (nonatomic, assign) NSInteger playCount;

@end
