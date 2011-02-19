//
//  StyledViewController.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/18/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import "StyledViewController.h"
#import "ShadowedTornEdgeView.h"
#import "CustomNavigationBar.h"
#import "Globals.h"

@implementation StyledViewController

@synthesize table;
@synthesize showsNotebookLines;

- (void)dealloc
{
  [table release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UIImage *paper = [UIImage imageNamed:@"paperTear"];
  CGFloat height = paper.size.height;
  self.table.contentInset = UIEdgeInsetsMake(height - 5, 0.0, height - 5, 0.0);
  
  ShadowedTornEdgeView *tornEdge = [[[ShadowedTornEdgeView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, height)] autorelease];
  tornEdge.showsNotebookLines = showsNotebookLines;
  [self.view addSubview:tornEdge];
  self.table.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"taskViewBackground"]];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return nil;
}

@end
