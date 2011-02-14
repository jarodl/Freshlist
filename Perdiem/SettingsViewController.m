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

@end
