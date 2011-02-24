//
//  TaskViewController.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/12/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import "StyledTableViewController.h"

@class Task;
@class FullViewTaskCell;

@interface TaskViewController : StyledTableViewController
{
  Task *selectedTask;
  FullViewTaskCell *tmpCell;
  UINib *cellNib;
}

@property (nonatomic, retain) Task *selectedTask;
@property (nonatomic, retain) UINib *cellNib;
@property (nonatomic, retain) IBOutlet FullViewTaskCell *tmpCell;

- (id)initWithTask:(Task *)task;
- (void)back;

@end
