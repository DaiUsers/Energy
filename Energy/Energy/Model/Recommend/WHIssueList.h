//
//  WHIssueList.h
//  Energy
//
//  Created by qianfeng on 15/11/5.
//  Copyright (c) 2015年 wheng. All rights reserved.
//

#import "JSONModel.h"
#import "WHItemList.h"

@protocol WHIssueList <NSObject>

@end

@interface WHIssueList : JSONModel

@property (nonatomic, assign) NSInteger date;
@property (nonatomic, assign) NSInteger publishTime;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy  ) NSString *type;

@property (nonatomic, strong) NSArray <WHItemList> *itemList;

@end
