//
//  PerdiemAppDelegate.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/12/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "InAppPurchaseManager.h"

#define SharedAdBannerView ((PerdiemAppDelegate *)[[UIApplication sharedApplication] delegate]).bannerView
#define SharedPurchaseManager ((PerdiemAppDelegate *)[[UIApplication sharedApplication] delegate]).purchaseManager

@interface PerdiemAppDelegate : NSObject <UIApplicationDelegate, ADBannerViewDelegate>
{
  ADBannerView *bannerView;
  InAppPurchaseManager *purchaseManager;
}

@property (nonatomic, retain) ADBannerView *bannerView;
@property (nonatomic, retain) InAppPurchaseManager *purchaseManager;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)removeExpiredTasks;
- (void)createBannerView;

@end
