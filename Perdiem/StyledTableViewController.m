//
//  StyledTableViewController.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/20/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import "StyledTableViewController.h"
#import "ShadowedTornEdgeView.h"

@implementation StyledTableViewController

@synthesize table;

- (void)dealloc
{
  [table release];
  [super dealloc];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)loadShadowedTornEdge
{
  UIImage *paper = [UIImage imageNamed:@"paperTear"];
  CGFloat height = paper.size.height;
  self.table.contentInset = UIEdgeInsetsMake(height, 0.0, height, 0.0);
  
  ShadowedTornEdgeView *tornEdge = [[[ShadowedTornEdgeView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, height)] autorelease];
  [self.view addSubview:tornEdge];
  self.table.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"taskViewBackground"]];
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
