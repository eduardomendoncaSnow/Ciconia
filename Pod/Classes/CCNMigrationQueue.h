//
//  CCNMigrationQueue.h
//  Ciconia
//
//  Created by Pietro Caselani on 1/11/16.
//  Copyright © 2016 Involves. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCNAbstractMigration;
@class CIRDatabase;

@interface CCNMigrationQueue : NSObject

+ (instancetype)sharedQueue;

- (BOOL)checkForExecutions:(CIRDatabase *)database;

- (NSUInteger)executionsCountForDatabase:(CIRDatabase *)database;

- (void)execute:(CIRDatabase *)database;

- (void)execute:(CIRDatabase *)database progress:(void (^)(CCNAbstractMigration *, int, int))progress;

- (void)registerMigrationClass:(Class)migrationClass withVersion:(long long)version;

@end
