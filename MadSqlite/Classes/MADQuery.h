//
//  MadQuery.h
//  MadSqlite
//
//  Created by William Kamp on 11/16/16.
//  Copyright © 2016 William Kamp. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MADQuery

@required

/**
 * Move the query to the first row.
 * @return NO if the query is empty.
 */
- (BOOL)moveToFirst;

/**
 * Move the query to the next row.
 * @return NO if the query is already past the last entry in the result set.
 */
- (BOOL)moveToNext;

/**
 * @return Returns whether the query is pointing to the position after the last row.
 */
- (BOOL)isAfterLast;

/**
 * @param columnIndex: the zero-based index of the target column.
 * @return the value of that column as a String.
 */
- (NSString *)getString:(int)columnIndex;

/**
 * @param columnIndex: the zero-based index of the target column.
 * @return the value of that column as data.
 */
- (NSData *)getBlob:(int)columnIndex;

/**
 * @param columnIndex: the zero-based index of the target column.
 * @return the value of that column a long long integer.
 */
- (NSNumber *)getInt:(int)columnIndex;

/**
 * @param columnIndex: the zero-based index of the target column.
 * @return the value of that column as a double.
 */
- (NSNumber *)getReal:(int)columnIndex;

@end
