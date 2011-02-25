//
//  InfoViewController.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/14/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import "InfoViewController.h"
#import "PerdiemAppDelegate.h"
#import "CustomNavigationBar.h"
#import "RootViewController.h"
#import "Globals.h"

@implementation InfoViewController

#pragma mark - View lifecycle

- (void)saveSettings
{
  [(RootViewController *)self.navigationController.delegate flipCurrentView];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = @"Freshlist";
  
  CustomNavigationBar *customNavBar = (CustomNavigationBar *)self.navigationController.navigationBar;
  [customNavBar setBackgroundWith:[UIImage imageNamed:@"blue_navbar"]];

  self.navigationItem.leftBarButtonItem = [self customBarButtonItemWithText:@"Back" withImageName:@"customBarButton"];
  UIButton* leftButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
  [leftButton addTarget:self action:@selector(saveSettings) forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (IBAction)purchaseUpgrade
{
  InAppPurchaseManager *purchaseManager = SharedPurchaseManager;
  [purchaseManager requestProUpgradeProductData];
}

@end
