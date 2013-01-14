//
//  FSBTaskDetailViewController.m
//  tenkay
//
//  Created by Jabari Bell on 12/28/12.
//  Copyright (c) 2012 Jabari Bell. All rights reserved.
//

#import "FSBTaskDetailViewController.h"
#import "FSBAppDelegate.h"
#import "Session.h"
#import "Task.h"
#import "FSBTasksViewController.h"
#import "FWTPopoverView.h"

@interface FSBTaskDetailViewController ()
- (IBAction)onCancel:(id)sender;
- (IBAction)onSave:(id)sender;
@end

@implementation FSBTaskDetailViewController {
    UIView  *calendarSubView,
            *statSubView;
    FWTPopoverView *popoverView;
}

@synthesize taskToEdit,
            managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)buildTaskDetailView
{
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
    
    //TODO: edit button
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetPopUp:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (self.taskToEdit != nil) {
        self.navigationItem.title = taskToEdit.title;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onSave:)];
        
        self.taskTitle.hidden = YES;
        [self buildTaskDetailView];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSave:(id)sender
{
    NSLog(@"***** - onSave:");
    Task *task = nil;
    if(self.managedObjectContext) {
        if ([self.taskTitle.text length] > 0) {
            if (self.taskToEdit != nil) {
                NSLog(@"*** - Edit");
                task = self.taskToEdit;
            } else {
                NSLog(@"*** - Save");
                task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
            }
            
            task.title = self.taskTitle.text;
            
            NSError *error;
            if(![self.managedObjectContext save:&error]) {
                NSLog(@"Error Value: %@", [task valueForKey:@"title"]);
            }
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}
- (void)dismissPopOver
{
    if (popoverView != nil) {
        [popoverView dismissPopoverAnimated:YES];
        popoverView = nil;
    }
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

-(void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date atButton:(UIButton *)button
{
    NSLog(@"***DATE SELECTED");
    [self dismissPopOver];
    //TODO: get all sessions recorded on this date for this task
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

@end
