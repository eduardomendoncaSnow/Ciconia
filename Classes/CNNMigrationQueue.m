//
//  CCNMigrationQueue.m
//  Ciconia
//
//  Created by Pietro Caselani on 1/11/16.
//  Copyright © 2016 Involves. All rights reserved.
//

#import "CCNMigrationQueue.h"

#import "CCNAbstractMigration.h"
#import "SQLDatabase.h"
#import "SQLResultSet.h"
#import "SQLStatement.h"

@interface CCNMigrationQueue ()

@property (strong, nonatomic) NSMutableDictionary<NSNumber*, Class>* migrations;

@end

@implementation CCNMigrationQueue

+ (instancetype)sharedQueue
{
	static CCNMigrationQueue* instance = nil;
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

- (void)execute:(SQLDatabase*)database
{
	[database executeUpdate:@"BEGIN"];
	[database executeUpdate:@"CREATE TABLE IF NOT EXISTS 'migrations_schema' ('version' INTEGER PRIMARY KEY)"];
	
	SQLResultSet* resultSet = [database executeQuery:@"SELECT version FROM migrations_schema"];
	
	while ([resultSet next]) [_migrations removeObjectForKey:@([resultSet longLongAtIndex:0])];
	
	if ([_migrations count] > 0)
	{
		SQLStatement* statement = [database prepareStatement:@"INSERT INTO migrations_schema (version) VALUES (?)"];
		
		for (NSNumber* key in [_migrations allKeys])
		{
			CCNAbstractMigration* migration = [[_migrations[key] alloc] init];
			[migration run:database];
			[statement bindLongLong:[key longLongValue] atIndex:1];
			
			if ([statement step] != SQLITE_DONE) @throw [NSException exceptionWithName:@"MigrationQueue" reason:[database lastErrorMessage] userInfo:nil];
			
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
