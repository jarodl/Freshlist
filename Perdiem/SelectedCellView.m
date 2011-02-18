//
//  SelectedCellView.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/18/11.
//  Copyright 2011 Franana Games. All rights reserved.
//

#import "SelectedCellView.h"
#import "AICellGradient.h"

@implementation SelectedCellView

+ (Class)layerClass
{
	return [AICellGradient class];	
}

- (void)dealloc
{
    [super dealloc];
}

@end
