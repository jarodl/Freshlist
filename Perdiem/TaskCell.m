//
//  TaskCell.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/13/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import "TaskCell.h"


@implementation TaskCell

- (void)setCheckBoxImage:(UIImage *)image
{
  checkBox.image = image;
}

- (void)setTaskContentText:(NSString *)text
{
  taskContent.text = text;
}

- (void)dealloc
{
  [checkBox release];
  [taskContent release];
  [super dealloc];
}

@end
