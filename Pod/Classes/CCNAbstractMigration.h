//
//  CCNAbstractMigration.h
//  Ciconia
//
//  Created by Pietro Caselani on 1/11/16.
//  Copyright © 2016 Involves. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCNMigrationQueue.h"
#import "CIRDatabase.h"

@interface CCNAbstractMigration : NSObject

- (void)run:(CIRDatabase*)database;

@end
