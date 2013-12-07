//
//  TWPictureDataTransformer.m
//  Thousand Words
//
//  Created by Peter Lehrer on 12/7/13.
//  Copyright (c) 2013 Peter Lehrer. All rights reserved.
//

#import "TWPictureDataTransformer.h"

@implementation TWPictureDataTransformer

#pragma mark - Class Methods

// class methods determine which class we are transforming our value to
+(Class)transformedValueClass
{
	// convert a UIImage (the photo) into an NSData object
	return [NSData class];
}

// allow reverse transformation
+(BOOL)allowsReverseTransformation
{
	// return YES becausee we are going to allow the user to convert a NSData object into an UIImage object
	return YES;
}

#pragma mark - Instance Methods

// id is anonymous object type, we use id and not casting
//  first do conversion from UIImage to NSData
-(id)transformedValue:(id)value
{
	// return a data object containing PNG data
	return UIImagePNGRepresentation(value);
}

// since we allow reverse transformation, pass in a parameter of NSData and convert to UIImage and return it
-(id)reverseTransformedValue:(id)value
{
	UIImage *image = [UIImage imageWithData:value];
	return image;
}

@end
