//
//  Session.h
//  tenkay
//
//  Created by Jabari Bell on 12/28/12.
//  Copyright (c) 2012 Jabari Bell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface Session : NSManagedObject

@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) Task *sessionTask;

@end
