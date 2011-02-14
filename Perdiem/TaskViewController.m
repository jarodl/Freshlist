//
//  TaskViewController.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/12/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import "TaskViewController.h"
#import "TaskCell.h"
#import "Globals.h"
#import "Task.h"

#define NumOfSections 1
#define NumOfRowsInTaskSection 1

enum TaskViewSections {
  TaskSection = 0,
};

enum TaskSectionRows {
  TaskContent = 0,
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
  if ((self = [super initWithStyle:UITableViewStylePlain]))
  {
    selectedTask = task;
    self.hidesBottomBarWhenPushed = YES;
    self.title = @"Task";
    self.cellNib = [UINib nibWithNibName:@"TaskCell" bundle:nil];

    self.tableView.backgroundColor = TableBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
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
  return NumOfRowsInTaskSection;
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

- (void)configureCell:(TaskCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
  [cell setTaskContentText:selectedTask.content];
  cell.accessoryType = UITableViewCellAccessoryNone;
  cell.taskContent.lineBreakMode = UILineBreakModeWordWrap;
  cell.taskContent.numberOfLines = 0;
  [cell.taskContent sizeToFit];
  cell.checked = [selectedTask.completed boolValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *cellText = selectedTask.content;
  UIFont *cellFont = [UIFont boldSystemFontOfSize:17.0f];
  CGSize constraintSize = CGSizeMake(234.0f, MAXFLOAT);
  CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
  
  return labelSize.height + TableViewCellContentMargin;
}

@end
