//
//  RootViewController.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/12/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class TaskCell;

@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate>
{
  UINavigationController *newTaskView;
  UINavigationController *settingsView;
  TaskCell *tmpCell;
  UINib *cellNib;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UINavigationController *newTaskView;
@property (nonatomic, retain) IBOutlet UINavigationController *settingsView;
@property (nonatomic, retain) UINib *cellNib;
@property (nonatomic, retain) IBOutlet TaskCell *tmpCell;

- (void)presentNewTaskView;
- (void)presentSettingsView;
- (IBAction)dismissNewTaskView;
- (IBAction)dismissSettingsView;
- (void)toggleTaskComplete:(NSNotification *)notification;
- (void)removeExpiredTasks;

@end
