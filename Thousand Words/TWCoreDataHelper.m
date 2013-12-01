//
//  TWCoreDataHelper.m
//  Thousand Words
//
//  Created by Peter Lehrer on 11/30/13.
//  Copyright (c) 2013 Peter Lehrer. All rights reserved.
//

#import "TWCoreDataHelper.h"

@implementation TWCoreDataHelper

+(NSManagedObjectContext *)managedObjectContext
{
	NSManagedObjectContext *context = nil;
	id delegate = [[UIApplication sharedApplication] delegate];
	
	// introspection to make sure variable named delegate in fact responds to the method managedObjectContext and then perform this method on delegate
	if ([delegate performSelector:@selector(managedObjectContext)]) {
		context = [delegate managedObjectContext];
	}
	
	return context;
}


@end
