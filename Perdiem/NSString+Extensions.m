#import "NSString+Extensions.h"

#define FormatterString @"%i %@"

@implementation NSString (Extensions)

+ (NSString *)timeFrom:(NSDate *)fromDate toDate:(NSDate *)toDate
{
  NSUInteger desiredComponents = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
  NSDateComponents *elapsedTime = [[NSCalendar currentCalendar] components:desiredComponents 
                                                                  fromDate:fromDate
                                                                    toDate:toDate
                                                                   options:0];
  NSString *timeAgo = nil;
  
  if ([elapsedTime year]) {
    timeAgo = [NSString stringWithFormat:FormatterString, [elapsedTime year],
               ([elapsedTime year] == 1) ? @"year" : @"years"];
  }
  else if ([elapsedTime month]) {
    timeAgo = [NSString stringWithFormat:FormatterString, [elapsedTime month],
               ([elapsedTime month] == 1) ? @"month" : @"months"];
  }
  else if ([elapsedTime week]) {
    timeAgo = [NSString stringWithFormat:FormatterString, [elapsedTime week],
               ([elapsedTime week] == 1) ? @"week" : @"weeks"];
  }
  else if ([elapsedTime day]) {
    timeAgo = [NSString stringWithFormat:FormatterString, [elapsedTime day],
               ([elapsedTime day] == 1) ? @"day" : @"days"];
  }
  else if ([elapsedTime hour]) {
    timeAgo = [NSString stringWithFormat:FormatterString, [elapsedTime hour],
               ([elapsedTime hour] == 1) ? @"hour" : @"hours"];
  }
  else if ([elapsedTime minute]) {
    timeAgo = [NSString stringWithFormat:FormatterString, [elapsedTime minute],
               ([elapsedTime minute] == 1) ? @"minute" : @"minutes"];
  }
  else {
    timeAgo = [NSString stringWithFormat:FormatterString, [elapsedTime second],
               ([elapsedTime second] == 1) ? @"second" : @"seconds"];
  }
  
  
  return timeAgo;
}

@end