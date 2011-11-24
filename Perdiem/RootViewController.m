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
#import "NotebookView.h"
#import "ShadowedTornEdgeView.h"
#import "TaskCell.h"
#import "Globals.h"
#import "Task.h"

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
- (void)showArchivedTasks;
@end

@implementation RootViewController

@synthesize fetchedResultsController=__fetchedResultsController;
@synthesize managedObjectContext=__managedObjectContext;
@synthesize cellNib=_cellNib;
@synthesize tmpCell=_tmpCell;
@synthesize taskField=_taskField;


- (void)viewDidLoad
{  
    [self loadPaperStyles];
    
    self.navigationItem.title = @"Today";
    
    float margin = 10.0f;
    UIImage *backgroundImage = [UIImage imageNamed:@"inputFieldBackground"];
    UIView *textFieldView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,
                                                                     self.view.frame.size.width,
                                                                     backgroundImage.size.height + margin)];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    float left = (self.view.frame.size.width - backgroundImage.size.width) / 2.0f;
    backgroundView.frame = CGRectMake(left,
                                      margin,
                                      backgroundImage.size.width,
                                      backgroundImage.size.height);
    [textFieldView addSubview:backgroundView];
    [backgroundView release];
    
    CGRect taskFieldRect = CGRectMake(backgroundView.frame.origin.x + margin,
                                      backgroundView.frame.origin.y,
                                      backgroundView.frame.size.width - margin,
                                      backgroundView.frame.size.height);
    _taskField = [[UITextField alloc] initWithFrame:taskFieldRect];
    _taskField.returnKeyType = UIReturnKeyDone;
    _taskField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _taskField.placeholder = @"Add a new task";
    _taskField.delegate = self;
    _taskField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textFieldView addSubview:_taskField];
    
    self.table.tableHeaderView = textFieldView;
    [textFieldView release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleTaskComplete:) name:@"TaskCellToggled" object:nil];
    
    self.cellNib = [UINib nibWithNibName:@"TaskCell" bundle:nil];
    self.table.rowHeight = TableViewCellHeight;
    self.table.separatorColor = SeperatorColor;
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.toolbarHidden = NO;
    [self.navigationController.toolbar setBackgroundImage:[UIImage imageNamed:@"customBottomBar.png"]
                                       forToolbarPosition:UIToolbarPositionBottom
                                               barMetrics:UIBarMetricsDefault];
    UIImage *archiveImage = [UIImage imageNamed:@"archiveButton.png"];
    UIButton *archiveButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, archiveImage.size.width, archiveImage.size.height)];
    [archiveButton setBackgroundImage:archiveImage forState:UIControlStateNormal];
    [archiveButton setShowsTouchWhenHighlighted:YES];
    [archiveButton addTarget:self action:@selector(showArchivedTasks) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *archiveButtonItem = [[UIBarButtonItem alloc] initWithCustomView:archiveButton];
    [archiveButton release];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self setToolbarItems:[NSArray arrayWithObjects:space, archiveButtonItem, nil]];
    [space release];
    [archiveButtonItem release];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    _cellNib = nil;
    _tmpCell = nil;
    _taskField = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showArchivedTasks
{
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
		cell = _tmpCell;
        cell.delegate = self;
		self.tmpCell = nil;
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
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
    [_cellNib release];
    [_tmpCell release];
    [_taskField release];
    [super dealloc];
}

- (void)configureCell:(TaskCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Task *task = (Task *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.task = task;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Task *task = (Task *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *taskText = task.content;
    float height = 0;
    
    CGSize constraintSize = CGSizeMake(248.0f, MAXFLOAT);
    CGSize size = [taskText sizeWithFont:[UIFont systemFontOfSize:17.0f]
                       constrainedToSize:constraintSize
                           lineBreakMode:UILineBreakModeWordWrap];
    height += size.height + 20.0f;
    
    return (height > TableViewCellHeight) ? height : TableViewCellHeight;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIBarButtonItem *cancelButton = [self customBarButtonItemWithText:@"Cancel" withImageName:@"customBarButton"];
    self.navigationItem.rightBarButtonItem = cancelButton;
    UIButton* rightButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    [rightButton addTarget:self action:@selector(cancelSave) forControlEvents:UIControlEventTouchUpInside];
    
    return YES;
}

- (void)cancelSave
{
    self.navigationItem.rightBarButtonItem = nil;
    _taskField.text = @"";
    [_taskField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    Task *newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    newTask.content = textField.text;
    
    NSDate *now = [NSDate date];
    newTask.timeStamp = now;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    // move the expiration date forward one day
    NSDate *expirationDate = [gregorian dateByAddingComponents:comps toDate:now options:0];
    [comps release];
    // then set the time to midnight
    NSDateComponents *expirationComps = [gregorian components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit) fromDate:expirationDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M/d/yyyy"];
    expirationDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%i/%i/%i",
                                                    [expirationComps month], [expirationComps day], [expirationComps year]]];
    [dateFormatter release];
    [gregorian release];
    
    newTask.expiration = expirationDate;
    
    NSError *error = nil;
	if (![newTask.managedObjectContext save:&error])
    {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}	
    
    self.navigationItem.rightBarButtonItem = nil;
    textField.text = @"";
    [textField resignFirstResponder];
    return YES;
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
