//
//  Task.h
//  Perdiem
//
//  Created by Jarod Luebbert on 2/12/11.
//  Copyright (c) 2011 Franana Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Task : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSDate * timeStamp;

- (void)toggle;
+ (Task *)taskFromDictionary:(NSDictionary *)dict;

@end
