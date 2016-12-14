//
//  AbstractMigrationTests.m
//  Ciconia
//
//  Created by Pietro Caselani on 12/14/16.
//  Copyright © 2016 Pietro Caselani. All rights reserved.
//

@import Kiwi;

#import <Ciconia/CCNAbstractMigration.h>
#import <Ciconia/CCNAbstractMigration_Protected.h>

@interface TestMigration : CCNAbstractMigration
@end

@implementation TestMigration
@end

SPEC_BEGIN(AbstractMigrationTests)

	describe(@"Migrations tests", ^{

		context(@"can manage the database,", ^{

			it(@"like create table", ^{
				TestMigration *migration = [[TestMigration alloc] init];
				NSString *sql = [migration createTable:@"people" withColumnsFromDictionary:@{
						@"id" : @"INTEGER PRIMARY KEY",
						@"firstName" : @"TEXT NOT NULL",
						@"lastName" : @"TEXT"
				}];

				[[sql should] equal:@"CREATE TABLE people (id INTEGER PRIMARY KEY, firstName TEXT NOT NULL, lastName TEXT)"];
			});

			it(@"like create table with constraints", ^{
				TestMigration *migration = [[TestMigration alloc] init];
				NSString *sql = [migration createTable:@"phones" withColumnsFromDictionary:@{
						@"id" : @"INTEGER NOT NULL",
						@"number" : @"TEXT NOT NULL",
						@"type" : @"TEXT DEFAULT Home"
				}                          constraints:@{
						@"PRIMARY KEY" : @"(id, number)"
				}];

				[[sql should] equal:@"CREATE TABLE phones (id INTEGER NOT NULL, number TEXT NOT NULL, type TEXT DEFAULT Home, PRIMARY KEY (id, number))"];
			});

			it(@"like add column", ^{
				TestMigration *migration = [[TestMigration alloc] init];
				NSString *sql = [migration addColumn:@"birth" ofType:@"DATETIME NOT NULL DEFAULT '1/1/1970'" toTable:@"people"];
				[[sql should] equal:@"ALTER TABLE people ADD COLUMN birth DATETIME NOT NULL DEFAULT '1/1/1970'"];
			});

		});

	});

SPEC_END
