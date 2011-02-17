//
//  SettingsViewController.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/14/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewController : UITableViewController
{
  NSDate *clearTime;
  NSString *clearTimeString;
}

@property (nonatomic, retain) NSDate *clearTime;
@property (nonatomic, retain) NSString *clearTimeString;

- (IBAction)saveSettings;
- (IBAction)cancelSave;
- (void)clearTimeChanged:(NSNotification *)notification;

@end
