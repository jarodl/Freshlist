//
//  NewTaskViewController.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/12/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import "StyledViewController.h"

@protocol TaskAddDelegate;
@class Task;

@interface NewTaskViewController : StyledViewController <UITextViewDelegate>
{
  @private
  Task *task;
  UITextView *newTaskField;
  UIBarButtonItem *saveTaskButton;
  UIBarButtonItem *cancelButton;
  id<TaskAddDelegate> delegate;
}

@property (nonatomic, retain) Task *task;
@property (nonatomic, retain) IBOutlet UITextView *newTaskField;
@property (nonatomic, retain) UIBarButtonItem *saveTaskButton;
@property (nonatomic, retain) UIBarButtonItem *cancelButton;
@property (nonatomic, assign) id <TaskAddDelegate> delegate;

- (void)saveTask;
- (void)cancel;

@end

@protocol TaskAddDelegate <NSObject>

- (void)newTaskViewController:(NewTaskViewController *)newTaskViewController didAddTask:(Task *)task;

@end