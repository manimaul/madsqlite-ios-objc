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

@interface MADsqliteFTS5Tests : XCTestCase

@end

@implementation MADsqliteFTS5Tests

- (void)testMatchNear {
 /*
        https://sqlite.org/fts5.html

        CREATE VIRTUAL TABLE f USING fts5(x);
        INSERT INTO f(rowid, x) VALUES(1, 'A B C D x x x E F x');

        ... MATCH 'NEAR(e d, 4)';                      -- Matches!
        ... MATCH 'NEAR(e d, 3)';                      -- Matches!
        ... MATCH 'NEAR(e d, 2)';                      -- Does not match!

        ... MATCH 'NEAR("c d" "e f", 3)';              -- Matches!
        ... MATCH 'NEAR("c"   "e f", 3)';              -- Does not match!

        ... MATCH 'NEAR(a d e, 6)';                    -- Matches!
        ... MATCH 'NEAR(a d e, 5)';                    -- Does not match!

        ... MATCH 'NEAR("a b c d" "b c" "e f", 4)';    -- Matches!
        ... MATCH 'NEAR("a b c d" "b c" "e f", 3)';    -- Does not match!
         */
    id <MADDatabase> md = [MADSqliteFactory inMemoryDatabase];
    [md exec:@"CREATE VIRTUAL TABLE f USING fts5(x);"];
    XCTAssertNil([md getError]);
    [md exec:@"INSERT INTO f(rowid, x) VALUES(1, 'A B C D x x x E F x');"];
    XCTAssertNil([md getError]);

    [self assertMatches:md withSql:@"SELECT * FROM f WHERE f MATCH 'NEAR(e d, 4)';"];
    [self assertMatches:md withSql:@"SELECT * FROM f WHERE f MATCH 'NEAR(e d, 3)';"];
    [self assertDoesNotMatch:md withSql:@"SELECT * FROM f WHERE f MATCH 'NEAR(e d, 2)';"];

    [self assertMatches:md withSql:@"SELECT * FROM f WHERE f MATCH 'NEAR(\"c d\" \"e f\", 3)';"];
    [self assertDoesNotMatch:md withSql:@"SELECT * FROM f WHERE f MATCH 'NEAR(\"c\" \"e f\", 3)';"];

    [self assertMatches:md withSql:@"SELECT * FROM f WHERE f MATCH 'NEAR(a d e, 6)';"];
    [self assertDoesNotMatch:md withSql:@"SELECT * FROM f WHERE f MATCH 'NEAR(a d e, 5)';"];

    [self assertMatches:md withSql:@"SELECT * FROM f WHERE f MATCH 'NEAR(\"a b c d\" \"b c\" \"e f\", 4)';"];
    [self assertDoesNotMatch:md withSql:@"SELECT * FROM f WHERE f MATCH 'NEAR(\"a b c d\" \"b c\" \"e f\", 3)';"];
}

- (void)assertDoesNotMatch:(id <MADDatabase>)md withSql:(NSString *)sql {
    XCTAssertTrue([self queryMatches:md withSql:sql].count == 0);
}

- (void)assertMatches:(id <MADDatabase>)md withSql:(NSString *)sql {
    XCTAssertTrue([self queryMatches:md withSql:sql].count > 0);
}

- (NSArray<NSString *> *)queryMatches:(id <MADDatabase>)md withSql:(NSString *)sql {
    id <MADQuery> query = [md query:sql];
    XCTAssertNil([md getError]);
    XCTAssertTrue([query moveToFirst]);
    NSMutableArray<NSString *> *rValue = [NSMutableArray new];
    while (![query isAfterLast]) {
        NSString *value = [query getString:0];
        if (value.length) {
            [rValue addObject:value];
        }
        [query moveToNext];
    }
    return rValue;
}

@end
