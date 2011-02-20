//
//  SettingsViewController.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/14/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import "SettingsViewController.h"
#import "CustomNavigationBar.h"
#import "RootViewController.h"
#import "Globals.h"

#define NumOfSections 1
#define NumOfRows 2

@interface SettingsViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation SettingsViewController

#pragma mark - View lifecycle

- (void)saveSettings
{
  [(RootViewController *)self.navigationController.delegate flipCurrentView];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cardboardBackground"]];
  self.navigationController.navigationBar.tintColor = CardboardButtonColor;
  
  CustomNavigationBar *customNavBar = (CustomNavigationBar *)self.navigationController.navigationBar;
  [customNavBar setBackgroundWith:[UIImage imageNamed:@"cardboard_navbar"]];

  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveSettings)];
  self.navigationItem.leftBarButtonItem = backButton;
  
  self.tableView.separatorColor = CardboardSeparatorColor;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma -
#pragma TableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return @"Upgrade";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
  return @"For a limited time, tell a friend about Freshlist to remove all ads for free.";
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
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = CardboardCellTextColor;
    cell.detailTextLabel.textColor = CardboardLightTextColor;
  }
  
  [self configureCell:cell atIndexPath:indexPath];
  
  return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.row)
  {
    case 0:
      cell.textLabel.text = @"Purchase";
      cell.detailTextLabel.text = @"$1.99";
      break;
    case 1:
      cell.textLabel.text = @"Tell A Friend";
      cell.detailTextLabel.text = @"Free";
    default:
      break;
  }
}

@end
