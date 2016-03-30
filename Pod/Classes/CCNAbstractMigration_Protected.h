//
//  CCNAbstractMigration_Protected.h
//  Ciconia
//
//  Created by Felipe Lobo on 3/3/16.
//

#import "CCNAbstractMigration.h"

@interface CCNAbstractMigration ()

- (void)createTable:(NSString *)tableName withColumnsFromDictionary:(NSDictionary *)dictionary;
- (void)createTable:(NSString *)tableName withColumnsFromDictionary:(NSDictionary *)columns constraints:(NSDictionary *)constraints;

@end
