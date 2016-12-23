//
//  CCNAbstractMigration_Protected.h
//  Ciconia
//
//  Created by Felipe Lobo on 3/3/16.
//

#import "CCNAbstractMigration.h"

@interface CCNAbstractMigration ()

- (NSString *)createTable:(NSString *)tableName withColumnsFromDictionary:(NSDictionary *)dictionary;
- (NSString *)createTable:(NSString *)tableName withColumnsFromDictionary:(NSDictionary *)columns constraints:(NSDictionary *)constraints;
- (NSString *)dropTable:(NSString *)tableName;
- (NSString *)addColumn:(NSString *)name ofType:(NSString *)type toTable:(NSString *)table;
- (NSString *)executeSQL:(NSString *)sqlString;

@end
