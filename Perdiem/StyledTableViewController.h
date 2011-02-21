//
//  StyledTableViewController.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/20/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import "StyledViewController.h"

@interface StyledTableViewController : StyledViewController <UITableViewDelegate, UITableViewDataSource>
{
  UITableView *table;
}

@property (nonatomic, retain) IBOutlet UITableView *table;

- (void)loadShadowedTornEdge;

@end
