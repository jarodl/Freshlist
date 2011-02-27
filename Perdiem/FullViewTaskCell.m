//
//  FullViewTaskCell.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/18/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import "FullViewTaskCell.h"
#import "UILabel+sizeToFitFixedWidth.h"
#import "Globals.h"

@implementation FullViewTaskCell

- (void)setTaskContent:(NSString *)newTaskContent
{
  taskContent = newTaskContent;
  taskContentLabel.text = newTaskContent;
  taskContentLabel.textColor = TableViewCellTextColor;
}

//- (void)layoutSubviews
//{
//  [super layoutSubviews];
////  
////  CGSize constraint = CGSizeMake(SingleTableViewCellWidth - (SingleTableViewCellMargin * 2), CGFLOAT_MAX);
////  CGSize size = [taskContent sizeWithFont:[UIFont boldSystemFontOfSize:17.0f]
////                        constrainedToSize:constraint
////                            lineBreakMode:UILineBreakModeWordWrap];
////  CGFloat height = MAX(size.height, 44.0f);
//////  
////  taskContentLabel.frame = CGRectMake(taskContentLabel.frame.origin.x,
////                                    SingleTableViewCellMargin, 
////                                    taskContentLabel.frame.size.width,
////                                    height + (SingleTableViewCellMargin * 2));
//  
//  taskContentLabel.frame = CGRectMake(taskContentLabel.frame.origin.x,
//                                      SingleTableViewCellMargin, 
//                                      taskContentLabel.frame.size.width,
//                                      MAX(taskContentLabel.frame.size.height, SingleTableViewCellHeight));
//
//}

//- (void)layoutSubviews
//{
//  [super layoutSubviews];
//  
//  [taskContentLabel sizeToFitFixedWidth:SingleTableViewCellHeight];
//}

- (void)dealloc
{
  [super dealloc];
}

@end
