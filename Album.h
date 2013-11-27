//
//  Album.h
//  Thousand Words
//
//  Created by Peter Lehrer on 11/27/13.
//  Copyright (c) 2013 Peter Lehrer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Album : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * date;

@end
