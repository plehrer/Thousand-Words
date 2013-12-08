//
//  TWFiltersCollectionViewController.m
//  Thousand Words
//
//  Created by Peter Lehrer on 12/7/13.
//  Copyright (c) 2013 Peter Lehrer. All rights reserved.
//

#import "TWFiltersCollectionViewController.h"
#import "TWPhotoCollectionViewCell.h"
#import "Photo.h"

@interface TWFiltersCollectionViewController ()

@property (strong, nonatomic) NSMutableArray *filters; // to hold all our filter objects
@property (strong, nonatomic) CIContext *context;

@end

@implementation TWFiltersCollectionViewController

// lazy instantiation, we will always be assured there will be memory initialized for the mutable array filters
-(NSMutableArray *)filters
{
	if (!_filters) _filters = [[NSMutableArray alloc] init];
	
	return _filters;
}

// lazy instantiation
-(CIContext *)context
{
	if (!_context) _context = [CIContext contextWithOptions:nil];
	
	return _context;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	// call class method photoFilters and call mutableCopy to convert to NSMutableArray
	self.filters = [[[self class] photoFilters] mutableCopy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
	
}

#pragma mark - Helpers

// create a class method so these filters are independent of the instance, can put this method in own class if want to refactor
+ (NSArray *)photoFilters
{
	CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:nil];
	
	CIFilter *blur = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues: nil];
	
	// give the max and min amounts I am allowed to change the RGBA
	CIFilter *colorClamp = [CIFilter filterWithName:@"CIColorClamp" keysAndValues:@"inputMaxComponents", [CIVector vectorWithX:0.9 Y:0.9 Z:0.9 W:0.9], @"inputMinComponents", [CIVector vectorWithX:0.2 Y:0.2 Z:0.2 W:0.2], nil];
	
	CIFilter *instant = [CIFilter filterWithName:@"CIPhotoEffectInstant" keysAndValues: nil];
	
	CIFilter *noir = [CIFilter filterWithName:@"CIPhotoEffectNoir" keysAndValues: nil];
	
	CIFilter *vignette = [CIFilter filterWithName:@"CIVignetteEffect" keysAndValues: nil];
	
	// determine how much saturation this image in fact has with KCIInputSaturationKey
	CIFilter *colorControls = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputSaturationKey, @0.5, nil];
	
	CIFilter *transfer = [CIFilter filterWithName:@"CIPhotoEffectTransfer" keysAndValues: nil];
	
	CIFilter *unsharpen = [CIFilter filterWithName:@"CIUnsharpMask" keysAndValues: nil];
	
	CIFilter *monochrome = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues: nil];
	
	NSArray *allFilters = @[sepia, blur, colorClamp, instant, noir, vignette, colorControls, transfer, unsharpen, monochrome];
	
	return allFilters;
}


// convert our UIImage into a CIImage to apply our filter and then convert the filtered image to a UIImage
-(UIImage *)filteredImageFromImage:(UIImage *)image andFilter:(CIFilter *)filter
{
	// convert our UIImage into a CIImage to apply our filter
	CIImage *unfilterImage = [[CIImage alloc] initWithCGImage:image.CGImage];
	
	// set up our filter using our Apple defined constant kCIInputImageKey
	[filter setValue:unfilterImage forKey:kCIInputImageKey];
	
	// get our filtered image back
	CIImage *filteredImage = [filter outputImage];
	
	// get a rect to figure how big our image should be
	CGRect extent = [filteredImage extent];
	
	// use our context to create a CGImageRef which will be needed to convert filtered image to UIImage
	CGImageRef cgImage = [self.context createCGImage:filteredImage fromRect:extent];
	
	// convert to UIImage
	UIImage *finalImage = [UIImage imageWithCGImage:cgImage];
	
	// to find our what we actually stored in core data. coer data may not be the best place to persist images. A better place would be to save the image is in the file system. This would optimize it. You would store a URL address in core data and the address will have the place the image is stored in the file system to optimize the storing process.
	// NSLog(@"Look at all of this data %@", UIImagePNGRepresentation(finalImage));
	
	return finalImage;
}

#pragma mark - UICollectionView DataSoruce

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	// create identifier
	static NSString *CellIdentifier = @"Photo Cell";
	
	TWPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
	cell.backgroundColor = [UIColor whiteColor];
	
	// dispatch_queue_create is a c function not an objective c function, notice no @ sign in from of quote, this is beause it is a constant char
	// create queue for multithreading using Grand Central Dispatch (GCD)
	dispatch_queue_t filterQueue = dispatch_queue_create("filter queue", NULL);
	
	// switch to the filter queue and push it onto another thread and perform function filteredImageFromImage. This had been causing a bottle neck. We can then update the UI asynchronously and as the filtered images come available the UI on the main thread will be updated
	// must add semicolons after each block
	dispatch_async(filterQueue, ^{
		UIImage *filteredImage = [self filteredImageFromImage:self.photo.image andFilter:self.filters[indexPath.row]];
		// switch back to to the main queue and and do UI changes that is the cell image
		dispatch_async(dispatch_get_main_queue(), ^{
			cell.imageView.image = filteredImage;
		});
	});
	
	// next line is no longer needed because we run it inside the filter queue with Grand Central Dispatch
	//cell.imageView.image = [self filteredImageFromImage:self.photo.image andFilter:self.filters[indexPath.row]];
	
	return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [self.filters count];
}

#pragma mark - UICollectionView Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	// find out which cell selected in collection view and caste to a TWPhotoCollectionCell. The item returned from cellForItemAtIndexPath can be any type of object. Since we knbow that we are only using TWPhotoCollectionView cells, so we tell the compiler that the type of cell is a TWPhotoCollectionViewCell and that is a caste.  We want our collection view cell to know that it has the property imageView. We need this to update our photo.image property.
	TWPhotoCollectionViewCell *selectedCell = (TWPhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
	self.photo.image = selectedCell.imageView.image;
	
	// Fix blank image bug. When we select a cell we want to ensure that the cell has an image
	if (self.photo.image) {
		
		NSError *error = nil;
		
		// call save to update the image in core data for us
		if (![[self.photo managedObjectContext] save:&error]) {
			// handle error;
			NSLog(@"%@", error);
		}
		
		// pop view controller from stack and dismiss it
		[self.navigationController popViewControllerAnimated:YES];
	}
}







@end
