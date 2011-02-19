//
//  StyledViewController.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/18/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StyledViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
  UITableView *table;
  BOOL showsNotebookLines;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (assign) BOOL showsNotebookLines;

@end
