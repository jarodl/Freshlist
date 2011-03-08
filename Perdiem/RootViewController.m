//
//  RootViewController.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/12/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import "RootViewController.h"
#import "PerdiemAppDelegate.h"
#import "CustomNavigationBar.h"
#import "NewTaskViewController.h"
#import "InfoViewController.h"
#import "TaskViewController.h"
#import "AIShadowGradient.h"
#import "NotebookView.h"
#import "ShadowedTornEdgeView.h"
#import "TaskCell.h"
#import "Globals.h"
#import "Task.h"
#import <iAd/iAd.h>

#define FreeVersionLimit 5

#define FT_SAVE_MOC(_ft_moc) \
do { \
NSError* _ft_save_error; \
if(![_ft_moc save:&_ft_save_error]) { \
NSLog(@"Failed to save to data store: %@", [_ft_save_error localizedDescription]); \
NSArray* _ft_detailedErrors = [[_ft_save_error userInfo] objectForKey:NSDetailedErrorsKey]; \
if(_ft_detailedErrors != nil && [_ft_detailedErrors count] > 0) { \
for(NSError* _ft_detailedError in _ft_detailedErrors) { \
NSLog(@"DetailedError: %@", [_ft_detailedError userInfo]); \
} \
} \
else { \
NSLog(@"%@", [_ft_save_error userInfo]); \
} \
} \
} while(0);

@interface RootViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation RootViewController

@synthesize frontViewVisible;
@synthesize bannerIsVisible;
@synthesize fetchedResultsController=__fetchedResultsController;
@synthesize managedObjectContext=__managedObjectContext;
@synthesize settingsView;
@synthesize newTaskView;
@synthesize cellNib;
@synthesize tmpCell;

- (void)viewWillAppear:(BOOL)animated
{
  self.frontViewVisible = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
  self.frontViewVisible = NO;
}

- (void)viewDidLoad
{
  // load the info view, this should probably be taken care of elsewhere
  InfoViewController *info = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
  [settingsView pushViewController:info animated:NO];
  [info release];
  
  [self loadPaperStyles];
  
  self.navigationItem.rightBarButtonItem = [self customBarButtonItemWithText:nil withImageName:@"addButton"];
  UIButton* rightButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
  [rightButton addTarget:self action:@selector(presentNewTaskView) forControlEvents:UIControlEventTouchUpInside];
  
  self.navigationItem.leftBarButtonItem = [self customBarButtonItemWithText:nil withImageName:@"settingsButton"];
  UIButton* leftButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
  [leftButton addTarget:self action:@selector(flipCurrentView) forControlEvents:UIControlEventTouchUpInside];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleTaskComplete:) name:@"TaskCellToggled" object:nil];
    
  self.cellNib = [UINib nibWithNibName:@"TaskCell" bundle:nil];
  self.table.rowHeight = TableViewCellHeight;
  self.table.separatorColor = SeperatorColor;
  self.frontViewVisible = YES;
  self.bannerIsVisible = NO;
    
  // stops the settingsView navigationbar from appearing too high when flipped
  [settingsView.view removeFromSuperview];
  self.title = @"Today";

  [super viewDidLoad];
}

- (void)viewDidUnload
{
  ADBannerView *adBanner = SharedAdBannerView;
	adBanner.delegate = nil;
	[adBanner removeFromSuperview];

  cellNib = nil;
  tmpCell = nil;
}

- (void)loadPaperStyles
{
  UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 0.0)];
  self.table.tableHeaderView = header;
  [header release];

  NotebookView *background = [[NotebookView alloc] initWithFrame:self.table.frame];
  background.backgroundColor = TableBackgroundColor;
  self.table.backgroundView = background;
  [background release];
  
  [self loadShadowedTornEdge];
}

- (void)toggleTaskComplete:(NSNotification *)notification
{
  [self.table reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
  return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"TaskCell";
  
  TaskCell *cell = (TaskCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil)
  {
    [self.cellNib instantiateWithOwner:self options:nil];
		cell = tmpCell;
    cell.delegate = self;
		self.tmpCell = nil;
  }
  
  [self configureCell:cell atIndexPath:indexPath];
  return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete)
  {
    // Delete the managed object for the given index path
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    
    // Save the context.
//    NSError *error = nil;
    FT_SAVE_MOC(context);
//    if (![context save:&error])
//    {
//      /*
//       Replace this implementation with code to handle the error appropriately.
//       */
//      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//      abort();
//    }
  }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
  // The table view should not be re-orderable.
  return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  Task *task = (Task *)[self.fetchedResultsController objectAtIndexPath:indexPath];
  
  TaskViewController *taskView = [[TaskViewController alloc] initWithTask:task];
  taskView.showsNotebookLines = NO;
  [self.navigationController pushViewController:taskView animated:YES];
  [taskView release];
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
  [__fetchedResultsController release];
  [__managedObjectContext release];
  [settingsView release];
  [newTaskView release];
  [cellNib release];
  [tmpCell release];
  [super dealloc];
}

