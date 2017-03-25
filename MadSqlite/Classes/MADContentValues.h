//
// Created by William Kamp on 11/17/16.
// Copyright (c) 2016 William Kamp. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MADContentValues

/**
 * Adds a value to the set.
 *
 * @param key: the name of the value to put.
 * @param value: the data for the value to put.
 */
- (void)putInteger:(NSString *)key withValue:(NSNumber *)value;

/**
 * Adds a value to the set.
 *
 * @param key: the name of the value to put.
 * @param value: the data for the value to put.
 */
- (void)putReal:(NSString *)key withValue:(NSNumber *)value;

/**
 * Adds a value to the set.
 *
 * @param key: the name of the value to put.
 * @param value: the data for the value to put.
 */
- (void)putString:(NSString *)key withValue:(NSString *)value;

/**
 * Adds a value to the set.
 *
 * @param key: the name of the value to put.
 * @param value: the data for the value to put.
 */
- (void)putBlob:(NSString *)key withValue:(NSData *)value;

/**
 * Removes all values.
 */
- (void)clear;

@end
