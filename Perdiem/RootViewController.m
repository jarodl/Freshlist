//
//  RootViewController.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/12/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import "RootViewController.h"
#import "CustomNavigationBar.h"
#import "TaskViewController.h"
#import "AIShadowGradient.h"
#import "NotebookView.h"
#import "ShadowedTornEdgeView.h"
#import "TaskCell.h"
#import "Globals.h"
#import "Task.h"

@interface RootViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation RootViewController

@synthesize frontViewVisible;
@synthesize fetchedResultsController=__fetchedResultsController;
@synthesize managedObjectContext=__managedObjectContext;
@synthesize newTaskView;
@synthesize settingsView;
@synthesize cellNib;
@synthesize tmpCell;
@synthesize bannerView;

- (void)viewDidLoad
{
  [self loadPaperStyles];
  
  self.navigationItem.rightBarButtonItem = [self customBarButtonItemWithText:@"New" withImageName:@"customBarButton"];
  UIButton* rightButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
  [rightButton addTarget:self action:@selector(presentNewTaskView) forControlEvents:UIControlEventTouchUpInside];
  
  self.navigationItem.leftBarButtonItem = [self customBarButtonItemWithText:@"Info" withImageName:@"customBarButton"];
  UIButton* leftButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
  [leftButton addTarget:self action:@selector(flipCurrentView) forControlEvents:UIControlEventTouchUpInside];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleTaskComplete:) name:@"TaskCellToggled" object:nil];
  
  self.cellNib = [UINib nibWithNibName:@"TaskCell" bundle:nil];
  self.table.rowHeight = TableViewCellHeight;
  self.table.separatorColor = SeperatorColor;
  self.frontViewVisible = YES;
    
  // stops the settingsView navigationbar from appearing too high when flipped
  [settingsView.view removeFromSuperview];
  self.title = @"Today";
  
  [self createBannerView];
  [self layoutBanner:NO];
  [self removeExpiredTasks];
  
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  cellNib = nil;
  tmpCell = nil;
  
  if (self.bannerView) {
    bannerView.delegate = nil;
    self.bannerView = nil;
  }
}

- (void)loadPaperStyles
{
  UIView *header = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 0.0)] autorelease];
  self.table.tableHeaderView = header;
    
  NotebookView *background = [[[NotebookView alloc] initWithFrame:self.table.frame] autorelease];
  background.backgroundColor = TableBackgroundColor;
  self.table.backgroundView = background;
  
  [self loadShadowedTornEdge];
}

- (void)removeExpiredTasks
{
  NSManagedObjectContext *moc = [self managedObjectContext];
  NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:moc];
  NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
  [request setEntity:entityDescription];
  
  NSDate *now = [NSDate date];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
                            @"expiration < %@", now];
  [request setPredicate:predicate];
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                      initWithKey:@"timeStamp" ascending:YES];
  [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
  [sortDescriptor release];
  
  NSError *error = nil;
  NSArray *array = [moc executeFetchRequest:request error:&error];
  if (array == nil)
  {
    // Deal with error...
  }
  else
  {
    for (Task *expiredTask in array) {
      [moc deleteObject:expiredTask];
    }
  }
}

