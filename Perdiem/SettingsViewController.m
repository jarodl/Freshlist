//
//  SettingsViewController.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/14/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import "SettingsViewController.h"
#import "RootViewController.h"
#import "Globals.h"

#define NumOfSections 1
#define NumOfRows 2

@interface SettingsViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation SettingsViewController

#pragma mark - View lifecycle

- (IBAction)saveSettings
{
  [(RootViewController *)self.navigationController.delegate dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.navigationController.navigationBar.tintColor = BarTintColor;
  self.tableView.backgroundColor = TableBackgroundColor;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

#pragma -
#pragma TableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return @"Upgrades";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
  return @"Tell a friend about Freshlist to remove all ads for free.";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return NumOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return NumOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"SettingsCell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  
  [self configureCell:cell atIndexPath:indexPath];
  
  return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.row) {
    case 0:
      cell.textLabel.text = @"Go Premium";
      cell.detailTextLabel.text = @"New theme, remove all ads";
      break;
    case 1:
      cell.textLabel.text = @"Tell A Friend";
      cell.detailTextLabel.text = @"Remove all ads for free";
    default:
      break;
  }
}

@end
