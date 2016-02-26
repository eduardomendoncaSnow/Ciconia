//
//  CCNAbstractMigration.h
//  Ciconia
//
//  Created by Pietro Caselani on 1/11/16.
//  Copyright © 2016 Involves. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCNMigrationQueue.h"
#import "SQLDatabase.h"

@interface CCNAbstractMigration : NSObject

- (void)run:(SQLDatabase*)database;

@end
