//
//  FullViewTaskCell.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/18/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import "FullViewTaskCell.h"
#import "Globals.h"

@implementation FullViewTaskCell

@synthesize taskContent;

- (void)setTaskContent:(NSString *)newTaskContent
{
  taskContent = newTaskContent;
  taskContentLabel.text = newTaskContent;
}

- (void)dealloc
{
    [super dealloc];
}

@end
