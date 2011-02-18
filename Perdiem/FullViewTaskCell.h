//
//  FullViewTaskCell.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/18/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullViewTaskCell : UITableViewCell
{
  NSString *taskContent;
  IBOutlet UILabel *taskContentLabel;  
}

@property (nonatomic, retain, setter = setTaskContent:) NSString *taskContent;

@end
