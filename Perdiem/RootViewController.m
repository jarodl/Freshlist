//
//  RootViewController.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/12/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import "RootViewController.h"
#import "TaskViewController.h"
#import "AIShadowGradient.h"
#import "NotebookView.h"
#import "TornEdgeView.h"
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
@synthesize table;

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self loadPaperStyles];

  [self removeExpiredTasks];
  
  // Set up the info and add button.
  UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Info"
                                                                     style:UIBarStyleBlackOpaque
                                                                    target:self
                                                                    action:@selector(flipCurrentView)];
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(presentNewTaskView)];
  self.navigationItem.rightBarButtonItem = addButton;
  self.navigationItem.leftBarButtonItem = settingsButton;
  [settingsButton release];
  [addButton release];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleTaskComplete:) name:@"TaskCellToggled" object:nil];
  
  self.cellNib = [UINib nibWithNibName:@"TaskCell" bundle:nil];
  self.table.rowHeight = TableViewCellHeight;
  self.table.backgroundColor = TableBackgroundColor;
  self.table.separatorColor = SeperatorColor;
  self.frontViewVisible = YES;
    
  // stops the settingsView navigationbar from appearing too high when flipped
  [settingsView.view removeFromSuperview];
  self.title = @"Today";
}

- (void)loadPaperStyles
{
  UIImage *paper = [UIImage imageNamed:@"paperedge.png"];
  CGFloat height = paper.size.height;
  self.table.contentInset = UIEdgeInsetsMake(height, 0.0, height, 0.0);
  
  TornEdgeView *tornEdge = [[[TornEdgeView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, height)] autorelease];
  [self.view addSubview:tornEdge];
  
  UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height, self.view.frame.size.width, 0.0f)];
  self.table.tableHeaderView = header;
    
  NotebookView *background = [[[NotebookView alloc] initWithFrame:self.table.frame] autorelease];
  background.backgroundColor = TableBackgroundColor;
  self.table.backgroundView = background;
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
	return YES;
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

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  cellNib = nil;
  tmpCell = nil;
}

- (void)dealloc
{
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
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:YES];
    [settingsView.view removeFromSuperview];
    [self.navigationController.view addSubview:settingsView.view];
  }
  else
  {
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:YES];
    [settingsView.view removeFromSuperview];
  }
  
  [UIView commitAnimations];
  frontViewVisible = !frontViewVisible;
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

@end
