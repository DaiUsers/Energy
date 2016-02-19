//
//  DBManager.h
//  Energy
//
//  Created by qianfeng on 15/11/6.
//  Copyright (c) 2015年 wheng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"



@interface DBManager : NSObject {
    FMDatabase *_database;
}

+ (DBManager *)sharedManager;

//增加数据 
- (void)insertModel:(id)model recordType:(NSString *)type;

//删除指定的应用数据 根据指定的类型
- (void)deleteModelForDataId:(NSString *)dataId recordType:(NSString *)type;

//根据指定类型  查找所有的记录
//根据记录类型 查找 指定的记录
- (NSArray *)readModelsWithRecordType:(NSString *)type;

//根据指定的类型 返回 这条记录在数据库中是否存在
- (BOOL)isExistDataForDataId:(NSString *)dataId recordType:(NSString *)type;

@end
