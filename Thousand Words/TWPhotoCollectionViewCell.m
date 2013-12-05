//
//  TWPhotoCollectionViewCell.m
//  Thousand Words
//
//  Created by Peter Lehrer on 12/1/13.
//  Copyright (c) 2013 Peter Lehrer. All rights reserved.
//

#import "TWPhotoCollectionViewCell.h"

#define IMAGEVIEW_BORDER_LENGTH 5

@implementation TWPhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self setup];  // need to create a method named setup
    }
    return self;
}
// call this method instead of initWithFrame
-(id)initWithCoder:(NSCoder *)aDecoder {
	// call super method initWithCoder
	self = [super initWithCoder:aDecoder];
	
	// if self exists call setup
	if (self) {
		[self setup];
	}
	return self;
}

-(void)setup
{
	// CGRectInset gives us a white border by sitting on top of contentView
	self.imageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, IMAGEVIEW_BORDER_LENGTH, IMAGEVIEW_BORDER_LENGTH)];
	[self.contentView addSubview:self.imageView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
