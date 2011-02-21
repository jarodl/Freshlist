//
//  RootViewController.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/12/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "StyledTableViewController.h"

@class TaskCell;

@interface RootViewController : StyledTableViewController <NSFetchedResultsControllerDelegate>
{
  BOOL frontViewVisible;
  UINavigationController *newTaskView;
  UINavigationController *settingsView;
  TaskCell *tmpCell;
  UINib *cellNib;
}

@property (assign) BOOL frontViewVisible;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UINavigationController *newTaskView;
@property (nonatomic, retain) IBOutlet UINavigationController *settingsView;
@property (nonatomic, retain) UINib *cellNib;
@property (nonatomic, retain) IBOutlet TaskCell *tmpCell;

- (void)loadPaperStyles;
- (void)presentNewTaskView;
- (void)flipCurrentView;
- (void)myTransitionDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
- (IBAction)dismissNewTaskView;
- (IBAction)dismissSettingsView;
- (void)toggleTaskComplete:(NSNotification *)notification;
- (void)removeExpiredTasks;

@end
