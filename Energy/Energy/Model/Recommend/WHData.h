//
//  WHData.h
//  Energy
//
//  Created by qianfeng on 15/11/5.
//  Copyright (c) 2015年 wheng. All rights reserved.
//

#import "JSONModel.h"

#import "WHCover.h"
#import "WHWebUrl.h"
#import "WHPlayInfo.h"
#import "WHProvider.h"
#import "WHConsumption.h"

#import "JSONKeyMapper.h"

@interface WHData : JSONModel

@property (nonatomic, strong) NSNumber <Optional> *dataId;
@property (nonatomic, strong) NSNumber <Optional> *date;
@property (nonatomic, strong) NSNumber <Optional> *duration;

@property (nonatomic, copy) NSString <Optional> *text;

@property (nonatomic, copy) NSString <Optional> *title;
@property (nonatomic, copy) NSString <Optional> *desc;
@property (nonatomic, copy) NSString <Optional> *category;
@property (nonatomic, copy) NSString <Optional> *playUrl;
@property (nonatomic, copy) NSString <Optional> *campaign;

@property (nonatomic, strong) WHCover <Optional> *cover;
@property (nonatomic, strong) WHWebUrl <Optional> *webUrl;
@property (nonatomic, strong) WHProvider <Optional> *provider;
@property (nonatomic, strong) WHConsumption <Optional> *consumption;
@property (nonatomic, strong) NSArray <WHPlayInfo,Optional> *playInfo;


//数据库
@property (nonatomic, copy) NSString <Optional> *feed;
@property (nonatomic, copy) NSString <Optional> *detail;
@property (nonatomic, copy) NSString <Optional> *blurred;

@end
