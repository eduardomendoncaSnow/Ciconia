//
//  CCNMigrationQueue.m
//  Ciconia
//
//  Created by Pietro Caselani on 1/11/16.
//  Copyright © 2016 Involves. All rights reserved.
//

#import "CCNMigrationQueue.h"

#import "CCNAbstractMigration.h"
#import "CIRResultSet.h"
#import "CIRStatement.h"

@interface CCNMigrationQueue ()

@property (strong, nonatomic) NSMutableDictionary<NSNumber *, Class> *migrations;

@end

@implementation CCNMigrationQueue

+ (instancetype)sharedQueue
{
	static CCNMigrationQueue *instance = nil;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		instance = [[CCNMigrationQueue alloc] init];
	});

	return instance;
}

- (instancetype)init
{
	if (self = [super init])
	{
		_migrations = [[NSMutableDictionary alloc] init];

		return self;
	}

	return nil;
}

- (void)execute:(CIRDatabase *)database
{
	[database executeUpdate:@"BEGIN"];
	[database executeUpdate:@"CREATE TABLE IF NOT EXISTS 'schema_migrations' ('version' INTEGER PRIMARY KEY)"];

	CIRResultSet *resultSet = [database executeQuery:@"SELECT version FROM schema_migrations"];

	while ([resultSet next])
		[_migrations removeObjectForKey:resultSet[0]];

	if ([_migrations count] > 0)
	{
		CIRStatement *statement = [database prepareStatement:@"INSERT INTO schema_migrations (version) VALUES (?)"];

		for (NSNumber *key in [[_migrations allKeys] sortedArrayUsingComparator:^(id obj1, id obj2) { return [obj1 compare:obj2]; }])
		{
			CCNAbstractMigration *migration = [[_migrations[key] alloc] init];
			migration.database = database;

			[migration run];

			[statement bindLongLong:[key longLongValue] atIndex:1];

			if ([statement step] != SQLITE_DONE)
				@throw [NSException exceptionWithName:@"Migration Versioning Exception" reason:[database lastErrorMessage] userInfo:nil];

			[statement reset];
		}

		[statement close];
	}

	[database executeUpdate:@"COMMIT"];
}

- (void)registerMigrationClass:(Class)migrationClass withVersion:(long long)version
{
	[_migrations setObject:migrationClass forKey:@(version)];
}

@end
