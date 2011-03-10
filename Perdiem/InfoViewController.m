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
#import "ShareViewController.h"
#import "Globals.h"

@implementation InfoViewController
@synthesize shareCon;
@synthesize shareButton;
@synthesize buyButton;
@synthesize shareLabel;
@synthesize shareDetailLabel;
@synthesize buyLabel;
@synthesize buyDetailLabel;
@synthesize thanksLabel;

#pragma mark - View lifecycle

- (void)saveSettings
{
  [(RootViewController *)self.navigationController.delegate flipCurrentView];
}

- (void)viewDidLoad
{
  self.navigationItem.leftBarButtonItem = [self customBarButtonItemWithText:@"Back" withImageName:@"customBarButton"];
  UIButton* leftButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
  [leftButton addTarget:self action:@selector(saveSettings) forControlEvents:UIControlEventTouchUpInside];
  
  [SharedPurchaseManager loadStore];
  
  if ([[NSUserDefaults standardUserDefaults] valueForKey:isProUpgradePurchased])
    [self updateButtonsAfterPurchase];
    
  [super viewDidLoad];
  
  self.title = @"Freshlist";
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateButtonsAfterPurchase) name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
  
  CustomNavigationBar *customNavBar = (CustomNavigationBar *)self.navigationController.navigationBar;
  [customNavBar setBackgroundWith:[UIImage imageNamed:@"customNavBar"]];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  if ([[NSUserDefaults standardUserDefaults] valueForKey:isProUpgradePurchased])
    [self updateButtonsAfterPurchase];
}

- (void)updateButtonsAfterPurchase
{
  [UIView beginAnimations:@"hideButtonsForPurchase" context:nil];
  buyButton.hidden = YES;
  buyDetailLabel.hidden = YES;
  buyLabel.hidden = YES;
  shareLabel.hidden = YES;
  shareDetailLabel.hidden = YES;
  thanksLabel.hidden = NO;
  [UIView commitAnimations];
}

- (void)dismissShare
{
  [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (IBAction)purchaseUpgrade
{
  InAppPurchaseManager *purchaseManager = SharedPurchaseManager;
  [purchaseManager purchaseProUpgrade];
}

- (IBAction)tellFriends
{
  if ([[NSUserDefaults standardUserDefaults] valueForKey:isProUpgradePurchased])
    return;
  
  ShareViewController *shareView = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
  
  // add buttons for the share screen when it loads
  shareView.navigationItem.leftBarButtonItem = [self customBarButtonItemWithText:@"Back" withImageName:@"customBarButton"];
  UIButton* leftShareButton = (UIButton*)shareView.navigationItem.leftBarButtonItem.customView;
  [leftShareButton addTarget:self action:@selector(dismissShare) forControlEvents:UIControlEventTouchUpInside];

  shareView.title = @"Share Freshlist";
  [shareCon pushViewController:shareView animated:NO];
  [shareView release];
  [self presentModalViewController:shareCon animated:YES];
}

- (void)dealloc
{
  [shareCon release];
  [shareButton release];
  [buyButton release];
  [shareLabel release];
  [shareDetailLabel release];
  [buyLabel release];
  [buyDetailLabel release];
  [thanksLabel release];
  [super dealloc];
}

@end
