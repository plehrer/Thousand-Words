//
//  TWAlbumTableViewController.m
//  Thousand Words
//
//  Created by Peter Lehrer on 11/27/13.
//  Copyright (c) 2013 Peter Lehrer. All rights reserved.
//

#import "TWAlbumTableViewController.h"
#import "Album.h"

@interface TWAlbumTableViewController () <UIAlertViewDelegate> // add alertview delegate which has its own protocol. do this in .m file because people don't need to know we are confroming to this delegate. It is private.

@end

@implementation TWAlbumTableViewController

//*********************************************************
// Lazy instantiation to ensure there will always be memory
// allocated for property albums.
//*********************************************************
-(NSMutableArray *)albums
{
	if (!_albums) _albums = [[NSMutableArray alloc] init];
	return _albums;
}



- (IBAction)addAlbum:(UIBarButtonItem *)sender {
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)albumBarButtonItemPressed:(UIBarButtonItem *)sender
{
	// set delegare to self which is our TWAlbumTableView, "delegate:self"
	UIAlertView *newAlbumAlertView = [[UIAlertView alloc] initWithTitle:@"Enter New Album Name" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
	[newAlbumAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput]; //Adds text field
	[newAlbumAlertView show];
}

#pragma mark - Helper Methods

-(Album *)albumWithName:(NSString *)name
{
	// get app delegate and get NSManagedObjectContext from it
	// id is a pointer to an object of type unknow so we don't need to add the asterisk before 'delegate'
	// we get delegate back from our UIApplication. we get a delegate for entire application, and delegate knows what our NSManaged context is.  Apple calls NSManage context the 'scratch pad' in the application. We can think of it as a pinhole or window where we can reach the objects in our database. Each managed object or sub class thereof is belongs to only one ns managed context. In more advanced apps it is possible to have more than one context to manage core data. In short, our NSManaged object context allows us to interact with both query and save our NSManaged objects so we need this object to access them. And the we are going to get his is from our app delegate. Once we have this NSManaged object context which we know we need to interact with nsmanaged objects and we happen to know that album is an nsmanaged object, we are going to go ahead and create our new persistent managed object.
	id delegate = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [delegate managedObjectContext];
	
	// this function takes our entity name and it also takes a context, then we set album properties
	Album *album = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:context];
	album.name = name;
	album.date = [NSDate date];
	
	// save context passing in an nserror, and get back an error message if we get an error saving to core data ampersand error is a pointer to a pointer of an NSError object. If we get an error, than we will be able to nslog that error. we can get an error message if we press the stop button on the simulator
	NSError *error = nil;
	if (![context save:&error]) {
		//we have an error
		NSLog(@"%@", error);
	}
	return album;
}

#pragma mark - UIAlertView delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1) {
		NSString *alertText = [alertView textFieldAtIndex:0].text;
		[self.albums addObject:[self albumWithName:alertText]];
		[self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.albums count] - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
	}
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.albums count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
	Album *selectedAlbum = self.albums[indexPath.row];
	cell.textLabel.text = selectedAlbum.name;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
