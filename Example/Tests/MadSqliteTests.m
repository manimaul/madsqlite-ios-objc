//
//  MADsqliteTests.m
//  MADsqliteTests
//
//  Created by William Kamp on 11/27/16.
//  Copyright © 2016 William Kamp. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MADSqliteFactory.hh"
#import "MADDatabase.h"
#import "MADContentValues.h"
#import "MADQuery.h"

@interface MADSqliteTests : XCTestCase

@end

@implementation MADSqliteTests

- (void)testInsertInteger {
    id <MADDatabase> md = [MADSqliteFactory inMemoryDatabase];
    [md exec:@"CREATE TABLE test(keyInt INTEGER);"];
    XCTAssertNil([md getError]);

    id <MADContentValues> cv = [MADSqliteFactory contentValues];
    [cv putInteger:@"keyInt" withValue:@(NSUIntegerMax)];
    [md insert:@"test" withValues:cv];
    XCTAssertNil([md getError]);

    [cv clear];
    [cv putInteger:@"keyInt" withValue:@(NSIntegerMin)];
    [md insert:@"test" withValues:cv];
    XCTAssertNil([md getError]);

    id <MADQuery> query = [md query:@"SELECT keyInt FROM test;"];
    XCTAssertTrue([query moveToFirst]);
    XCTAssertFalse([query isAfterLast]);
    NSNumber *firstResult = [query getInt:0];
    XCTAssertEqual(NSUIntegerMax, firstResult.integerValue);

    XCTAssertTrue([query moveToNext]);
    XCTAssertFalse([query isAfterLast]);
    NSNumber *secondResult = [query getInt:0];
    XCTAssertEqual(NSIntegerMin, secondResult.integerValue);
    XCTAssertTrue([query moveToNext]);
    XCTAssertTrue([query isAfterLast]);
}

- (void)testInsertReal {
    id <MADDatabase> md = [MADSqliteFactory inMemoryDatabase];

    [md exec:@"CREATE TABLE test(keyReal REAL);"];
    XCTAssertNil([md getError]);

    id <MADContentValues> cv = [MADSqliteFactory contentValues];
    [cv putReal:@"keyReal" withValue:@(DBL_MAX)];
    [md insert:@"test" withValues:cv];
    XCTAssertNil([md getError]);

    [cv clear];
    [cv putReal:@"keyReal" withValue:@(DBL_MIN)];
    [md insert:@"test" withValues:cv];
    XCTAssertNil([md getError]);

    id <MADQuery> query = [md query:@"SELECT keyReal FROM test;"];
    XCTAssertTrue([query moveToFirst]);
    XCTAssertFalse([query isAfterLast]);
    NSNumber *firstResult = [query getReal:0];

    XCTAssertTrue([query moveToNext]);
    XCTAssertFalse([query isAfterLast]);
    NSNumber *secondResult = [query getReal:0];

    XCTAssertTrue([query moveToNext]);
    XCTAssertTrue([query isAfterLast]);
    XCTAssertFalse([query moveToNext]);

    XCTAssertTrue(DBL_MAX == firstResult.doubleValue);
    XCTAssertTrue(DBL_MIN == secondResult.doubleValue);
}

- (void)testInsertBlob {
    id <MADDatabase> md = [MADSqliteFactory inMemoryDatabase];
    [md exec:@"CREATE TABLE test(keyBlob BLOB);"];
    XCTAssertNil([md getError]);

    id <MADContentValues> cv = [MADSqliteFactory contentValues];
    NSString *d = @"data";
    NSData *data = [NSData dataWithBytes:d.UTF8String length:d.length];
    [cv putBlob:@"keyBlob" withValue:data];
    XCTAssertNil([md getError]);

    [md insert:@"test" withValues:cv];
    XCTAssertNil([md getError]);

    id <MADQuery> query = [md query:@"SELECT keyBlob FROM test;"];
    XCTAssertTrue([query moveToFirst]);
    XCTAssertFalse([query isAfterLast]);
    NSData *blobResult = [query getBlob:0];
    NSString *strResult = [query getString:0];

    XCTAssertTrue([query moveToNext]);
    XCTAssertTrue([query isAfterLast]);
    XCTAssertFalse([query moveToNext]);

    XCTAssertEqualObjects(d, [[NSString alloc] initWithData:blobResult encoding:NSUTF8StringEncoding]);
    XCTAssertEqualObjects(d, strResult);
}

- (void)testInsertText {
    id <MADDatabase> md = [MADSqliteFactory inMemoryDatabase];
    [md exec:@"CREATE TABLE test(keyText TEXT);"];
    XCTAssertNil([md getError]);

    id <MADContentValues> cv = [MADSqliteFactory contentValues];
    NSString *text = @"the quick brown fox jumped over the lazy dog!";
    [cv putString:@"keyText" withValue:text];
    XCTAssertNil([md getError]);

    XCTAssertTrue([md insert:@"test" withValues:cv]);
    XCTAssertNil([md getError]);

    id <MADQuery> query = [md query:@"SELECT keyText FROM test;"];
    XCTAssertTrue([query moveToFirst]);
    XCTAssertFalse([query isAfterLast]);
    NSString *strResult = [query getString:0];

    XCTAssertTrue([query moveToNext]);
    XCTAssertTrue([query isAfterLast]);
    XCTAssertFalse([query moveToNext]);

    XCTAssertEqualObjects(text, strResult);
}

