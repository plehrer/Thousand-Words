//
//  TWPhotoDetailViewController.h
//  Thousand Words
//
//  Created by Peter Lehrer on 12/7/13.
//  Copyright (c) 2013 Peter Lehrer. All rights reserved.
//

#import <UIKit/UIKit.h>

// example of a forward declaration, lightweight way to get access to the Photo class
@class Photo;

@interface TWPhotoDetailViewController : UIViewController

@property (strong, nonatomic) Photo *photo;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)addFilterButtonPrtessed:(UIButton *)sender;
- (IBAction)deleteButtonPressed:(UIButton *)sender;

@end
