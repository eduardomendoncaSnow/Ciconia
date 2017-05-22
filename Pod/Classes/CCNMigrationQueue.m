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

- (nullable NSNumber *)checkForExecutions:(nonnull CIRDatabase *)database error:(NSError *_Nullable *_Nullable)error
{
	return @([[self executionsCountForDatabase:database error:error] intValue] > 0);
}

- (nullable NSNumber *)executionsCountForDatabase:(nonnull CIRDatabase *)database error:(NSError *_Nullable *_Nullable)error
{
	if (![database executeUpdate:@"CREATE TABLE IF NOT EXISTS 'schema_migrations' ('version' INTEGER PRIMARY KEY)" error:error])
		return nil;

	NSUInteger count = 0;

	CIRResultSet *resultSet = [database executeQuery:[NSString stringWithFormat:@"SELECT COUNT(version) FROM schema_migrations"] error:error];
	if ([resultSet next:error])
		count = (NSUInteger) [resultSet intAtIndex:0];
	
	if (error != NULL && *error)
		return nil;

	return @(_migrations.count - count);
}

- (BOOL)execute:(CIRDatabase *)database error:(NSError *_Nullable *_Nullable)error
{
	return [self execute:database progress:nil error:error];
}

- (BOOL)execute:(CIRDatabase *)database progress:(void (^)(CCNAbstractMigration *, uint64_t, uint64_t))progress error:(NSError *_Nullable *_Nullable)error;
{
	NSInteger executionsCount = [[self executionsCountForDatabase:database error:error] integerValue];
	
	if (executionsCount == -1)
		return NO;

	if (![database executeUpdate:@"BEGIN" error:error])
		return NO;

	CIRResultSet *resultSet = [database executeQuery:@"SELECT version FROM schema_migrations" error:error];

	if (error != NULL && *error)
		return NO;

	uint64_t index = 0;

	while ([resultSet next:error])
		[_migrations removeObjectForKey:resultSet[0]];

	if (error != NULL && *error)
		return NO;

	if ([_migrations count] > 0)
	{
		CIRStatement *statement = [database prepareStatement:@"INSERT INTO schema_migrations (version) VALUES (?)" error:error];

		if (error != NULL && *error)
			return NO;

		for (NSNumber *key in [[_migrations allKeys] sortedArrayUsingComparator:^(id obj1, id obj2) {
			return [obj1 compare:obj2];
		}])
		{
			CCNAbstractMigration *migration = (CCNAbstractMigration *) [[_migrations[key] alloc] init];
			migration.database = database;
			migration.name = NSStringFromClass(migration.class);

			[migration run];

			if (progress)
				progress(migration, ++index, (uint64_t) executionsCount);

			[statement bindLongLong:[key longLongValue] atIndex:1];
			
			int rc = [statement step];

			if (rc != SQLITE_DONE)
			{
				if (error != NULL)
				{
					*error = [NSError errorWithDomain:@"copyisright.ciconia"
												 code:rc
											 userInfo:@{NSLocalizedDescriptionKey : [database lastErrorMessage]}];
				}
			}

			rc = [statement reset];
			if (rc != SQLITE_OK)
			{
				if (error != NULL)
				{
					*error = [NSError errorWithDomain:@"copyisright.ciconia"
												 code:rc
											 userInfo:@{NSLocalizedDescriptionKey : [database lastErrorMessage]}];
				}
			}
		}

		[statement close:error];
			
	}

	return [database executeUpdate:@"COMMIT" error:error];
}

- (void)registerMigrationClass:(Class)migrationClass withVersion:(long long)version
{
	[_migrations setObject:migrationClass forKey:@(version)];
}

@end
