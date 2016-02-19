//
//  DBManager.m
//  Energy
//
//  Created by qianfeng on 15/11/6.
//  Copyright (c) 2015年 wheng. All rights reserved.
//

#import "DBManager.h"
#import "WHData.h"

static DBManager *manager = nil;

@implementation DBManager

+ (DBManager *)sharedManager {
    @synchronized(self) {
        if (manager == nil) {
            manager = [[self alloc] init];
        }
    }
    return manager;
}

- (id)init {
    self = [super init];
    if (self) {
        NSString *filePath = [self getFileFullPathWithFileName:@"energy.db"];
        //创建database
        _database = [[FMDatabase alloc] initWithPath:filePath];
        //open (失败就会创建并且打开)
        if ([_database open]) {
            [self createTable];
        } else {
            NSLog(@"database open failed:%@",_database.lastErrorMessage);
        }
    }
    return self;
}

#pragma mark - 创建表

- (void)createTable {
    NSString *sql = @"create table if not exists itemData(serial integer Primary Key Autoincrement,\
    dataId     Varchar(1024),\
    title      Varchar(1024),\
    desc       Varchar(1024),\
    duration   varchar(1024),\
    category   Varchar(1024),\
    playUrl    Varchar(1024),\
    feed       Varchar(1024),\
    detail     Varchar(1024),\
    blurred    Varchar(1024),\
    recordType Varchar(1024)\
    )";
    //创建表 如果不存在则创建新的表
    BOOL isSuccess = [_database executeUpdate:sql];
    if (!isSuccess) {
        NSLog(@"creatTable error:%@",_database.lastErrorMessage);
    }
}

//获取文件在沙盒 Document中的全路径
- (NSString *)getFileFullPathWithFileName:(NSString *)fileName {
    NSString *docPath = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:docPath]) {
        return [docPath stringByAppendingFormat:@"/%@",fileName];
    } else {
        return nil;
    }
}
//增加数据
- (void)insertModel:(id)model recordType:(NSString *)type {
    WHData *dataModel = (WHData *)model;
    NSString *dataId = [NSString stringWithFormat:@"%ld",[dataModel.dataId integerValue]];
    if ([self isExistDataForDataId:dataId recordType:type]) {
        //已经存在
        return;
    }
    NSString *sql = @"insert into itemData(dataId,title,desc,duration,category,playUrl,feed,detail,blurred,recordType) values (?,?,?,?,?,?,?,?,?,?)";
    BOOL isSuccess = [_database executeUpdate:sql,dataId,dataModel.title,dataModel.desc,[dataModel.duration stringValue],dataModel.category,dataModel.playUrl,dataModel.cover.feed,dataModel.cover.detail,dataModel.cover.blurred,type];
    if (!isSuccess) {
        NSLog(@"insert error:%@",_database.lastErrorMessage);
    }
}
//删除指定的应用数据 根据指定的类型
- (void)deleteModelForDataId:(NSString *)dataId recordType:(NSString *)type {
    NSString *sql = @"delete from itemData where dataId = ? and recordType = ?";
    BOOL isSuccess = [_database executeUpdate:sql,dataId,type];
    if (!isSuccess) {
        NSLog(@"delete error:%@",_database.lastErrorMessage);
    }
}

//根据指定类型  查找所有的记录
//根据记录类型 查找 指定的记录
- (NSArray *)readModelsWithRecordType:(NSString *)type {
    NSString *sql = @"select * from itemData where recordType = ?";
    FMResultSet *set = [_database executeQuery:sql,type];
    NSMutableArray *temp = [NSMutableArray array];
    //遍历集合
    while ([set next]) {
        WHData *dataModel = [[WHData alloc] init];
        NSInteger num = [[set stringForColumn:@"dataId"] integerValue];
        dataModel.dataId = [[NSNumber alloc] initWithInteger:num];
        dataModel.title = [set stringForColumn:@"title"];
        dataModel.desc = [set stringForColumn:@"desc"];
        NSInteger time = [[set stringForColumn:@"duration"] integerValue];
        dataModel.duration = [[NSNumber alloc] initWithInteger:time];
        dataModel.category = [set stringForColumn:@"category"];
        dataModel.playUrl = [set stringForColumn:@"playUrl"];
        dataModel.feed = [set stringForColumn:@"feed"];
        dataModel.detail = [set stringForColumn:@"detail"];
        dataModel.blurred = [set stringForColumn:@"blurred"];
        NSLog(@"======%@",dataModel.feed);
        [temp addObject:dataModel];
    }
    return temp;
}

//根据指定的类型 返回 这条记录在数据库中是否存在
- (BOOL)isExistDataForDataId:(NSString *)dataId recordType:(NSString *)type {
    NSString *sql = @"select * from itemData where dataId = ? and recordType = ?";
    FMResultSet *set = [_database executeQuery:sql,dataId,type];
    if ([set next]) {//查看是否存在 下条记录 存在则有记录
        return YES;
    } else {
        return NO;
    }
}

@end
