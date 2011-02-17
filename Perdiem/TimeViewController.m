//
//  TimeViewController.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/16/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import "TimeViewController.h"
#import "Globals.h"

@implementation TimeViewController

@synthesize tutorialText;
@synthesize timePicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
  {
    self.title = @"Clear Time";
    self.view.backgroundColor = TableBackgroundColor;
  }
  
  return self;
}

- (void)dealloc
{
  [tutorialText release];
  [timePicker release];
  [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  timePicker.date = [defaults objectForKey:DefaultClearTime];
}

- (void)viewWillDisappear:(BOOL)animated
{
  NSDictionary *userInfo = [NSDictionary dictionaryWithObject:timePicker.date forKey:DefaultClearTime];
  [[NSNotificationCenter defaultCenter] postNotificationName:ClearTimeChanged object:self userInfo:userInfo];
  
  [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

@end
