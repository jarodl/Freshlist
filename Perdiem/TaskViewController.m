//
//  TaskViewController.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/12/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import "TaskViewController.h"
#import "UILabel+sizeToFitFixedWidth.h"
#import "CustomNavigationBar.h"
#import "FullViewTaskCell.h"
#import "TornEdgeView.h"
//#import "LinedView.h"
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
    self.selectedTask = task;
    self.hidesBottomBarWhenPushed = YES;
    self.title = @"Task";
    self.cellNib = [UINib nibWithNibName:@"FullViewTaskCell" bundle:nil];
    self.table.backgroundColor = DarkTableBackgroundColor;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleTaskComplete:) name:@"TaskCellToggled" object:nil];
  }
  
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self loadShadowedTornEdge];
  
  UIImageView *footer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"taskViewFooter"]];
  footer.backgroundColor = [UIColor clearColor];
  self.table.tableFooterView = footer;
  
  UIImageView *header = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"taskViewHeader"]];
  header.backgroundColor = [UIColor clearColor];
  self.table.tableHeaderView = header;
  [super viewDidLoad];  
  CGFloat height = header.frame.size.height;
  self.table.contentInset = UIEdgeInsetsMake(-height, 0, height, 0);

  CustomNavigationBar *customNavigationBar = (CustomNavigationBar *)self.navigationController.navigationBar;
  // Create a custom back button
  UIButton* backButton = [customNavigationBar backButtonWith:[UIImage imageNamed:@"navigationBarBackButton"]
                                                   highlight:nil
                                                leftCapWidth:14.0];
  backButton.titleLabel.textColor = [UIColor whiteColor];
  
  UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  self.navigationItem.leftBarButtonItem = back;
  [back release];
}

- (void)dealloc
{
  [selectedTask release];
  [tmpCell release];
  [cellNib release];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = TableBackgroundColor;
  }
  
  [self configureCell:cell atIndexPath:indexPath];
  
  return cell;
}

- (void)configureCell:(FullViewTaskCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
  cell.task = selectedTask;
  cell.accessoryType = UITableViewCellAccessoryNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *cellText = selectedTask.content;
  
  CGSize constraint = CGSizeMake(SingleTableViewCellWidth - (SingleTableViewCellMargin * 2), CGFLOAT_MAX);
  CGSize size = [cellText sizeWithFont:[UIFont boldSystemFontOfSize:17.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
  CGFloat height = MAX(size.height, SingleTableViewCellHeight);
  height += (SingleTableViewCellMargin * 2);
  
  return height;
}

@end
