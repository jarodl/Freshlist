//
//  TaskCell.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/13/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface TaskCell : UITableViewCell
{
  BOOL checked;
  IBOutlet UIImageView *checkBox;
  IBOutlet UILabel *taskContent;
  NSIndexPath *cellIndexPath;
}

@property (nonatomic, retain) NSIndexPath *cellIndexPath;
@property (nonatomic) BOOL checked;
@property (nonatomic, retain) IBOutlet UILabel *taskContent;

- (void)setCheckBoxImage:(UIImage *)image;
- (void)setTaskContentText:(NSString *)text;
- (void)toggle;
- (void)refreshCheckBoxImage;
- (void)refreshContentFont;

@end
