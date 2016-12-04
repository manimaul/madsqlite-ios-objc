//
// Created by William Kamp on 11/17/16.
// Copyright (c) 2016 William Kamp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MADContentValues.h"
#import "ContentValues.hpp"


@interface MADContentValuesImpl : NSObject <MADContentValues>

- (instancetype)init;

- (std::shared_ptr<ContentValues>)getValues;

@end
