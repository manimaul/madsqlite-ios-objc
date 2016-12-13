//
// Created by William Kamp on 11/16/16.
// Copyright (c) 2016 William Kamp. All rights reserved.
//

#import "MADQueryImpl.hh"


@implementation MADQueryImpl {
    std::unique_ptr<madsqlite::MadQuery> curs;
}

-(instancetype) initWithCursor:(madsqlite::MadQuery &)query {
    if (self == [super init]) {
        curs = std::make_unique<madsqlite::MadQuery>(std::move(query));
        return self;
    } else {
        return nil;
    }
}

- (BOOL)moveToFirst {
    return curs->moveToFirst();
}

- (BOOL)moveToNext {
    return curs->moveToNext();
}

- (BOOL)isAfterLast {
    return curs->isAfterLast();
}

- (NSString *)getString:(int)columnIndex {
    std::string val = curs->getString(columnIndex);
    return [NSString stringWithUTF8String:val.c_str()];
}

- (NSData *)getBlob:(int)columnIndex {
    std::vector<unsigned char> blob = curs->getBlob(columnIndex);
    return [NSData dataWithBytes:blob.data() length:blob.size()];
}

- (NSNumber *)getInt:(int)columnIndex {
    return @(curs->getInt(columnIndex));
}

- (NSNumber *)getReal:(int)columnIndex {
    return @(curs->getReal(columnIndex));
}

@end
