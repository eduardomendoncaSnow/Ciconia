//
//  CCNMigrationQueue.h
//  Ciconia
//
//  Created by Pietro Caselani on 1/11/16.
//  Copyright © 2016 Involves. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCNAbstractMigration;
@class SQLDatabase;

@interface CCNMigrationQueue : NSObject

+ (instancetype)sharedQueue;

- (void)execute:(SQLDatabase*)database;
- (void)registerMigrationClass:(Class)migrationClass withVersion:(long long)version;

@end
