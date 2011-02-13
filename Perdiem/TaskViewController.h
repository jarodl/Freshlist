//
//  TaskViewController.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/12/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Task;

@interface TaskViewController : UITableViewController
{
  Task *selectedTask;
}

@property (nonatomic, retain) Task *selectedTask;

- (id)initWithTask:(Task *)task;

@end
