//
//  FSBTaksViewController.h
//  tenkay
//
//  Created by Jabari Bell and Dawson Blackhouse on 12/28/12.
//  Copyright (c) 2012 Jabari Bell and Dawson Blackhouse. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Task;

@protocol FSBTasksViewDelegate <NSObject>

@required
- (void)deleteTask:(Task *)task;
- (void)addTime:(Task *)task;
- (void)openCalendar:(Task *)task;
@end

@interface FSBTasksViewController : UITableViewController <NSFetchedResultsControllerDelegate, FSBTasksViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
