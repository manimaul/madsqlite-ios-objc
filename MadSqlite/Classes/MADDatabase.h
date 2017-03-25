//
// Created by William Kamp on 11/24/16.
// Copyright (c) 2016 William Kamp. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MADQuery;
@protocol MADContentValues;

@protocol MADDatabase <NSObject>

/**
 * Convenience method for inserting a row into the database.
 *
 * @param table the table to insert the row into.
 * @param values this map contains the initial column values for the row. The keys should be the column names and the
 * values the column values.
 * @return YES if the insert was successful.
 */
- (BOOL)insert:(NSString *)table withValues:(id <MADContentValues>)values;

/**
 * Query for results.
 *
 * @param sql - a sqlite query.
 * @return query results.
 */
- (id <MADQuery>)query:(NSString *)sql;

/**
 * Query for results with bound arguments.
 *
 * @param sql: - a sqlite query containing arguments.
 * @param args: You may include ?s in sql, which will be replaced by the values from args, in order that they appear in
 * the selection. The values will be bound as Strings.
 * @return query results.
 */
- (id <MADQuery>)query:(NSString *)sql withArgs:(NSArray<NSString *> *)args;

/**
 * Execute a single SQL statement that is NOT a SELECT or any other SQL statement that returns data.
 *
 * @param sql: the sql to execute.
 * @return the number of rows changed.
 */
- (NSInteger)exec:(NSString *)sql;

/**
 * Get English-language text that describes an error associated with the most recent database API call.
 *
 * @return the most recent error or nil.
 */
- (NSString *)getError;

/**
 * Begins a transaction. The changes will be rolled back if any transaction performed without being commited.
 */
- (void)beginTransaction;

/**
 * Rolls back a begun transaction.
 */
- (void)rollbackTransaction;

/**
 * Commits a begun transaction.
 */
- (void)commitTransaction;

@end
