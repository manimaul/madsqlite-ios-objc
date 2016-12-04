//
//  MadViewController.m
//  MadSqlite
//
//  Created by William Kamp on 12/01/2016.
//  Copyright (c) 2016 William Kamp. All rights reserved.
//

#import "MadViewController.h"
#import "MadSqliteFactory.hh"
#import "MadDatabase.h"

@interface MadViewController ()

@end

@implementation MadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    id <MADDatabase> md = [MADSqliteFactory inMemoryDatabase];
    [md exec:@"CREATE TABLE test(keyInt INTEGER);"];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
