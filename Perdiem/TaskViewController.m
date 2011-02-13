//
//  TaskViewController.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/12/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import "TaskViewController.h"
#import "NSString+Extensions.h"
#import "TaskCell.h"
#import "Task.h"

#define NumOfSections 2
#define NumOfRowsInTaskSection 2

enum TaskViewSections {
  TaskSection = 0,
  DeleteSection = 1
};

enum TaskSectionRows {
  TaskContent = 0,
  TaskExpiration = 1
};

@interface TaskViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation TaskViewController

@synthesize selectedTask;
@synthesize cellNib;
@synthesize tmpCell;

- (id)initWithTask:(Task *)task
{
  if ((self = [super initWithStyle:UITableViewStyleGrouped]))
  {
    selectedTask = task;
    self.hidesBottomBarWhenPushed = YES;
    self.title = @"Task";
    self.cellNib = [UINib nibWithNibName:@"TaskCell" bundle:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleTaskComplete:) name:@"TaskCellToggled" object:nil];
  }
  
  return self;
}

- (void)toggleTaskComplete:(NSNotification *)notification
{
  [selectedTask toggle];
  [self.tableView reloadData];
}

- (void)dealloc
{
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return NumOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  switch (section) {
    case TaskSection:
      return NumOfRowsInTaskSection;
    case DeleteSection:
      return 1;
  }
  
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"TaskCell";

  if (indexPath.section == TaskSection &&
      indexPath.row == TaskContent)
  {
    TaskCell *cell = (TaskCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self.cellNib instantiateWithOwner:self options:nil];
		cell = tmpCell;
		self.tmpCell = nil;
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
  }
  else
  {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
  }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
  TaskCell *theCell;
  NSString *expireString;
  switch (indexPath.section)
  {
    case TaskSection:
      switch (indexPath.row)
      {
        case TaskContent:
          theCell = (TaskCell *)cell;
          [theCell setTaskContentText:selectedTask.content];
          theCell.accessoryType = UITableViewCellAccessoryNone;
          theCell.taskContent.lineBreakMode = UILineBreakModeWordWrap;
          theCell.taskContent.numberOfLines = 0;
          [theCell.taskContent sizeToFit];
          theCell.checked = [selectedTask.completed boolValue];
          break;
        case TaskExpiration:
          expireString = [NSString stringWithFormat:@"Expires in %@",
                                    [NSString timeFrom:[NSDate date] toDate:selectedTask.expiration]];
          cell.textLabel.textAlignment = UITextAlignmentCenter;
          cell.textLabel.text = expireString;
          break;
      }
      break;
    case DeleteSection:
      cell.textLabel.textAlignment = UITextAlignmentCenter;
      cell.textLabel.text = @"Delete";
      break;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 0 &&
      indexPath.row == 0)
  {
    NSString *cellText = selectedTask.content;
    UIFont *cellFont = [UIFont boldSystemFontOfSize:17.0f];
    CGSize constraintSize = CGSizeMake(245.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return (labelSize.height < 60) ? 60.0f : labelSize.height + 40;
  }

  return 44.0f;
}

@end
