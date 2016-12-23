//
//  CCNAbstractMigration.m
//  Ciconia
//
//  Created by Pietro Caselani on 1/11/16.
//

#import "CCNAbstractMigration.h"
#import "CCNAbstractMigration_Protected.h"

@implementation CCNAbstractMigration

- (void)run
{
	@throw [NSException exceptionWithName:@"Abstract Implementation Exception"
	                               reason:@"[CCNAbstractMigration -run] throws that child classes must override this method"
	                             userInfo:nil];
}

#pragma mark - Protected

- (NSString *)createTable:(NSString *)tableName withColumnsFromDictionary:(NSDictionary *)columns
{
	return [self createTable:tableName withColumnsFromDictionary:columns constraints:nil];
}

- (NSString *)createTable:(NSString *)tableName withColumnsFromDictionary:(NSDictionary *)columns constraints:(NSDictionary *)constraints
{
	NSMutableString *createTableString = [@"CREATE TABLE " mutableCopy];
	[createTableString appendFormat:@"%@ (", tableName];

	for (NSString *key in columns.keyEnumerator)
		[createTableString appendFormat:@"%@ %@, ", key, columns[key]];

	for (NSString *key in constraints.keyEnumerator)
		[createTableString appendFormat:@"%@ %@, ", key, constraints[key]];

	[createTableString replaceCharactersInRange:NSMakeRange(createTableString.length - 2, 2) withString:@")"];

	return [self executeSQL:createTableString];
}

- (NSString *)dropTable:(NSString *)tableName
{
	return [self executeSQL:[@"DROP TABLE IF EXISTS " stringByAppendingString:tableName]];
}

- (NSString *)addColumn:(NSString *)name ofType:(NSString *)type toTable:(NSString *)table
{
	NSMutableString *alterTableString = [@"ALTER TABLE " mutableCopy];
	
	[alterTableString appendString:table];
	[alterTableString appendString:@" ADD COLUMN "];
	[alterTableString appendString:name];
	[alterTableString appendString:@" "];
	[alterTableString appendString:type];
	
	return [self executeSQL:alterTableString];
}

- (NSString *)executeSQL:(NSString *)sqlString
{
	[self.database executeUpdate:sqlString];
	return sqlString;
}

@end
