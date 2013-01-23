//
//  CalendarViewController.h
//  tenkay
//
//  Created by Dawson Blackhouse on 1/16/13.
//  Copyright (c) 2013 Jabari Bell and Dawson Blackhouse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCalendarView.h"

@class FSBCalendarViewController;
@class Task;

@protocol FSBCalendarViewControllerDelegate <NSObject>
-(void)calendarViewControllerDidGoBack:(FSBCalendarViewController *)controller;
@end

@interface FSBCalendarViewController : UIViewController <CKCalendarDelegate>

@property (nonatomic, weak) id <FSBCalendarViewControllerDelegate> delegate;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) Task *taskForCalendar;

@end