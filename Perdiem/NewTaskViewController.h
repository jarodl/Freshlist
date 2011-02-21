//
//  NewTaskViewController.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/12/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import "StyledViewController.h"

@interface NewTaskViewController : StyledViewController <UITextViewDelegate>
{
  UITextView *newTaskField;
  UIBarButtonItem *saveTaskButton;
  UIBarButtonItem *cancelButton;
}

@property (nonatomic, retain) IBOutlet UITextView *newTaskField;
@property (nonatomic, retain) UIBarButtonItem *saveTaskButton;
@property (nonatomic, retain) UIBarButtonItem *cancelButton;

- (void)saveTask;
- (void)cancel;

@end
