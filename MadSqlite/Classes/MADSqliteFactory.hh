//
// Created by William Kamp on 11/24/16.
// Copyright (c) 2016 William Kamp. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MADContentValues;
@protocol MADDatabase;


@interface MADSqliteFactory : NSObject

/**
 * @return a new content-value container useful for inserting into a @see MadDatabase#insert: withValues:
 */
+ (id <MADContentValues>)contentValues;

/**
 * @return a new in-memory sqlite database.
 */
+ (id <MADDatabase>)inMemoryDatabase;

/**
 * Opens or creates a file system sqlite database.
 *
 * @param name the name of the database
 * @return a file system sqlite database
 */
+ (id <MADDatabase>)databaseNamed:(NSString *)name;

@end
