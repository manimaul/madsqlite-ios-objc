//
//  MadViewController.m
//  MadSqlite
//
//  Created by William Kamp on 12/01/2016.
//  Copyright (c) 2016 William Kamp. All rights reserved.
//

#import "MadViewController.h"
#import "MADSqliteFactory.hh"
#import "MADContentValues.h"
#import "MADQuery.h"
#import "MADDatabase.h"

@interface MadViewController ()

@end

@implementation MadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Open / create database
    id <MADDatabase> md = [MADSqliteFactory databaseNamed:@"mydb"];
    [md exec:@"CREATE TABLE location_table(name TEXT, latitude REAL, longitude REAL, image BLOB);"];
    
    // Insert into database
    id <MADContentValues> cv = [MADSqliteFactory contentValues];
    [cv putString:@"name" withValue:@"Cheshire Cat"];
    [cv putReal:@"latitude" withValue:@(51.2414945)];
    [cv putReal:@"longitude" withValue:@(-0.6354629)];
    NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"Chshire Cat"]);
    [cv putBlob:@"image" withValue:data];
    [md insert:@"location_table" withValues:cv];
    
    // Query database
    id <MADQuery> query = [md query:@"SELECT name, latitude, longitude FROM location_table WHERE name=?" withArgs:@[@"Cheshire Cat"]];
    if ([query moveToFirst]) {
        while (![query isAfterLast]) {
            NSString *name = [query getString:0];
            NSNumber *latitude = [query getReal:1];
            NSNumber *longitude = [query getReal:2];
            NSLog(@"name:%@ latitude:%@ longitude:%@", name, latitude, longitude);
            [query moveToNext];
        }
    }
	
    /*
     
     // Query database
     auto qry = db->query("SELECT name, latitude, longitude FROM location_table WHERE name=?", {"Cheshire Cat"});
     qry.moveToFirst();
     while (!qry.isAfterLast()) {
     auto name = qry.getString(0);
     double latitude = qry.getReal(1);
     double longitude = qry.getReal(2);
     std::cout << name << " latitude:" << latitude << " longitude:" << longitude << std::endl;
     qry.moveToNext();
     }
     */
    
}

@end
