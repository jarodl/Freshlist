//
//  ShareViewController.h
//  Perdiem
//
//  Created by Jarod Luebbert on 3/3/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import "StyledViewController.h"
#import "SA_OAuthTwitterController.h"
#import "FBConnect.h"

@class SA_OAuthTwitterEngine;

@interface ShareViewController : StyledViewController <SA_OAuthTwitterControllerDelegate, FBSessionDelegate, FBRequestDelegate>
{
  SA_OAuthTwitterEngine *_engine;
}

- (IBAction)useTwitter;
- (IBAction)useFacebook;

@end
