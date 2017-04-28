//
//  CCNAbstractMigration.h
//  Ciconia
//
//  Created by Pietro Caselani on 1/11/16.
//

#import <Foundation/Foundation.h>

#import <SQLAid/CIRDatabase.h>
#import "CCNMigrationQueue.h"

@interface CCNAbstractMigration : NSObject

@property (strong, nonatomic, nonnull) NSString *name;
@property (strong, nonatomic, nonnull) CIRDatabase *database;

- (void)run;

@end
