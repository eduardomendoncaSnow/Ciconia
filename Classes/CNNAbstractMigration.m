//
//  CCNAbstractMigration.m
//  Ciconia
//
//  Created by Pietro Caselani on 1/11/16.
//  Copyright © 2016 Involves. All rights reserved.
//

#import "CCNAbstractMigration.h"

@implementation CCNAbstractMigration

- (void)run:(SQLDatabase*)database
{
	@throw [NSException exceptionWithName:@"Abstract class" reason:@"Child classes must override this method" userInfo:nil];
}

@end
