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
@synthesize showsAccessory;
@synthesize task;
@synthesize delegate;

- (id)initWithCoder:(NSCoder *)aDecoder
{
  if ((self = [super initWithCoder:aDecoder]))
  {
    SelectedCellView *background = [[SelectedCellView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView = background;
    [background release];
    
    showsAccessory = YES;
  }
  return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  CGPoint location = [(UITouch *)[touches anyObject] locationInView:self];
  if (CGRectContainsPoint(checkBoxView.frame, location))
  {
    BOOL comp = ![task.completed boolValue];
    task.completed = [NSNumber numberWithBool:comp];
    [self refreshCell];
    [delegate cellWasChecked];
    return;
  }
  
  [super touchesBegan:touches withEvent:event];
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
    checkBoxView.image = [UIImage imageNamed:@"checked"];
    checkBoxView.alpha = 0.4;
    taskContentLabel.alpha = 0.4;
    self.accessoryType = UITableViewCellAccessoryNone;
  }
  else
  {
    checkBoxView.image = [UIImage imageNamed:@"unchecked"];
    taskContentLabel.alpha = 1.0;
    checkBoxView.alpha = 1.0;
    if (showsAccessory)
      self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