- (void)configureCell:(TaskCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
  Task *task = (Task *)[self.fetchedResultsController objectAtIndexPath:indexPath];
  cell.task = task;
}

- (void)presentNewTaskView
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if (![defaults valueForKey:@"proUpgradeIsPurchased"] &&
      [self.fetchedResultsController.fetchedObjects count] >= FreeVersionLimit)
  {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pro Feature Only" message:@"The free version of Freshlist only allows 5 or less items on your list at a time. Upgrade to pro to remove ads and add unlimited tasks."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Upgrade", nil];
    [alert show];
    [alert release];
    return;
  }
  
  NewTaskViewController *newTaskCon = [[NewTaskViewController alloc] initWithNibName:@"NewTaskViewController" bundle:nil];
  newTaskCon.delegate = self;
  
  Task *newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
  newTaskCon.task = newTask;
  
  [newTaskView pushViewController:newTaskCon animated:NO];
  [self presentModalViewController:newTaskView animated:YES];
  [newTaskCon release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 1)
  {
    [self flipCurrentView];
  }
}

- (void)newTaskViewController:(NewTaskViewController *)newTaskViewController didAddTask:(Task *)task
{
  [self dismissModalViewControllerAnimated:YES];
}

- (void)flipCurrentView
{
  // disable user interaction
  self.navigationController.view.userInteractionEnabled = NO;
  
  [UIView beginAnimations:@"flipCurrentView" context:nil];
  [UIView setAnimationDuration:0.75];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(myTransitionDidStop:finished:context:)];

  if (frontViewVisible)
  {
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:YES];
    [settingsView.view removeFromSuperview];
    [self.navigationController.view addSubview:settingsView.view];
    [self.navigationController.view bringSubviewToFront:settingsView.view];
    ADBannerView *adBanner = SharedAdBannerView;
    [self.navigationController.view bringSubviewToFront:adBanner];
    self.frontViewVisible = NO;
  }
  else
  {
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:YES];
    [settingsView.view removeFromSuperview];
    self.frontViewVisible = YES;
  }
  
  [UIView commitAnimations];
}

- (void)myTransitionDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
  self.navigationController.view.userInteractionEnabled = YES;
}

- (IBAction)dismissNewTaskView
{
  [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)dismissSettingsView
{
  [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
  if (__fetchedResultsController != nil)
  {
    return __fetchedResultsController;
  }
  
  /*
   Set up the fetched results controller.
  */
  // Create the fetch request for the entity.
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  // Edit the entity name as appropriate.
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:entity];
  
  // Set the batch size to a suitable number.
  [fetchRequest setFetchBatchSize:20];
  
  // Edit the sort key as appropriate.
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
  
  [fetchRequest setSortDescriptors:sortDescriptors];
  
  // Edit the section name key path and cache name if appropriate.
  // nil for section name key path means "no sections".
  NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                           initWithFetchRequest:fetchRequest
                                                           managedObjectContext:self.managedObjectContext
                                                           sectionNameKeyPath:nil cacheName:@"Freshlist"];
  aFetchedResultsController.delegate = self;
  self.fetchedResultsController = aFetchedResultsController;
  
  [aFetchedResultsController release];
  [fetchRequest release];
  [sortDescriptor release];
  [sortDescriptors release];

	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error])
  {
    /*
     Replace this implementation with code to handle the error appropriately.
     */
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
	}
    
  return __fetchedResultsController;
}

#pragma mark - Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
  [self.table beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
  switch(type)
  {
      case NSFetchedResultsChangeInsert:
          [self.table insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
          break;
          
      case NSFetchedResultsChangeDelete:
          [self.table deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
          break;
  }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
  UITableView *tableView = self.table;
  
  switch(type)
  {
    case NSFetchedResultsChangeInsert:
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        break;
        
    case NSFetchedResultsChangeDelete:
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        break;
        
    case NSFetchedResultsChangeUpdate:
        [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
        break;
        
    case NSFetchedResultsChangeMove:
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
        break;
  }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
  [self.table endUpdates];
}

- (void)cellWasChecked
{
  [self.table reloadData];
}

@end
