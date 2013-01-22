//
//  CalendarViewController.m
//  tenkay
//
//  Created by Dawson Blackhouse on 1/16/13.
//  Copyright (c) 2013 Jabari Bell and Dawson Blackhouse. All rights reserved.
//

#import "FSBCalendarViewController.h"
#import "FSBTextUtil.h"
#import "FWTPopoverView.h"
#import "Session.h"
#import "Task.h"

@implementation FSBCalendarViewController {
    UIView          *calendarSubView,
                    *statSubView,
                    *dailyStatSubView;
    UILabel         *dailyStatTitle,
                    *dailyStatHours,
                    *dailyStatSessions;
    FWTPopoverView  *popoverView;
}

@synthesize taskToEdit,
            managedObjectContext,
            titleLabel,
            delegate;

- (void)buildTaskDetailView
{
    //set title
    titleLabel.text = taskToEdit.title;
    
    //build nav
    CGRect navBackground = CGRectMake(0, 0, self.view.bounds.size.width, 44);
    UIView *navBgView = [[UIView alloc] initWithFrame:navBackground];
    UIImageView *navBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav-header"]];
    [navBgView addSubview:navBgImageView];
    [self.view insertSubview:navBgImageView belowSubview:titleLabel];
    
    CGRect backButtonRect = CGRectMake(15, 10, 14, 22);
    UIButton *backButton = [[UIButton alloc] initWithFrame:backButtonRect];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back-arrow"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    //calendar data view
    CGRect  calendarViewRect = CGRectMake(0, 50, 300, 300);
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
    UIImage *tenKIcon = [UIImage imageNamed:@"stopwatch-teal"];
    [calendar highlightDatesInArray:datesToHightlight withImage:tenKIcon];
    
    [calendarSubView addSubview:calendar];
    [self.view addSubview:calendarSubView];
    calendar.delegate = self;
    
    //TODO: show daily hours for task
    CGRect dailyStatRect = CGRectMake(0, 345, self.view.bounds.size.width, 75);
    dailyStatSubView = [[UIView alloc] initWithFrame:dailyStatRect];
    dailyStatSubView.backgroundColor = UIColorFromRGB(0xd7d7d7);
    
    CGRect dailyStatTitleRect = CGRectMake(0, 5, self.view.bounds.size.width, 20);
    dailyStatTitle = [[UILabel alloc] initWithFrame:dailyStatTitleRect];
    dailyStatTitle.text = @"Daily Stats: 00-00";
    dailyStatTitle.backgroundColor = UIColorFromRGB(0xd7d7d7);
    dailyStatTitle.textColor = UIColorFromRGB(0x666666);
    [dailyStatTitle setTextAlignment:NSTextAlignmentCenter];
    [dailyStatSubView addSubview:dailyStatTitle];
    
    CGRect dailyStatsTextBox = CGRectMake(0, 30, self.view.bounds.size.width, 30);
    UIView *dailyStatsTextBoxView = [[UIView alloc] initWithFrame:dailyStatsTextBox];
    [dailyStatSubView addSubview:dailyStatsTextBoxView];
    
    //hours stat
    dailyStatHours = [[UILabel alloc] init];
    [dailyStatHours setText:@"0 hours"];
    dailyStatHours.textColor = UIColorFromRGB(0xffffff);
    dailyStatHours.backgroundColor = UIColorFromRGB(0x4ca8cf);
    dailyStatHours.layer.cornerRadius = 4;
    dailyStatHours.textAlignment = NSTextAlignmentCenter;
    [dailyStatHours sizeToFit];
    dailyStatHours.bounds = CGRectMake(dailyStatHours.bounds.origin.x, dailyStatHours.bounds.origin.y, dailyStatHours.bounds.size.width + 5, dailyStatHours.bounds.size.height);
    [dailyStatHours adjustsFontSizeToFitWidth];
    [dailyStatsTextBoxView addSubview:dailyStatHours];
    
    //sessions stat
    dailyStatSessions = [[UILabel alloc] init];
    dailyStatSessions.frame = CGRectMake(dailyStatHours.frame.size.width + 10, dailyStatSessions.frame.origin.y, dailyStatSessions.frame.size.width, dailyStatSessions.frame.size.height);
    [dailyStatSessions setText:@"0 sessions"];
    dailyStatSessions.textColor = UIColorFromRGB(0xffffff);
    dailyStatSessions.backgroundColor = UIColorFromRGB(0x4ca8cf);
    dailyStatSessions.layer.cornerRadius = 4;
    dailyStatSessions.textAlignment = NSTextAlignmentCenter;
    [dailyStatSessions sizeToFit];
    dailyStatSessions.bounds = CGRectMake(dailyStatSessions.bounds.origin.x, dailyStatSessions.bounds.origin.y, dailyStatSessions.bounds.size.width + 5, dailyStatSessions.bounds.size.height);
    [dailyStatSessions adjustsFontSizeToFitWidth];
    [dailyStatsTextBoxView addSubview:dailyStatSessions];
    
    float textBoxWidth = dailyStatHours.frame.size.width + dailyStatSessions.frame.size.width + 20;
    dailyStatsTextBoxView.frame = CGRectMake(dailyStatSubView.center.x - (textBoxWidth / 2), dailyStatsTextBoxView.frame.origin.y, textBoxWidth, dailyStatHours.frame.size.height);
    
    [self.view addSubview:dailyStatSubView];
    
    //TODO: show monthly total for task
}

- (void) backButtonHandler:(id)sender
{
    [self.delegate calendarViewControllerDidGoBack:self];
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

-(void)setDateLabelToDate:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    dailyStatTitle.text = [NSString stringWithFormat:@"Daily Stats: %d-%d", components.month, components.day];
}

-(void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date atButton:(UIButton *)button
{
    [self setDateLabelToDate:date];
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
    
    NSString *totalTimeForDayString = [FSBTextUtil formatHoursString:[NSNumber numberWithDouble:totalTimeForDay] isTruncated:YES];
    
    if (totalTimeForDay > 0 && numberOfSessions > 0) {
        //TODO: show total time of sessions recorded for this taskdate
        NSLog(@"totalTimeForDayString: %@", totalTimeForDayString);
        [dailyStatSessions setText:[NSString stringWithFormat:@"%d sessions", numberOfSessions]];
        
    }
}

-(void)calendar:(CKCalendarView *)calendar didChangeMonth:(NSDate *)date
{
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
