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

+ (nonnull instancetype)sharedQueue;

- (nullable NSNumber *)checkForExecutions:(nonnull CIRDatabase *)database error:(NSError *_Nullable *_Nullable)error;

- (nullable NSNumber *)executionsCountForDatabase:(nonnull CIRDatabase *)database error:(NSError *_Nullable *_Nullable)error;

- (BOOL)execute:(nonnull CIRDatabase *)database error:(NSError *_Nullable *_Nullable)error;

- (BOOL)execute:(nonnull CIRDatabase *)database progress:(void (^__nullable)(CCNAbstractMigration * __nonnull, uint64_t, uint64_t))progress error:(NSError *_Nullable *_Nullable)error;

- (void)registerMigrationClass:(nonnull Class)migrationClass withVersion:(long long)version;

@end
