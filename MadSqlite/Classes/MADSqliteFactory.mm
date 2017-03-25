//
// Created by William Kamp on 11/24/16.
// Copyright (c) 2016 William Kamp. All rights reserved.
//

#import "MADSqliteFactory.hh"
#import "MADContentValues.h"
#import "MADContentValuesImpl.hh"
#import "MADDatabase.h"
#import "MADDatabaseImpl.hh"


@implementation MADSqliteFactory

+ (id <MADContentValues>)contentValues {
    MADContentValuesImpl *values = [[MADContentValuesImpl alloc] init];
    return values;
}

+ (id <MADDatabase>)inMemoryDatabase {
    MADDatabaseImpl *db = [[MADDatabaseImpl alloc] init];
    return db;
}

+ (id <MADDatabase>)databaseNamed:(NSString *)name {
    NSMutableString *mutableString = [NSMutableString stringWithString:
            [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    [mutableString appendString:@"/"];
    [mutableString appendString:name];
    MADDatabaseImpl *db = [[MADDatabaseImpl alloc] initWithPath:mutableString];
    return db;
}

+ (id <MADDatabase>)databaseWithPath:(NSString *)path {
    MADDatabaseImpl *db = [[MADDatabaseImpl alloc] initWithPath:path];
    if ([db getError]) {
        return nil;
    }
    return db;
}


@end
