//
//  TWAlbumTableViewController.h
//  Thousand Words
//
//  Created by Peter Lehrer on 11/27/13.
//  Copyright (c) 2013 Peter Lehrer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWAlbumTableViewController : UITableViewController 

@property (strong, nonatomic) NSMutableArray *albums;
- (IBAction)albumBarButtonItemPressed:(UIBarButtonItem *)sender;

@end
