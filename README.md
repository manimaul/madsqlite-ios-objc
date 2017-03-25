# MadSqlite iOS Objective-C Framework

[![Build Status](https://travis-ci.org/manimaul/madsqlite-ios-objc.svg?branch=master)](https://travis-ci.org/manimaul/madsqlite-ios-objc)

 * A simple [Sqlite](https://sqlite.org) abstraction
 * [FTS5](https://sqlite.org/fts5.html) and [RTree](https://www.sqlite.org/rtree.html) extension modules enabled
 * [BSD License](LICENSE.md)


MadSqlite is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MadSqlite', '~> 0.2.2'
```
or bleeding edge:
```ruby
pod 'MadSqlite', :git => 'https://github.com/manimaul/madsqlite-ios-objc.git', :tag => '0.2.2', :submodules => true
```

####Example

```objective-c
// Open / create database
id <MADDatabase> md = [MADSqliteFactory databaseNamed:@"mydb"];
[md exec:@"CREATE TABLE location_table(name TEXT, latitude REAL, longitude REAL, image BLOB);"];

// Insert into database
id <MADContentValues> cv = [MADSqliteFactory contentValues];
[cv putString:@"name" withValue:@"Cheshire Cat"];
[cv putReal:@"latitude" withValue:@(51.2414945)];
[cv putReal:@"longitude" withValue:@(-0.6354629)];
NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"Cheshire Cat"]);
[cv putBlob:@"image" withValue:data];
[md insert:@"location_table" withValues:cv];

// Query database
id <MADQuery> query = [md query:@"SELECT name, latitude, longitude FROM location_table WHERE name=?"
                       withArgs:@[@"Cheshire Cat"]];
if ([query moveToFirst]) {
    while (![query isAfterLast]) {
        NSString *name = [query getString:0];
        NSNumber *latitude = [query getReal:1];
        NSNumber *longitude = [query getReal:2];
        NSLog(@"name:%@ latitude:%@ longitude:%@", name, latitude, longitude);
        [query moveToNext];
    }
}
```
