//
//  SettingsViewController.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/14/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import "SettingsViewController.h"
#import "RootViewController.h"
#import "TimeViewController.h"
#import "Globals.h"

#define NumOfSections 2
#define NumOfRowsInFirst 1
#define NumOfRowsInSecond 2

enum Sections {
  ChangeTime = 0,
  RemoveAds = 1
};

@interface SettingsViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation SettingsViewController

@synthesize clearTime;
@synthesize clearTimeString;

#pragma mark - View lifecycle

- (void)saveSettings
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:clearTime forKey:DefaultClearTime];
  [defaults synchronize];
  
  [(RootViewController *)self.navigationController.delegate dismissModalViewControllerAnimated:YES];
}

- (void)cancelSave
{
  [self setClearTime:[[NSUserDefaults standardUserDefaults] objectForKey:DefaultClearTime]];
  [(RootViewController *)self.navigationController.delegate dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = @"Settings";
  
  UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveSettings)];
  self.navigationItem.rightBarButtonItem = saveButton;
  [saveButton release];
  
  UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelSave)];
  self.navigationItem.leftBarButtonItem = cancelButton;
  [cancelButton release];
  
  self.navigationController.navigationBar.tintColor = BarTintColor;
  self.tableView.backgroundColor = TableBackgroundColor;
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearTimeChanged:) name:ClearTimeChanged object:nil];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [self setClearTime:[defaults objectForKey:DefaultClearTime]];
}

- (void)setClearTime:(NSDate *)time
{
  clearTime = [time retain];
  NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
  [timeFormat setDateFormat:TimeFormatString];
  self.clearTimeString = [timeFormat stringFromDate:clearTime];
  [timeFormat release];
}

- (void)clearTimeChanged:(NSNotification *)notification
{
  [self setClearTime:[[notification userInfo] objectForKey:DefaultClearTime]];
  [self.tableView reloadData];
}

- (void)viewDidUnload
{
  clearTime = nil;
  clearTimeString = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self name:ClearTimeChanged object:nil];
  
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

- (void)dealloc
{
  [clearTime release];
  [clearTimeString release];
  [super dealloc];
}

#pragma -
#pragma TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  TimeViewController *timeView = nil;
  
  switch (indexPath.section)
  {
    case ChangeTime:
      timeView = [[[TimeViewController alloc] initWithNibName:@"TimeViewController" bundle:nil] autorelease];
      [self.navigationController pushViewController:timeView animated:YES];
      break;
    case RemoveAds:
      switch (indexPath.row)
      {
        case 0:
          break;
        case 1:
          break;
      }
      break;
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  switch (section) {
    case ChangeTime:
      return @"Settings";
    case RemoveAds:
      return @"Upgrade";
  }
  
  return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
  switch (section) {
    case ChangeTime:
      return @"All items will be cleared every day at this time";
    case RemoveAds:
      return @"Tell a friend about Freshlist and remove the ads for free";
  }

  return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return NumOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  switch (section) {
    case ChangeTime:
      return NumOfRowsInFirst;
    case RemoveAds:
      return NumOfRowsInSecond;
  }
  
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"SettingsCell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  
  [self configureCell:cell atIndexPath:indexPath];
  
  return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.section) {
    case ChangeTime:
      cell.textLabel.text = @"Clear Time";
      cell.detailTextLabel.text = clearTimeString;
      break;
    case RemoveAds:
      switch (indexPath.row) {
        case 0:
          cell.textLabel.text = @"Go Premium";
          cell.detailTextLabel.text = @"$1.99";
          break;
        case 1:
          cell.textLabel.text = @"Tell A Friend";
          cell.detailTextLabel.text = @"$0.00";
          break;
      }
      break;
  }
}

@end
