//
//  TWPhotosCollectionViewController.m
//  Thousand Words
//
//  Created by Peter Lehrer on 12/1/13.
//  Copyright (c) 2013 Peter Lehrer. All rights reserved.
//

#import "TWPhotosCollectionViewController.h"
#import "TWPhotoCollectionViewCell.h"

@interface TWPhotosCollectionViewController ()

@end

@implementation TWPhotosCollectionViewController

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

#pragma mark - UICollectionViewDataSource

// have to write datasource methods ourselves

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Photo Cell";
	
	TWPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
	cell.backgroundColor = [UIColor whiteColor];
	cell.imageView.image = [UIImage imageNamed:@"Astronaut.jpg"];
	
	
	return cell;
	
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return 5;
}







@end
