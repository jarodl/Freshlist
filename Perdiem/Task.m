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
  
  NSDate *currentDate = [dict objectForKey:@"timeStamp"];
  newTask.timeStamp = currentDate;
  
  newTask.completed = [NSNumber numberWithBool:NO];
  newTask.content = [dict objectForKey:@"content"];
  
  [delegate saveContext];
  
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *comps = [[NSDateComponents alloc] init];
  [comps setDay:1];
  // move the expiration date forward one day
  NSDate *expirationDate = [gregorian dateByAddingComponents:comps toDate:currentDate options:0];
  [comps release];
  // then set the time to midnight
  NSDateComponents *expirationComps = [gregorian components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit) fromDate:expirationDate];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"M/d/yyyy"];
  expirationDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%i/%i/%i",
                                                  [expirationComps month], [expirationComps day], [expirationComps year]]];
  [dateFormatter release];
  [gregorian release];
  
  newTask.expiration = expirationDate;

  return newTask;
}

@end
