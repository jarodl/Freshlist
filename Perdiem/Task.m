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
  
//  // get the calender
//  NSCalendar *gregorian = [NSCalendar currentCalendar];
//  
//  // set the expiration date to midnight on the day the task was created
//  NSDate *currentDate = [dict objectForKey:@"timeStamp"];
//  NSDateComponents *comps = [[NSDateComponents alloc] init];
//  [comps setDay:1];
//  
//  // move the expiration date forward one day
//  NSDate *expirationDate = [gregorian dateByAddingComponents:comps toDate:currentDate options:0];
//  
//  NSLog(@"Date before midnight: %@", expirationDate);
//  
//  // then set the time to midnight
//  NSDateComponents *expirationComps = [gregorian components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit) fromDate:expirationDate];
//  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//  [dateFormatter setDateFormat:@"M/d/yyyy HH:mm"];
//  expirationDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%i/%i/%i 0:00",
//                                                  [expirationComps month], [expirationComps day], [expirationComps year]]];
//  
//  NSLog(@"%@", [NSString stringWithFormat:@"%i/%i/%i 0:00",
//                [expirationComps month], [expirationComps day], [expirationComps year]]);
//  
//  NSLog(@"Date: %@", expirationDate);
//  
//  // set the task to expire at this date
//  newTask.expiration = expirationDate;
//  [dateFormatter release];
//  [comps release];
  
//  [gregorian release];
  
  newTask.completed = [NSNumber numberWithBool:NO];
  newTask.content = [dict objectForKey:@"content"];
  
  [delegate saveContext];
  
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *comps = [[NSDateComponents alloc] init];
  [comps setDay:1];
  // move the expiration date forward one day
  NSDate *expirationDate = [gregorian dateByAddingComponents:comps toDate:currentDate options:0];
  NSLog(@"Date before midnight: %@", expirationDate);
  // then set the time to midnight
  NSDateComponents *expirationComps = [gregorian components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit) fromDate:expirationDate];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"M/d/yyyy HH:mm"];
  expirationDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%i/%i/%i 0:00",
                                                  [expirationComps month], [expirationComps day], [expirationComps year]]];
  [gregorian release];
  newTask.expiration = expirationDate;
  
//  UILocalNotification *didExpireNotification = [[UILocalNotification alloc] init];
//  didExpireNotification.fireDate = expirationDate;
//  didExpireNotification.timeZone = [NSTimeZone defaultTimeZone];
//  didExpireNotification.userInfo = [NSDictionary dictionaryWithObject:newTask forKey:@"Task"];
//  [[UIApplication sharedApplication] scheduleLocalNotification:didExpireNotification];
//  [didExpireNotification release];

  return newTask;
}

@end
