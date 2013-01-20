//
//  CalendarViewController.h
//  tenkay
//
//  Created by Dawson Blackhouse on 1/16/13.
//  Copyright (c) 2013 Jabari Bell and Dawson Blackhouse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCalendarView.h"

@class Task;

@interface CalendarViewController : UIViewController <CKCalendarDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) Task *taskToEdit;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@end
