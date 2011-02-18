//
//  TaskCell.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/13/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <QuartzCore/QuartzCore.h>

@interface TaskCell : UITableViewCell
{
  BOOL checked;

  UIImage *checkBox;
  NSString *taskContent;
  NSIndexPath *cellIndexPath;
  
  IBOutlet UILabel *taskContentLabel;  
  IBOutlet UIImageView *checkBoxView;
}

@property (nonatomic, retain, setter = setTaskContent:) NSString *taskContent;
@property (nonatomic, retain, setter = setCheckBox:) UIImage *checkBox;
@property (retain) NSIndexPath *cellIndexPath;
@property (nonatomic, setter = setChecked:) BOOL checked;

- (void)toggle;
- (void)refreshCheckBoxImage;
- (void)refreshContentFont;

@end
