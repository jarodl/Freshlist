//
//  Task.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/12/11.
//  Copyright (c) 2011 Franana Games. All rights reserved.
//

#import "Task.h"
#import "PerdiemAppDelegate.h"

@implementation Task

@dynamic content;
@dynamic completed;
@dynamic timeStamp;

- (void)toggle
{
  PerdiemAppDelegate *delegate = (PerdiemAppDelegate *)[[UIApplication sharedApplication] delegate];

  BOOL flip = ![self.completed boolValue];
  self.completed = [NSNumber numberWithBool:flip];
  
  [delegate saveContext];
}

+ (Task *)taskFromDictionary:(NSDictionary *)dict
{
  PerdiemAppDelegate *delegate = (PerdiemAppDelegate *)[[UIApplication sharedApplication] delegate];
  Task *newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:delegate.managedObjectContext];
  
  newTask.timeStamp = [dict objectForKey:@"timeStamp"];
  newTask.completed = [NSNumber numberWithBool:NO];
  newTask.content = [dict objectForKey:@"content"];
  
  [delegate saveContext];

  return newTask;
}

@end
