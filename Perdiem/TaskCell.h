//
//  TaskCell.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/13/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskCell : UITableViewCell
{
  IBOutlet UIImageView *checkBox;
  IBOutlet UILabel *taskContent;
}

- (void)setCheckBoxImage:(UIImage *)image;
- (void)setTaskContentText:(NSString *)text;

@end