- (void)toggleTaskComplete:(NSNotification *)notification
{
  NSIndexPath *indexPath = [notification.userInfo objectForKey:@"indexPath"];
  Task *task = (Task *)[self.fetchedResultsController objectAtIndexPath:indexPath];
  [task toggle];
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
    NSError *error = nil;
    if (![context save:&error])
    {
      /*
       Replace this implementation with code to handle the error appropriately.
       
       abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
       */
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
  // The table view should not be re-orderable.
  return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
  TaskViewController *taskView = [[TaskViewController alloc] initWithTask:(Task *)managedObject];
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
  if (bannerView) {
    bannerView.delegate = nil;
    [bannerView release];
  }
  
  [__fetchedResultsController release];
  [__managedObjectContext release];
  [newTaskView release];
  [cellNib release];
  [tmpCell release];
  [super dealloc];
}

- (void)configureCell:(TaskCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
  Task *task = (Task *)[self.fetchedResultsController objectAtIndexPath:indexPath];
  cell.showsAccessory = YES;
  cell.cellIndexPath = indexPath;
  cell.taskContent = task.content;
  cell.checked = [task.completed boolValue];
}

- (void)presentNewTaskView
{
  [self presentModalViewController:newTaskView animated:YES];
}

- (void)flipCurrentView
{
  // disable user interaction
  self.navigationController.view.userInteractionEnabled = NO;
  
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.75];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(myTransitionDidStop:finished:context:)];

  if (frontViewVisible)
  {
    [self removeBanner];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:YES];
    [settingsView.view removeFromSuperview];
    [self.navigationController.view addSubview:settingsView.view];
  }
  else
  {
    [self addBanner];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:YES];
    [settingsView.view removeFromSuperview];
  }
  
  frontViewVisible = !frontViewVisible;
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
  NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
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

     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
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

#pragma mark -
#pragma mark ADBannerViewDelegate methods

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
  if (frontViewVisible)
  {
    [self layoutBanner:YES];
  }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
  [self layoutBanner:YES];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
  return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
}

- (void)createBannerView
{
  Class cls = NSClassFromString(@"ADBannerView");
  if (cls) {
    ADBannerView *adBanner = [[cls alloc] initWithFrame:CGRectZero];
    
    NSString *contentSize;
    if (&ADBannerContentSizeIdentifierPortrait != nil)
    {
      contentSize = ADBannerContentSizeIdentifierPortrait;
    }
    else
    {
      // user the older sizes 
      contentSize = ADBannerContentSizeIdentifier320x50;
    }
    
    CGRect frame;
    frame.size = [ADBannerView sizeFromBannerContentSizeIdentifier:contentSize];
    frame.origin = CGPointMake(0.0f, CGRectGetMaxY(self.view.bounds));
    
    // Now set the banner view's frame
    adBanner.frame = frame;
    
    // Set the delegate to self, so that we are notified of ad responses.
    adBanner.delegate = self;
    
    // Set the autoresizing mask so that the banner is pinned to the bottom
    adBanner.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    
    // Since we support all orientations in this view controller, support portrait and landscape content sizes.
    // If you only supported landscape or portrait, you could remove the other from this set
    adBanner.requiredContentSizeIdentifiers =
    (&ADBannerContentSizeIdentifierPortrait != nil) ?
    [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, nil] : 
    [NSSet setWithObjects:ADBannerContentSizeIdentifier320x50, nil];
    
    // At this point the ad banner is now be visible and looking for an ad.
    self.bannerView = adBanner;
    [self.view addSubview:adBanner];
    [adBanner release];
  }
}

- (void)layoutBanner:(BOOL)animated
{
  CGRect contentFrame = self.table.frame;
	CGPoint bannerOrigin = CGPointMake(CGRectGetMinX(contentFrame), CGRectGetMaxY(contentFrame));
  CGFloat bannerHeight = 0.0f;
  
  bannerHeight = bannerView.frame.size.height;
	
  // Depending on if the banner has been loaded, we adjust the content frame and banner location
  // to accomodate the ad being on or off screen.
  // This layout is for an ad at the bottom of the view.
  if (bannerView.bannerLoaded)
  {
    contentFrame.size.height -= bannerHeight;
		bannerOrigin.y -= bannerHeight;
  }
  else if (!self.navigationController.view.userInteractionEnabled || !bannerView.bannerLoaded)
  {
		bannerOrigin.y += bannerHeight;
  }
  
  self.table.frame = contentFrame;
  [self.table layoutIfNeeded];
  bannerView.frame = CGRectMake(bannerOrigin.x, bannerOrigin.y,  bannerView.frame.size.width, bannerView.frame.size.height);
}

- (void)removeBanner
{
  [self.bannerView removeFromSuperview];
}

- (void)addBanner
{
  [self.view addSubview:bannerView];
}

@end
