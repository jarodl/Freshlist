//
//  NotebookView.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/14/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotebookView : UIView
{
  BOOL hasHighResScreen;
}

@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;

@end
