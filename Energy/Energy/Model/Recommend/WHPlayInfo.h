//
//  WHPlayInfo.h
//  Energy
//
//  Created by qianfeng on 15/11/5.
//  Copyright (c) 2015年 wheng. All rights reserved.
//

#import "JSONModel.h"

@protocol WHPlayInfo <NSObject>

@end

@interface WHPlayInfo : JSONModel

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger height;

@property (nonatomic, assign) NSInteger width;

@end
