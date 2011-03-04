//
//  InfoViewController.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/14/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import "StyledViewController.h"

@interface InfoViewController : StyledViewController
{
  IBOutlet UINavigationController *shareCon;
}

@property (nonatomic, retain) IBOutlet UINavigationController *shareCon;

- (void)dismissShare;
- (void)saveSettings;
- (IBAction)purchaseUpgrade;
- (IBAction)tellFriends;

@end