- (void)testQueryArgs {
    id <MADDatabase> md = [MADSqliteFactory inMemoryDatabase];
    [md exec:@"CREATE TABLE test(keyInt INTEGER, keyText TEXT);"];
    XCTAssertNil([md getError]);

    id <MADContentValues> cv = [MADSqliteFactory contentValues];
    [cv putString:@"keyText" withValue:@"the quick brown fox"];
    [cv putInteger:@"keyInt" withValue:@(99)];
    XCTAssertTrue([md insert:@"test" withValues:cv]);
    XCTAssertNil([md getError]);

    [cv clear];
    [cv putString:@"keyText" withValue:@"the slow white tortoise"];
    [cv putInteger:@"keyInt" withValue:@(34)];
    XCTAssertTrue([md insert:@"test" withValues:cv]);
    XCTAssertNil([md getError]);

    id <MADQuery> query = [md query:@"SELECT keyText,keyInt FROM test WHERE keyInt is ?;" withArgs:@[@"99"]];
    XCTAssertNil([md getError]);
    XCTAssertTrue([query moveToFirst]);
    XCTAssertFalse([query isAfterLast]);
    NSString *value = [query getString:0];
    NSNumber *number = [query getReal:1];
    XCTAssertTrue([query moveToNext]);
    XCTAssertTrue([query isAfterLast]);

    XCTAssertEqual(99, number.integerValue);
    XCTAssertEqualObjects(@"the quick brown fox", value);

    query = [md query:@"SELECT keyText,keyInt FROM test WHERE keyInt is ?;" withArgs:@[@"34"]];
    XCTAssertNil([md getError]);
    XCTAssertTrue([query moveToFirst]);
    XCTAssertFalse([query isAfterLast]);
    NSString *value2 = [query getString:0];
    NSNumber *number2 = [query getReal:1];
    XCTAssertTrue([query moveToNext]);
    XCTAssertTrue([query isAfterLast]);

    XCTAssertEqual(34, number2.integerValue);
    XCTAssertEqualObjects(@"the slow white tortoise", value2);
}

- (void)testMultiIndexQuery {
    id<MADDatabase> md = [MADSqliteFactory inMemoryDatabase];
    [md exec:@"CREATE TABLE test(keyInt INTEGER, keyReal REAL, keyText TEXT);"];
    [self multiIndexQuery:md];
    XCTAssertNil([md getError]);
}

- (void)testFileSystemDatabaseNamed {
    // ~/Library/Developer/CoreSimulator/Devices/ED77F264-2FF3-4DBF-A2F6-F8CBC2D6EE15/data/Library/test.s3db
    id <MADDatabase> md = [MADSqliteFactory databaseNamed:@"test.s3db"];
    [md exec:@"DROP TABLE IF EXISTS test"];
    XCTAssertNil([md getError]);
    [md exec:@"CREATE TABLE test(keyInt INTEGER, keyReal REAL, keyText TEXT);"];
    XCTAssertNil([md getError]);

    [self multiIndexQuery:md];
}

- (void)testFileSystemDatabasePath {
    NSMutableString *mutableString = [NSMutableString stringWithString:
                                      [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    [mutableString appendString:@"/"];
    [mutableString appendString:@"test.s3db"];
    
    // ~/Library/Developer/CoreSimulator/Devices/ED77F264-2FF3-4DBF-A2F6-F8CBC2D6EE15/data/Library/test.s3db
    id <MADDatabase> md = [MADSqliteFactory databaseWithPath:mutableString];
    [md exec:@"DROP TABLE IF EXISTS test"];
    XCTAssertNil([md getError]);
    [md exec:@"CREATE TABLE test(keyInt INTEGER, keyReal REAL, keyText TEXT);"];
    XCTAssertNil([md getError]);
    
    [self multiIndexQuery:md];
}

- (void)testFileSystemDatabasePathDoesNotExist {
    id <MADDatabase> md = [MADSqliteFactory databaseWithPath:@"/some/nonexistent/path.s3db"];
    XCTAssertNil(md);
}

- (void)multiIndexQuery:(id <MADDatabase>)md {
    id <MADContentValues> cv = [MADSqliteFactory contentValues];
    [cv putString:@"keyText" withValue:@"the quick brown fox"];
    [cv putInteger:@"keyInt" withValue:@(99)];
    [cv putReal:@"keyReal" withValue:@(23829.3)];
    XCTAssertTrue([md insert:@"test" withValues:cv]);
    XCTAssertNil([md getError]);

    [cv clear];
    [cv putString:@"keyText" withValue:@"the slow red tortoise"];
    [cv putInteger:@"keyInt" withValue:@(42)];
    [cv putReal:@"keyReal" withValue:@(3829.3)];
    XCTAssertNil([md getError]);
    XCTAssertTrue([md insert:@"test" withValues:cv]);

    id <MADQuery> query = [md query:@"SELECT * FROM test;"];
    XCTAssertNil([md getError]);

    XCTAssertTrue([query moveToFirst]);
    XCTAssertEqual(23829.3, [query getReal:1].doubleValue);
    XCTAssertEqualObjects(@"the quick brown fox", [query getString:2]);
    XCTAssertEqual(99, [query getInt:0].integerValue);
    XCTAssertFalse([query isAfterLast]);

    XCTAssertTrue([query moveToNext]);
    XCTAssertFalse([query isAfterLast]);
    XCTAssertEqual(3829.3, [query getReal:1].doubleValue);
    XCTAssertEqualObjects(@"the slow red tortoise", [query getString:2]);
    XCTAssertEqual(42, [query getInt:0].integerValue);
    XCTAssertFalse([query isAfterLast]);

    XCTAssertTrue([query moveToNext]);
    XCTAssertFalse([query moveToNext]);
    XCTAssertTrue([query isAfterLast]);
}

@end
