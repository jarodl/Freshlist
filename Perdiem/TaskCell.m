//
//  TaskCell.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/13/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import "TaskCell.h"
#import "Globals.h"
//#import "AICellGradient.h"

@implementation TaskCell

@synthesize taskContent;
@synthesize checkBox;
@synthesize cellIndexPath;
@synthesize checked;

//+ (Class)layerClass
//{
//  return [AICellGradient class];
//}

- (void)setTaskContent:(NSString *)newTaskContent
{
  taskContent = newTaskContent;
  taskContentLabel.text = newTaskContent;
}

- (void)setCheckBox:(UIImage *)newCheckBox
{
  checkBox = newCheckBox;
  checkBoxView.image = checkBox;
}

- (void)setChecked:(BOOL)isChecked
{
  checked = isChecked;
  [self refreshCheckBoxImage];
  [self refreshContentFont];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  CGPoint location = [(UITouch *)[touches anyObject] locationInView:self];
  if (CGRectContainsPoint(checkBoxView.frame, location))
  {
    [self toggle];
    return;
  }
  
  [super touchesBegan:touches withEvent:event];
}

- (void)toggle
{
  checked = !checked;
  NSDictionary *userInfo = nil;
  if (cellIndexPath)
    userInfo = [NSDictionary dictionaryWithObject:cellIndexPath forKey:@"indexPath"];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskCellToggled" object:nil userInfo:userInfo];
}

- (void)refreshCheckBoxImage
{
  checkBoxView.image = checked ? [UIImage imageNamed:@"checked.png"] : [UIImage imageNamed:@"unchecked.png"];
}

- (void)refreshContentFont
{
  if (checked)
  {
    taskContentLabel.alpha = 0.2;
    checkBoxView.alpha = 0.2;
    self.accessoryType = UITableViewCellAccessoryNone;
  }
  else
  {
    taskContentLabel.alpha = 1.0;
    checkBoxView.alpha = 1.0;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
}

- (void)dealloc
{
  [checkBox release];
  [taskContent release];
  [cellIndexPath release];
  [super dealloc];
}

@end
