//
//  RootViewController.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/12/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class TaskCell;

@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate>
{
  UINavigationController *newTaskView;
  TaskCell *tmpCell;
  UINib *cellNib;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UINavigationController *newTaskView;
@property (nonatomic, retain) UINib *cellNib;
@property (nonatomic, retain) IBOutlet TaskCell *tmpCell;

- (void)presentNewTaskView;
- (IBAction)dismissNewTaskView;
- (void)toggleTaskComplete:(NSNotification *)notification;

@end
