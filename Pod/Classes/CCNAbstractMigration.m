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

- (void)createTable:(NSString *)tableName withColumnsFromDictionary:(NSDictionary *)dictionary
{
	NSMutableString *createTableString = [@"CREATE TABLE " mutableCopy];
	[createTableString appendFormat:@"%@ (", tableName];

	for (NSString *key in dictionary.keyEnumerator)
		[createTableString appendFormat:@"%@ %@, ", key, dictionary[key]];

	[createTableString replaceCharactersInRange:NSMakeRange(createTableString.length - 2, 2) withString:@")"];

	[self.database executeUpdate:createTableString];
}

@end
