//
//  TaskCell.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/13/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import "TaskCell.h"
#import "Globals.h"
#import "Task.h"
#import "SelectedCellView.h"

@implementation TaskCell

@synthesize taskContentLabel;
@synthesize taskContent;
@synthesize checkBox;
@synthesize task;
@synthesize delegate;

- (id)initWithCoder:(NSCoder *)aDecoder
{
  if ((self = [super initWithCoder:aDecoder]))
  {
    SelectedCellView *background = [[SelectedCellView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView = background;
    [background release];
    
      self.accessoryType = UITableViewCellAccessoryNone;
  }
  return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self toggleTaskCompleted];
  [super touchesBegan:touches withEvent:event];
}

- (void)toggleTaskCompleted
{
    BOOL comp = ![task.completed boolValue];
    task.completed = [NSNumber numberWithBool:comp];
    [self refreshCell];
    [delegate cellWasChecked];
}

- (void)setTask:(Task *)newTask
{
  if (newTask != task)
  {
    [task release];
    task = [newTask retain];
  }
  
  taskContentLabel.text = task.content;
  
  [self refreshCell];
}

- (void)refreshCell
{
  taskContentLabel.textColor = TableViewCellTextColor;
  
  if ([task.completed boolValue])
  {
      taskContentLabel.font = [UIFont systemFontOfSize:17.0f];
    checkBoxView.image = [UIImage imageNamed:@"checked"];
    checkBoxView.alpha = 0.4;
    taskContentLabel.alpha = 0.4;
    self.accessoryType = UITableViewCellAccessoryNone;
  }
  else
  {
      taskContentLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    checkBoxView.image = [UIImage imageNamed:@"unchecked"];
    taskContentLabel.alpha = 1.0;
    checkBoxView.alpha = 1.0;
  }
}

- (void)dealloc
{
  [task release];
  [checkBox release];
  [taskContent release];
  [super dealloc];
}

@end
