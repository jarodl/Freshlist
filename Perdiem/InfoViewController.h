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
  IBOutlet UIButton *shareButton;
  IBOutlet UIButton *buyButton;
  IBOutlet UILabel *shareLabel;
  IBOutlet UILabel *shareDetailLabel;
  IBOutlet UILabel *buyLabel;
  IBOutlet UILabel *buyDetailLabel;
  IBOutlet UILabel *thanksLabel;
}

@property (nonatomic, retain) IBOutlet UINavigationController *shareCon;
@property (nonatomic, retain) IBOutlet UIButton *shareButton;
@property (nonatomic, retain) IBOutlet UIButton *buyButton;
@property (nonatomic, retain) IBOutlet UILabel *shareLabel;
@property (nonatomic, retain) IBOutlet UILabel *shareDetailLabel;
@property (nonatomic, retain) IBOutlet UILabel *buyLabel;
@property (nonatomic, retain) IBOutlet UILabel *buyDetailLabel;
@property (nonatomic, retain) IBOutlet UILabel *thanksLabel;

- (void)dismissShare;
- (void)saveSettings;
- (IBAction)purchaseUpgrade;
- (IBAction)tellFriends;
- (void)updateButtonsAfterPurchase;

@end
