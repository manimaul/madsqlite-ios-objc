//
// Created by William Kamp on 11/17/16.
// Copyright (c) 2016 William Kamp. All rights reserved.
//

#import "MadContentValuesImpl.hh"

@implementation MADContentValuesImpl {
    std::shared_ptr<madsqlite::MadContentValues> contentValues;
}

- (instancetype)init {
    if (self = [super init]) {
        contentValues = std::shared_ptr<madsqlite::MadContentValues>(new madsqlite::MadContentValues());
        return self;
    } else {
        return nil;
    }
}

- (void)putInteger:(NSString *)key withValue:(NSNumber *)value {
    contentValues->putInteger(key.UTF8String, value.longLongValue);
}

- (void)putReal:(NSString *)key withValue:(NSNumber *)value {
    contentValues->putReal(key.UTF8String, value.doubleValue);
}

- (void)putString:(NSString *)key withValue:(NSString *)value {
    contentValues->putString(key.UTF8String, value.UTF8String);
}

- (void)putBlob:(NSString *)key withValue:(NSData *)value {
    unsigned char *charBuf = (unsigned char *) value.bytes;
    std::vector<unsigned char> valVec(charBuf, charBuf + value.length);
    contentValues->putBlob(key.UTF8String, valVec);
}

- (void)clear {
    contentValues->clear();
}

- (std::shared_ptr<madsqlite::MadContentValues>)getValues {
    return contentValues;
}

@end
