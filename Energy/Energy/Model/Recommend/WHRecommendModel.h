//
//  WHRecommendModel.h
//  Energy
//
//  Created by qianfeng on 15/11/5.
//  Copyright (c) 2015年 wheng. All rights reserved.
//

#import "JSONModel.h"
#import "WHIssueList.h"

@interface WHRecommendModel : JSONModel

@property (nonatomic, strong) NSArray <WHIssueList> *issueList;

@property (nonatomic, copy  ) NSString *nextPageUrl;
@property (nonatomic, assign) NSInteger nextPublishTime;

@end
