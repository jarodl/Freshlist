//
//  Task.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/12/11.
//  Copyright (c) 2011 Jarod Luebbert. All rights reserved.
//

#import "Task.h"
#import "PerdiemAppDelegate.h"

@implementation Task

@dynamic content;
@dynamic completed;
@dynamic timeStamp;
@dynamic expiration;

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
  
  // if the timeStamp is greater than the default clear time for the current date,
  // set the clear time
  
  // Add 16 hours to the time stamp and set the task to expire then
  NSDate *currentDate = [dict objectForKey:@"timeStamp"];
  NSDateComponents *comps = [[NSDateComponents alloc] init];
  [comps setHour:16];
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  newTask.expiration = [gregorian dateByAddingComponents:comps toDate:currentDate options:0];
  [gregorian release];
  [comps release];
  
  newTask.completed = [NSNumber numberWithBool:NO];
  newTask.content = [dict objectForKey:@"content"];
  
  [delegate saveContext];

  return newTask;
}

@end
