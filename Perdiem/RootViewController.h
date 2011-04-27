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
#import "NewTaskViewController.h"
#import "TaskCell.h"

@class TaskCell;

@interface RootViewController : StyledTableViewController <UITextFieldDelegate, TaskCellDelegate, NSFetchedResultsControllerDelegate>
{
  TaskCell *tmpCell;
  UINib *cellNib;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UINib *cellNib;
@property (nonatomic, retain) IBOutlet TaskCell *tmpCell;

- (void)loadPaperStyles;
- (void)toggleTaskComplete:(NSNotification *)notification;

@end
