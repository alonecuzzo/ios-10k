//
//  Task.h
//  tenkay
//
//  Created by Jabari Bell on 12/28/12.
//  Copyright (c) 2012 Jabari Bell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Session, Tag;

@interface Task : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSSet *taskSession;
@property (nonatomic, retain) NSSet *taskTag;
@end

@interface Task (CoreDataGeneratedAccessors)

- (void)addTaskSessionObject:(Session *)value;
- (void)removeTaskSessionObject:(Session *)value;
- (void)addTaskSession:(NSSet *)values;
- (void)removeTaskSession:(NSSet *)values;

- (void)addTaskTagObject:(Tag *)value;
- (void)removeTaskTagObject:(Tag *)value;
- (void)addTaskTag:(NSSet *)values;
- (void)removeTaskTag:(NSSet *)values;

@end
