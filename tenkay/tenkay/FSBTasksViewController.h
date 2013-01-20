//
//  FSBTaksViewController.h
//  tenkay
//
//  Created by Jabari Bell on 12/28/12.
//  Copyright (c) 2012 Jabari Bell. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Task;

@protocol FSBTasksViewDelegate <NSObject>

@required
- (void)deleteTask:(Task *)task;
- (void)addTime:(Task *)task;
@end

@interface FSBTasksViewController : UITableViewController <NSFetchedResultsControllerDelegate, FSBTasksViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
