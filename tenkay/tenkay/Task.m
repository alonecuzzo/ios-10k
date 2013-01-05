//
//  Task.m
//  tenkay
//
//  Created by Dawson Blackhouse on 1/2/13.
//  Copyright (c) 2013 Jabari Bell. All rights reserved.
//

#import "Task.h"
#import "Session.h"
#import "Tag.h"


@implementation Task

@dynamic creationDate;
@dynamic index;
@dynamic title;
@dynamic totalTime;
@dynamic taskSession;
@dynamic taskTag;

/*
- (void)addTaskSessionObject:(Session *)value
{
    NSLog(@"*** - addTaskSessionObject fired!!");
    NSTimeInterval sessionInterval = [value.endDate timeIntervalSinceDate:value.startDate];
    NSNumber *sessionIntervalNum = [NSNumber numberWithDouble:sessionInterval];
    self.totalTime = [NSNumber numberWithDouble:([self.totalTime doubleValue] + [sessionIntervalNum doubleValue])];
    NSLog(@"***** - self.totalTime: %@", [self.totalTime stringValue]);
    self.taskSession = [self.taskSession setByAddingObject:value];
}
*/

@end
