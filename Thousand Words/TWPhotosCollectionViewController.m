//
//  TWPhotosCollectionViewController.m
//  Thousand Words
//
//  Created by Peter Lehrer on 12/1/13.
//  Copyright (c) 2013 Peter Lehrer. All rights reserved.
//

#import "TWPhotosCollectionViewController.h"
#import "TWPhotoCollectionViewCell.h"
#import "Photo.h"
#import "TWPictureDataTransformer.h"
#import "TWCoreDataHelper.h"

// need to conform to UINavigationControllerDelegate because UIImapickerControllerDelegate inherits from it.
@interface TWPhotosCollectionViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSMutableArray *photos; // of UIImages

@end

@implementation TWPhotosCollectionViewController

// lazy instantiation
-(NSMutableArray *)photos
{
	if (!_photos) {
		_photos = [[NSMutableArray alloc] init];
	}
	return _photos;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cameraBarButtonItemPressed:(UIBarButtonItem *)sender {

	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	// is camera available?
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
	// else is photo album available?
	else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
		picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	}// present view controller programmatically
	[self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - Helper Methods

// helper method to persist our data to core data, Section 9.3
-(Photo *)photoFromImage:(UIImage *)image
{
	Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:[TWCoreDataHelper managedObjectContext]];
	photo.image = image;
	// set photo.date to current date
	photo.date = [NSDate date];
	// our Album relationship
	photo.albumBook = self.album; // have access to this property eventhough haven't given it a value in prepareForSegue method
	
	NSError *error = nil;
	// if method save returns NO
	if (![[photo managedObjectContext] save:&error]) {
		//Error in saving
		NSLog(@"%@", error);
	}
	return photo;
}

#pragma mark - UICollectionViewDataSource

// have to write datasource methods ourselves

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Photo Cell";
	
	TWPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
	
	Photo *photo = self.photos[indexPath.row];
	cell.backgroundColor = [UIColor whiteColor];
	cell.imageView.image = photo.image;
	
	
	return cell;
	
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [self.photos count];
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	// info contains data about the photo, not only image data, but metadata, we use the literal [] to access the dictionary, we access the edited image data using the key, if not availabel, we access data using the original image key
	UIImage *image = info[UIImagePickerControllerEditedImage];
	if (!image) {
		image = info[UIImagePickerControllerOriginalImage];
	}
	// we add our image to our mutable array and reload our collection view
	// section 9.4, photFromImage returns our Photo object and we add this object to our photos array, our array now contains Photo Objects. We implement photoFromImage helper method
	[self.photos addObject:[self photoFromImage:image]];
	
	[self.collectionView reloadData];
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	
	[self dismissViewControllerAnimated:YES completion:nil];
}












@end






