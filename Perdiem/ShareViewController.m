//
//  ShareViewController.m
//  Perdiem
//
//  Created by Jarod Luebbert on 3/3/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import "ShareViewController.h"
#import "SA_OAuthTwitterEngine.h"

#define kOAuthConsumerKey	@"hFRNlYt3jevC7NYiLUwwTQ"
#define kOAuthConsumerSecret @"8kGvAHYVgJk96wctWsq7yisi7qc7SWEFmHQy7g2g"

@implementation ShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
  {
    _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
    _engine.consumerKey = kOAuthConsumerKey;
    _engine.consumerSecret = kOAuthConsumerSecret;
  }
  
  return self;
}

- (IBAction)useTwitter
{
	UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
  [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)useFacebook
{
}

- (void)dealloc
{
  [_engine release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//=============================================================================================================================
#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
  
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

//=============================================================================================================================
#pragma mark SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	NSLog(@"Authenicated for %@", username);
  [_engine sendUpdate:@"Just received 50% off of Freshlist for iPhone! http://goo.gl/GR8ek"];
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Failed!");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Canceled.");
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	NSLog(@"Request %@ succeeded", requestIdentifier);
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}

@end
