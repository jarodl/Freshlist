//
//  TaskCell.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/13/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import "TaskCell.h"
#import "Globals.h"
#import "AICellGradient.h"

@implementation TaskCell

@synthesize cellIndexPath;
@synthesize checked;
@synthesize taskContent;

//+ (Class)layerClass
//{
//  return [AICellGradient class];
//}

- (void)setChecked:(BOOL)c
{
  checked = c;
  [self refreshCheckBoxImage];
  [self refreshContentFont];
}

- (void)setCheckBoxImage:(UIImage *)image
{
  checkBox.image = image;
}

- (void)setTaskContentText:(NSString *)text
{
  taskContent.text = text;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  CGPoint location = [(UITouch *)[touches anyObject] locationInView:self];
  if (CGRectContainsPoint(checkBox.frame, location))
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
  checkBox.image = checked ? [UIImage imageNamed:@"checked.png"] : [UIImage imageNamed:@"unchecked.png"];
}

- (void)refreshContentFont
{
  if (checked)
  {
    taskContent.alpha = 0.2;
    checkBox.alpha = 0.2;
    self.accessoryType = UITableViewCellAccessoryNone;
  }
  else
  {
    taskContent.alpha = 1.0;
    checkBox.alpha = 1.0;
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
