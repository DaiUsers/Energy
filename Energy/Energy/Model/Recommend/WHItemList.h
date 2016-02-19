//
//  WHItemList.h
//  Energy
//
//  Created by qianfeng on 15/11/5.
//  Copyright (c) 2015年 wheng. All rights reserved.
//

#import "JSONModel.h"
#import "WHData.h"

@protocol WHItemList <NSObject>

@end

@interface WHItemList : JSONModel

@property (nonatomic, copy  ) NSString *type;

@property (nonatomic, strong) WHData *data;


@end
