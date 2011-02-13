//
//  TaskViewController.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/12/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Task;
@class TaskCell;

@interface TaskViewController : UITableViewController
{
  Task *selectedTask;
  TaskCell *tmpCell;
  UINib *cellNib;
}

@property (nonatomic, retain) Task *selectedTask;
@property (nonatomic, retain) UINib *cellNib;
@property (nonatomic, retain) IBOutlet TaskCell *tmpCell;

- (id)initWithTask:(Task *)task;
- (void)toggleTaskComplete:(NSNotification *)notification;

@end
