//
//  CalendarViewController.m
//  tenkay
//
//  Created by Dawson Blackhouse on 1/16/13.
//  Copyright (c) 2013 Jabari Bell and Dawson Blackhouse. All rights reserved.
//

#import "FSBCalendarViewController.h"
#import "FWTPopoverView.h"
#import "Session.h"
#import "Task.h"

@implementation FSBCalendarViewController {
    UIView          *calendarSubView,
    *statSubView;
    FWTPopoverView  *popoverView;
}

@synthesize taskToEdit,
            managedObjectContext,
            titleLabel;

- (void)buildTaskDetailView
{
    NSLog(@"buildTaskDetailView");
    //set title
    titleLabel.text = taskToEdit.title;
    
    //calendar data view
    CGRect  calendarViewRect = CGRectMake(0, 30, 300, 300);
    calendarSubView = [[UIView alloc] initWithFrame:calendarViewRect];
    CKCalendarView *calendar = [[CKCalendarView alloc] init];
    calendar.shouldFillCalendar = YES;
    
    //highlight dates with recorded time
    NSArray *taskSessions = [taskToEdit.taskSession allObjects];
    NSMutableArray *datesToHightlight = [[NSMutableArray alloc] init];
    NSDate *calendarStartDate = [calendar firstDayOfMonthContainingDate:[NSDate date]];
    NSDate *calendarEndDate = [calendar firstDayOfNextMonthContainingDate:[NSDate date]];
    
    for (int i = 0; i < [taskSessions count]; i++) {
        Session *thisSession = (Session *)[taskSessions objectAtIndex:i];
        NSDate *thisStartDate = thisSession.startDate;
        NSDate *thisEndDate = thisSession.endDate;
        if (([thisStartDate earlierDate:calendarStartDate] == calendarStartDate) &&
            ([thisEndDate laterDate:calendarEndDate] == calendarEndDate)
            ) {
            [datesToHightlight addObject:thisStartDate];
        }
    }
    UIImage *tenKIcon = [UIImage imageNamed:@"stopwatch-teal.png"];
    [calendar highlightDatesInArray:datesToHightlight withImage:tenKIcon];
    
    [calendarSubView addSubview:calendar];
    [self.view addSubview:calendarSubView];
    calendar.delegate = self;
    //TODO: show total hours for task
    
    //TODO: show monthly total for task
    
    //TODO: edit button
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetPopUp:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    if (self) {
        // Initialization code
        if (self.taskToEdit != nil) {
            [self buildTaskDetailView];
        }
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)dismissPopOver
{
    if (popoverView != nil) {
        [popoverView dismissPopoverAnimated:YES];
        popoverView = nil;
    }
}

-(void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date atButton:(UIButton *)button
{
    [self dismissPopOver];
    NSArray *taskSessions = [taskToEdit.taskSession allObjects];
    NSTimeInterval totalTimeForDay;
    int numberOfSessions = 0;
    for (int i = 0; i < [taskSessions count];  i++) {
        Session *thisSession = (Session *)[taskSessions objectAtIndex:i];
        NSDate *thisStartDate = thisSession.startDate;
        NSDate *thisEndDate = thisSession.endDate;
        if( [calendar date:thisStartDate isSameDayAsDate:date] ) {
            totalTimeForDay += [thisEndDate timeIntervalSinceDate:thisStartDate];
            numberOfSessions++;
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
    NSDate *totalTimeDate = [NSDate dateWithTimeIntervalSince1970:totalTimeForDay];
    NSString *totalTimeForDayString = [dateFormatter stringFromDate:totalTimeDate];
    
    totalTimeForDayString = [NSString stringWithFormat:@"Time recorded:\n%@", totalTimeForDayString];
    NSString *sessionNumberString = [NSString stringWithFormat:@"Sessions: %d", numberOfSessions];
    NSString *popOverText = [NSString stringWithFormat:@"%@\n\n%@", totalTimeForDayString, sessionNumberString];
    
    UILabel *popOverLabel = [[UILabel alloc] init];
    [popOverLabel setTextColor:[UIColor whiteColor]];
    [popOverLabel setBackgroundColor:[UIColor clearColor]];
    [popOverLabel setFont:[UIFont fontWithName: @"Helvetica" size: 20.0f]];
    [popOverLabel setNumberOfLines:0];
    [popOverLabel sizeToFit];
    [popOverLabel setText:popOverText];
    
    if (totalTimeForDay > 0 && numberOfSessions > 0) {
        //TODO: show total time of sessions recorded for this taskdate
        CGPoint buttonPoint = [calendar convertPoint:button.center toView:self.view];
        CGRect rect = CGRectMake(buttonPoint.x, buttonPoint.y, 300, 300);
        popoverView = [[FWTPopoverView alloc] init];
        popoverView.contentSize = CGSizeMake(240, 240);
        
        [popoverView presentFromRect:rect
                              inView:self.view
                           withLabel:popOverLabel
             permittedArrowDirection:FWTPopoverArrowDirectionNone
                            animated:YES];
    } else {
        [self dismissPopOver];
    }
}

-(void)calendar:(CKCalendarView *)calendar didChangeMonth:(NSDate *)date
{
    [self dismissPopOver];
    NSArray *taskSessions = [taskToEdit.taskSession allObjects];
    NSMutableArray *datesToHightlight = [[NSMutableArray alloc] init];
    NSDate *calendarStartDate = [calendar firstDayOfMonthContainingDate:date];
    NSDate *calendarEndDate = [calendar firstDayOfNextMonthContainingDate:date];
    
    for (int i = 0; i < [taskSessions count]; i++) {
        Session *thisSession = (Session *)[taskSessions objectAtIndex:i];
        NSDate *thisStartDate = thisSession.startDate;
        NSDate *thisEndDate = thisSession.endDate;
        if (([thisStartDate earlierDate:calendarStartDate] == calendarStartDate) &&
            ([thisEndDate laterDate:calendarEndDate] == calendarEndDate)
            ) {
            [datesToHightlight addObject:thisStartDate];
        }
    }
    UIImage *tenKIcon = [UIImage imageNamed:@"stopwatch-teal.png"];
    [calendar highlightDatesInArray:datesToHightlight withImage:tenKIcon];
}

- (void)resetPopUp:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self.view];
    if (popoverView != nil) {
        if (CGRectContainsPoint(popoverView.frame, point)) {
            [self dismissPopOver];
        } else if (!CGRectContainsPoint(calendarSubView.frame, point)){
            [self dismissPopOver];
        }
    }
}

@end
