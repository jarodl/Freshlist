//
//  NewTaskViewController.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/12/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTaskViewController : UIViewController <UITextViewDelegate>
{
  UITextView *newTaskField;
}

@property (nonatomic, retain) IBOutlet UITextView *newTaskField;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (IBAction)saveTask;

@end
