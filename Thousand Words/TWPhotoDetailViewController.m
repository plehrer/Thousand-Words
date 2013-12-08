//
//  TWPhotoDetailViewController.m
//  Thousand Words
//
//  Created by Peter Lehrer on 12/7/13.
//  Copyright (c) 2013 Peter Lehrer. All rights reserved.
//

#import "TWPhotoDetailViewController.h"
#import "Photo.h"
#import "TWFiltersCollectionViewController.h"

@interface TWPhotoDetailViewController ()

@end

@implementation TWPhotoDetailViewController

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

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:YES];
	
	self.imageView.image = self.photo.image; // forward declare Photo class in our .h file, allows us to add our property photo, but must import Photo.h in this .m file inorder to access image property.
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Filter Segue"]) {
		if ([segue.destinationViewController isKindOfClass:[TWFiltersCollectionViewController class]]) {
			TWFiltersCollectionViewController *targetViewController = segue.destinationViewController;
			targetViewController.photo = self.photo;
		}
	}
}

- (IBAction)addFilterButtonPrtessed:(UIButton *)sender {
}

- (IBAction)deleteButtonPressed:(UIButton *)sender {
	[[self.photo managedObjectContext] deleteObject:self.photo];
	
	NSError *error = nil;
	
	// to persist deletion in core data, Photo class inherits from NSManagedObject
	// on device core data is saved automatically, we need to explicitly call save when using simulator
	// technically call to save is not need to be called explicitly when we deploy to our device
	// because when we press the stop button when we run our simulator, core data is not able to autosave these changes
	[[self.photo managedObjectContext] save:&error];
	
	if (error) {
		NSLog(@"error");
	}
	
	[self.navigationController popViewControllerAnimated:YES];
}










@end
