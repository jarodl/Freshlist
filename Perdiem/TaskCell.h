//
//  TaskCell.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/13/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Task;
@protocol TaskCellDelegate;

@interface TaskCell : UITableViewCell
{
  Task *task;
  BOOL showsAccessory;

  UIImage *checkBox;
  NSString *taskContent;
  
  IBOutlet UILabel *taskContentLabel;  
  IBOutlet UIImageView *checkBoxView;
  id <TaskCellDelegate> delegate;
}

@property (nonatomic, retain) UILabel *taskContentLabel;
@property (nonatomic, retain) Task *task;
@property (nonatomic, retain, setter = setTaskContent:) NSString *taskContent;
@property (nonatomic, retain, setter = setCheckBox:) UIImage *checkBox;
@property (nonatomic) BOOL showsAccessory;
@property (nonatomic, retain) id<TaskCellDelegate> delegate;

- (void)refreshCell;

@end

@protocol TaskCellDelegate <NSObject>
- (void)cellWasChecked;
@end