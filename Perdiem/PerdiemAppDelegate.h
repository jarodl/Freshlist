//
//  PerdiemAppDelegate.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/12/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PerdiemAppDelegate : NSObject <UIApplicationDelegate>
{
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
