//
//  PerdiemAppDelegate.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/12/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import "PerdiemAppDelegate.h"
#import "RootViewController.h"
#import "Globals.h"
#import "Task.h"

@implementation PerdiemAppDelegate

@synthesize bannerView;
@synthesize purchaseManager;
@synthesize facebook;
@synthesize window=_window;
@synthesize managedObjectContext=__managedObjectContext;
@synthesize managedObjectModel=__managedObjectModel;
@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;
@synthesize navigationController=_navigationController;

- (void)removeExpiredTasks
{
  NSManagedObjectContext *moc = self.managedObjectContext;
  NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:moc];
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:entityDescription];
  
  NSDate *now = [NSDate date];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
                            @"expiration < %@", now];
  [request setPredicate:predicate];
    
  NSError *error = nil;
  NSArray *array = [moc executeFetchRequest:request error:&error];
  if (array == nil)
  {
    // Deal with error...
  }
  else
  {
    for (Task *expiredTask in array) {
      [moc deleteObject:expiredTask];
    }
  }
  
  [request release];
}

- (void)createBannerView
{
  Class cls = NSClassFromString(@"ADBannerView");
  if (cls) {
    ADBannerView *adBanner = SharedAdBannerView;
    
    NSString *contentSize;
    if (&ADBannerContentSizeIdentifierPortrait != nil)
    {
      contentSize = ADBannerContentSizeIdentifierPortrait;
    }
    else
    {
      // user the older sizes 
      contentSize = ADBannerContentSizeIdentifier320x50;
    }
    
    CGRect frame;
    frame.size = [ADBannerView sizeFromBannerContentSizeIdentifier:contentSize];
    frame.origin = CGPointMake(0.0f, CGRectGetMaxY(self.navigationController.view.bounds));
    
    // Now set the banner view's frame
    adBanner.frame = frame;
    
    // Set the delegate to self, so that we are notified of ad responses.
    adBanner.delegate = self;
    
    // Set the autoresizing mask so that the banner is pinned to the bottom
    adBanner.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    
    // Since we support all orientations in this view controller, support portrait and landscape content sizes.
    // If you only supported landscape or portrait, you could remove the other from this set
    adBanner.requiredContentSizeIdentifiers =
    (&ADBannerContentSizeIdentifierPortrait != nil) ?
    [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, nil] : 
    [NSSet setWithObjects:ADBannerContentSizeIdentifier320x50, nil];
    
    [self.navigationController.view addSubview:adBanner];
    [self.navigationController.view bringSubviewToFront:adBanner];
  }
}

- (void)removeBanner
{
  ADBannerView *adBanner = SharedAdBannerView;
  if (adBanner.bannerLoaded)
  {
    [UIView beginAnimations:@"layoutBanner" context:nil];
    adBanner.frame = CGRectMake(0,
                                CGRectGetMaxY(self.navigationController.view.frame) + adBanner.frame.size.height,
                                adBanner.frame.size.width,
                                adBanner.frame.size.height);
    [UIView commitAnimations];
  }
}

- (void)layoutBanner:(BOOL)animated
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if ([defaults valueForKey:isProUpgradePurchased])
    return;
  
  ADBannerView *adBanner = SharedAdBannerView;
  CGRect contentFrame = self.navigationController.view.frame;
	CGFloat y = CGRectGetMaxY(contentFrame);
  CGFloat bannerHeight = 0.0f;
  
  bannerHeight = adBanner.frame.size.height;
	
  // Depending on if the banner has been loaded, we adjust the content frame and banner location
  // to accomodate the ad being on or off screen.
  // This layout is for an ad at the bottom of the view.
  if (adBanner.bannerLoaded)
  {
    contentFrame.size.height -= bannerHeight;
		y -= bannerHeight;
  }
  
  [UIView beginAnimations:@"layoutBanner" context:nil];
  adBanner.frame = CGRectMake(0, y,  adBanner.frame.size.width, adBanner.frame.size.height);
  [UIView commitAnimations];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // Override point for customization after application launch.
  // Add the navigation controller's view to the window and display.
  RootViewController *rootViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
  rootViewController.managedObjectContext = self.managedObjectContext;
  [self.navigationController pushViewController:rootViewController animated:NO];
  [rootViewController release];
  
  self.bannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
	// Set the autoresizing mask so that the banner is pinned to the bottom
	self.bannerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
	// Since we support all orientations, support portrait and landscape content sizes.
	// If you only supported landscape or portrait, you could remove the other from this set
	self.bannerView.requiredContentSizeIdentifiers = (&ADBannerContentSizeIdentifierPortrait != nil) ?
  [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, nil] : 
  [NSSet setWithObjects:ADBannerContentSizeIdentifier320x50, nil];
  
  self.purchaseManager = [[InAppPurchaseManager alloc] init];

  [self removeExpiredTasks];
  self.navigationController.navigationBar.tintColor = BarTintColor;
  self.navigationController.toolbar.tintColor = BarTintColor;
  
  // set up facebook connect
  Facebook *fb = [[Facebook alloc] initWithAppId:@"132013846869072"];
  self.facebook = fb;
  [fb release];
  
  // if the user is not using the pro version, show ads
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if (![defaults valueForKey:isProUpgradePurchased])
  {
    [self createBannerView];
    [self layoutBanner:YES];
  }
    
  self.window.rootViewController = self.navigationController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
  [self saveContext];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  /*
   Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
   If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   */
  [self saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  /*
   Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
  [self removeExpiredTasks];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Saves changes in the application's managed object context before the application terminates.
  [self saveContext];
}

- (void)dealloc
{
  [bannerView release];
  [purchaseManager release];
  [facebook release];
  [_window release];
  [__managedObjectContext release];
  [__managedObjectModel release];
  [__persistentStoreCoordinator release];
  [_navigationController release];
  [super dealloc];
}

- (void)awakeFromNib
{
}

- (void)saveContext
{
  NSError *error = nil;
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  if (managedObjectContext != nil)
  {
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
    {
      /*
       Replace this implementation with code to handle the error appropriately.
       */
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    } 
  }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
  if (__managedObjectContext != nil)
  {
    return __managedObjectContext;
  }
  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (coordinator != nil)
  {
    __managedObjectContext = [[NSManagedObjectContext alloc] init];
    [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    [__managedObjectContext setRetainsRegisteredObjects:YES];
  }
  return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Perdiem" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Perdiem.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark -
#pragma mark ADBannerViewDelegate methods

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
  // If we don't already have an ad and the root view is showing, display one
  [self layoutBanner:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
  [self layoutBanner:YES];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
  return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
}

#pragma mark -
#pragma mark Facebook Connect
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
  return [facebook handleOpenURL:url];
}

@end
