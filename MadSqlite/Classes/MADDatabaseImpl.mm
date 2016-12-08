//
// Created by William Kamp on 11/16/16.
// Copyright (c) 2016 William Kamp. All rights reserved.
//

#include "MadDatabase.hpp"
#import "MADDatabaseImpl.hh"
#import "MADContentValues.h"
#import "MADContentValuesImpl.hh"
#import "MADQueryImpl.hh"

@implementation MADDatabaseImpl

std::shared_ptr<madsqlite::MadDatabase> database;

- (instancetype)init {
    if (self = [super init]) {
        database = madsqlite::MadDatabase::openInMemoryDatabase();
        return self;
    } else {
        return nil;
    }
}

- (instancetype)initWithPath:(NSString *)path {
    if (self = [super init]) {
        database = madsqlite::MadDatabase::openDatabase(path.UTF8String);
        return self;
    } else {
        return nil;
    }
}

- (BOOL)insert:(NSString *)table withValues:(id <MADContentValues>)values {
    MADContentValuesImpl *impl = (MADContentValuesImpl *) values;
    return database->insert(table.UTF8String, *impl.getValues);
}

- (id <MADQuery>)query:(NSString *)sql {
    auto c = database->query(sql.UTF8String);
    MADQueryImpl *impl = [[MADQueryImpl alloc] initWithCursor:c];
    return impl;
}

- (id <MADQuery>)query:(NSString *)sql withArgs:(NSArray<NSString *> *)args {
    auto vec = std::vector<std::string>();
    for (NSString *arg in args) {
        vec.push_back(arg.UTF8String);
    }
    auto c = database->query(sql.UTF8String, vec);
    MADQueryImpl *impl = [[MADQueryImpl alloc] initWithCursor:c];
    return impl;
}

- (NSInteger)exec:(NSString *)sql {
    return database->exec(sql.UTF8String);
}

- (NSString *)getError {
    std::string err = database->getError();
    if (err.length()) {
        return [NSString stringWithUTF8String:err.c_str()];
    } else {
        return nil;
    }
}

- (void)beginTransaction {
    database->beginTransaction();
}

- (void)rollbackTransaction {
    database->rollbackTransaction();
}

- (void)commitTransaction {
    database->commitTransaction();
}

@end
