//
//  TaskViewController.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/12/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import "TaskViewController.h"
#import "FullViewTaskCell.h"
#import "TornEdgeView.h"
#import "LinedView.h"
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
- (void)configureCell:(FullViewTaskCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation TaskViewController

@synthesize selectedTask;
@synthesize cellNib;
@synthesize tmpCell;

- (id)initWithTask:(Task *)task
{
  if ((self = [super initWithNibName:@"StyledViewController" bundle:nil]))
  {
    selectedTask = task;
    self.hidesBottomBarWhenPushed = YES;
    self.title = @"Task";
    self.cellNib = [UINib nibWithNibName:@"FullViewTaskCell" bundle:nil];
    self.table.backgroundColor = DarkTableBackgroundColor;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    showsNotebookLines = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleTaskComplete:) name:@"TaskCellToggled" object:nil];
  }
  
  return self;
}

- (void)viewDidLoad
{
  UIImageView *footer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"taskViewFooter"]];
  footer.backgroundColor = TableBackgroundColor;
  self.table.tableFooterView = footer;
  [super viewDidLoad];
}

- (void)toggleTaskComplete:(NSNotification *)notification
{
  [selectedTask toggle];
  [self.table reloadData];
}

- (void)dealloc
{
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [table deselectRowAtIndexPath:indexPath animated:YES];
}

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
  static NSString *CellIdentifier = @"FullViewTaskCell";

  FullViewTaskCell *cell = (FullViewTaskCell *)[table dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil)
  {
    [self.cellNib instantiateWithOwner:self options:nil];
    cell = tmpCell;
    self.tmpCell = nil;
    
    cell.contentView.backgroundColor = TableBackgroundColor;
    
//    LinedView *bg = [[LinedView alloc] initWithFrame:cell.frame];
//    cell.backgroundView = bg;
//    [bg release];
  }
  
  [self configureCell:cell atIndexPath:indexPath];
  
  return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//  UIImageView *footer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"taskViewFooter"]];
//  footer.backgroundColor = TableBackgroundColor;
//  return [footer autorelease];
//}

- (void)configureCell:(FullViewTaskCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
  cell.taskContent = selectedTask.content;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *cellText = selectedTask.content;
  UIFont *cellFont = [UIFont boldSystemFontOfSize:17.0f];
  CGSize constraintSize = CGSizeMake(234.0f, MAXFLOAT);
  CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
  
  return (labelSize.height < SingleTableViewCellHeight) ? SingleTableViewCellHeight : labelSize.height;
}

@end
