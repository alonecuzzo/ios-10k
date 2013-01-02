//
//  FSBAddTaskViewController.h
//  tenkay
//
//  Created by Jabari Bell on 12/28/12.
//  Copyright (c) 2012 Jabari Bell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Task;

@interface FSBAddTaskViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *taskTitle;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) Task *taskToEdit;

@end
