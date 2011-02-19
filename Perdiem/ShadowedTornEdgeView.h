//
//  ShadowedTornEdgeView.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/18/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import "NotebookView.h"

@interface ShadowedTornEdgeView : NotebookView
{
  UIImage *paperImage;
  BOOL showsNotebookLines;
}

@property (assign) BOOL showsNotebookLines;

@end
