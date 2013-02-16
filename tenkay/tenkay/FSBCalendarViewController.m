//
//  CalendarViewController.m
//  tenkay
//
//  Created by Dawson Blackhouse on 1/16/13.
//  Copyright (c) 2013 Jabari Bell and Dawson Blackhouse. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FSBCalendarViewController.h"
#import "FSBTextUtil.h"
#import "Session.h"
#import "Task.h"

#define DAILY_STAT_VIEW_HEIGHT 50
#define MONTH_STAT_VIEW_HEIGHT 50

@implementation FSBCalendarViewController {
    UIView          *calendarSubView,
                    *statSubView,
                    *dailyStatSubView,
                    *dailyStatsTextBoxView,
                    *monthStatSubView,
                    *monthStatsTextBoxView;
    UILabel         *dailyStatTitle,
                    *dailyStatHours,
                    *dailyStatSessions,
                    *monthStatHours,
                    *monthStatSessions,
                    *monthStatAverage;
    UIScrollView    *scrollView;
    CKCalendarView  *calendar;
}

@synthesize taskForCalendar,
            managedObjectContext;

- (void)buildTaskDetailView
{
    //set title
    self.title = taskForCalendar.title;
    
    //style back button
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 41, 40)];
    [backButton setImage:[UIImage imageNamed:@"back-arrow"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onCancelPress:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [self buildDailyStatBox];
    [self buildMonthlyStatBox];
    [self buildCalendarBox];
}

- (void) buildCalendarBox
{
    //calendar data view
    CGRect  calendarViewRect = CGRectMake(0, 0, 305, 310);
    calendarSubView = [[UIView alloc] initWithFrame:calendarViewRect];
    calendar = [[CKCalendarView alloc] init];
    calendar.shouldFillCalendar = YES;
    
    //highlight dates with recorded time
    NSArray *taskSessions = [taskForCalendar.taskSession allObjects];
    NSMutableArray *datesToHightlight = [[NSMutableArray alloc] init];
    NSDate *calendarStartDate = [calendar firstDayOfMonthContainingDate:[NSDate date]];
    NSDate *calendarEndDate = [calendar firstDayOfNextMonthContainingDate:[NSDate date]];
    NSTimeInterval monthTimeInt = 0;
    int sessionCount = 0;
    
    for (int i = 0; i < [taskSessions count]; i++) {
        Session *thisSession = (Session *)[taskSessions objectAtIndex:i];
        NSDate *thisStartDate = thisSession.startDate;
        NSDate *thisEndDate = thisSession.endDate;
        if (([thisStartDate earlierDate:calendarStartDate] == calendarStartDate) &&
            ([thisEndDate laterDate:calendarEndDate] == calendarEndDate)
            ) {
            [datesToHightlight addObject:thisStartDate];
            monthTimeInt += [thisEndDate timeIntervalSinceDate:thisStartDate];
            sessionCount++;
        }
    }
    
    [self setDateLabelToDate:[NSDate date]];
    
    [calendar highlightDatesInArray:datesToHightlight];
    
    monthStatHours.text = [FSBTextUtil stringFromNumSeconds:[NSNumber numberWithDouble:monthTimeInt] isTruncated:NO];
    if(sessionCount == 1)
        monthStatSessions.text = [NSString stringWithFormat:@"%d session", sessionCount];
    else
        monthStatSessions.text = [NSString stringWithFormat:@"%d sessions", sessionCount];
    [self adjustMonthLabels];
    
    [calendarSubView addSubview:calendar];
    [scrollView addSubview:calendarSubView];
    calendar.delegate = self;
    
    NSTimeInterval secondsInMonth = [calendarEndDate timeIntervalSinceDate:calendarStartDate];
    int days = secondsInMonth / 86400;
    double timePerDay = monthTimeInt / days;
    monthStatAverage.text = [NSString stringWithFormat:@"%@ avg", [FSBTextUtil stringFromNumSeconds:[NSNumber numberWithDouble:timePerDay] isTruncated:NO]];
    [self adjustMonthLabels];
}

- (void) buildDailyStatBox
{
    CGRect dailyStatRect = CGRectMake(0, 295, self.view.bounds.size.width, DAILY_STAT_VIEW_HEIGHT);
    dailyStatSubView = [[UIView alloc] initWithFrame:dailyStatRect];
    dailyStatSubView.backgroundColor = UIColorFromRGB(0xd7d7d7);
    
    UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"light-line-separator"]];
    separator.frame = CGRectMake(dailyStatSubView.center.x - (separator.bounds.size.width / 2), DAILY_STAT_VIEW_HEIGHT / 2, separator.frame.size.width, separator.frame.size.height);
    [dailyStatSubView addSubview:separator];
    
    CGRect dailyStatsTextBox = CGRectMake(0, separator.frame.origin.y + 3, self.view.bounds.size.width, 30);
    dailyStatsTextBoxView = [[UIView alloc] initWithFrame:dailyStatsTextBox];
    [dailyStatSubView addSubview:dailyStatsTextBoxView];
    
    CGRect dailyStatTitleRect = CGRectMake(0, separator.frame.origin.y - 20, self.view.bounds.size.width, 20);
    dailyStatTitle = [[UILabel alloc] initWithFrame:dailyStatTitleRect];
    dailyStatTitle.text = @"Daily Stats: 00-00";
    dailyStatTitle.backgroundColor = UIColorFromRGB(0xd7d7d7);
    dailyStatTitle.textColor = UIColorFromRGB(0x666666);
    dailyStatTitle.font = [UIFont fontWithName:@"Myanmar MN" size:16];
    [dailyStatTitle setTextAlignment:NSTextAlignmentCenter];
    [dailyStatSubView addSubview:dailyStatTitle];
    
    //hours stat
    dailyStatHours = [[UILabel alloc] init];
    [dailyStatHours setText:@"0 hours"];
    dailyStatHours.textColor = UIColorFromRGB(0xffffff);
    dailyStatHours.backgroundColor = UIColorFromRGB(0x4ca8cf);
    dailyStatHours.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    dailyStatHours.layer.cornerRadius = 4;
    dailyStatHours.textAlignment = NSTextAlignmentCenter;
    [dailyStatsTextBoxView addSubview:dailyStatHours];
    
    //sessions stat
    dailyStatSessions = [[UILabel alloc] init];
    [dailyStatSessions setText:@"0 sessions"];
    dailyStatSessions.textColor = UIColorFromRGB(0xffffff);
    dailyStatSessions.backgroundColor = UIColorFromRGB(0x4ca8cf);
    dailyStatSessions.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    dailyStatSessions.layer.cornerRadius = 4;
    dailyStatSessions.textAlignment = NSTextAlignmentCenter;
    [dailyStatsTextBoxView addSubview:dailyStatSessions];
    
    [self adjustDailyLabels];
    
    [scrollView addSubview:dailyStatSubView];
}

-(void)adjustDailyLabels
{
    [dailyStatHours sizeToFit];
    dailyStatHours.bounds = CGRectMake(dailyStatHours.bounds.origin.x, dailyStatHours.bounds.origin.y, dailyStatHours.bounds.size.width + 5, dailyStatHours.bounds.size.height);
    [dailyStatHours adjustsFontSizeToFitWidth];
    
    [dailyStatSessions sizeToFit];
    dailyStatSessions.frame = CGRectMake(dailyStatHours.frame.size.width + 10, dailyStatSessions.frame.origin.y, dailyStatSessions.frame.size.width, dailyStatSessions.frame.size.height);
    dailyStatSessions.bounds = CGRectMake(dailyStatSessions.bounds.origin.x, dailyStatSessions.bounds.origin.y, dailyStatSessions.bounds.size.width + 5, dailyStatSessions.bounds.size.height);
    [dailyStatSessions adjustsFontSizeToFitWidth];
    
    float textBoxWidth = dailyStatHours.frame.size.width + dailyStatSessions.frame.size.width;
    
    dailyStatsTextBoxView.bounds = CGRectMake(dailyStatsTextBoxView.bounds.origin.x, calendarSubView.bounds.origin.y + 5, textBoxWidth, dailyStatHours.bounds.size.height);
    
    dailyStatsTextBoxView.frame = CGRectMake(dailyStatSubView.center.x - (textBoxWidth / 2), dailyStatsTextBoxView.frame.origin.y, textBoxWidth, dailyStatHours.frame.size.height);
}

- (void)buildMonthlyStatBox
{
    CGRect monthStatRect = CGRectMake(0, 380, self.view.bounds.size.width, MONTH_STAT_VIEW_HEIGHT);
    monthStatSubView = [[UIView alloc] initWithFrame:monthStatRect];
    monthStatSubView.backgroundColor = UIColorFromRGB(0xd7d7d7);
    
    UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"light-line-separator"]];
    separator.frame = CGRectMake(monthStatSubView.center.x - (separator.frame.size.width / 2), MONTH_STAT_VIEW_HEIGHT / 2, separator.frame.size.width, separator.frame.size.height);
    [monthStatSubView addSubview:separator];
    
    CGRect monthStatsTextBox = CGRectMake(0, separator.frame.origin.y + 3, self.view.bounds.size.width, 30);
    monthStatsTextBoxView = [[UIView alloc] initWithFrame:monthStatsTextBox];
    monthStatsTextBoxView.backgroundColor = [UIColor clearColor];
    [monthStatSubView addSubview:monthStatsTextBoxView];
    
    CGRect monthlyStatTitleRect = CGRectMake(0, separator.frame.origin.y - 20, self.view.bounds.size.width, 20);
    UILabel *monthStatTitle = [[UILabel alloc] initWithFrame:monthlyStatTitleRect];
    monthStatTitle.text = @"Monthly Stats";
    monthStatTitle.backgroundColor = UIColorFromRGB(0xd7d7d7);
    monthStatTitle.textColor = UIColorFromRGB(0x666666);
    monthStatTitle.font = [UIFont fontWithName:@"Myanmar MN" size:16];
    [monthStatTitle setTextAlignment:NSTextAlignmentCenter];
    [monthStatSubView addSubview:monthStatTitle];
    
    //show monthly hours
    monthStatHours = [[UILabel alloc] init];
    [monthStatHours setText:@"0 hours"];
    monthStatHours.textColor = UIColorFromRGB(0xffffff);
    monthStatHours.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    monthStatHours.backgroundColor = UIColorFromRGB(0x999999);
    monthStatHours.layer.cornerRadius = 4;
    monthStatHours.textAlignment = NSTextAlignmentCenter;
    
    //show session number
    monthStatSessions = [[UILabel alloc] init];
    monthStatSessions.frame = CGRectMake(monthStatHours.frame.size.width + 10, monthStatSessions.frame.origin.y, monthStatSessions.frame.size.width, monthStatSessions.frame.size.height);
    [monthStatSessions setText:@"0 sessions"];
    monthStatSessions.textColor = UIColorFromRGB(0xffffff);
    monthStatSessions.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    monthStatSessions.backgroundColor = UIColorFromRGB(0x999999);
    monthStatSessions.layer.cornerRadius = 4;
    monthStatSessions.textAlignment = NSTextAlignmentCenter;
    
    //show monthly average
    monthStatAverage = [[UILabel alloc] init];
    monthStatAverage.frame = CGRectMake(monthStatSessions.frame.origin.x + monthStatSessions.frame.size.width + 12, monthStatAverage.frame.origin.y, monthStatAverage.frame.size.width, monthStatAverage.frame.size.height);
    [monthStatAverage setText:@"0 average"];
    monthStatAverage.textColor = UIColorFromRGB(0xffffff);
    monthStatAverage.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    monthStatAverage.backgroundColor = UIColorFromRGB(0x999999);
    monthStatAverage.layer.cornerRadius = 4;
    monthStatAverage.textAlignment = NSTextAlignmentCenter;
    
    [self adjustMonthLabels];
    
    [scrollView addSubview:monthStatSubView];
}

- (void)adjustMonthLabels
{
    [monthStatHours sizeToFit];
    monthStatHours.frame = CGRectMake(monthStatHours.bounds.origin.x, monthStatHours.bounds.origin.y, monthStatHours.bounds.size.width + 5, monthStatHours.bounds.size.height);
    [monthStatHours adjustsFontSizeToFitWidth];
    [monthStatsTextBoxView addSubview:monthStatHours];
    float textBoxWidth = monthStatHours.bounds.size.width;
    
    [monthStatSessions sizeToFit];
    monthStatSessions.frame = CGRectMake(monthStatSessions.bounds.origin.x + monthStatHours.bounds.size.width + 10, monthStatSessions.bounds.origin.y, monthStatSessions.bounds.size.width + 5, monthStatSessions.bounds.size.height);
    [monthStatSessions adjustsFontSizeToFitWidth];
    [monthStatsTextBoxView addSubview:monthStatSessions];
    textBoxWidth += monthStatSessions.bounds.size.width;
    
    [monthStatAverage sizeToFit];
    monthStatAverage.frame = CGRectMake(monthStatAverage.bounds.origin.x + monthStatSessions.bounds.size.width + monthStatHours.bounds.size.width + 20, monthStatAverage.bounds.origin.y, monthStatAverage.bounds.size.width + 5, monthStatAverage.bounds.size.height);
    [monthStatAverage adjustsFontSizeToFitWidth];
    [monthStatsTextBoxView addSubview:monthStatAverage];
    textBoxWidth += monthStatAverage.bounds.size.width;
    
    monthStatsTextBoxView.frame = CGRectMake(monthStatSubView.center.x - (textBoxWidth / 2), monthStatsTextBoxView.frame.origin.y, textBoxWidth, dailyStatHours.frame.size.height);
}

- (void)onCancelPress:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    if (self) {
        // Initialization code
        if (self.taskForCalendar != nil) {
            
            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 45)];
            [scrollView setContentSize:self.view.frame.size];
            [self.view addSubview:scrollView];
            
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

-(void)calendar:(CKCalendarView *)thisCalendar didSelectDate:(NSDate *)date atButton:(UIButton *)button
{
    [self setDateLabelToDate:date];
    NSArray *taskSessions = [taskForCalendar.taskSession allObjects];
    NSTimeInterval totalTimeForDay = 0;
    int numberOfSessions = 0;
    for (int i = 0; i < [taskSessions count];  i++) {
        Session *thisSession = (Session *)[taskSessions objectAtIndex:i];
        NSDate *thisStartDate = thisSession.startDate;
        NSDate *thisEndDate = thisSession.endDate;
        if( [thisCalendar date:thisStartDate isSameDayAsDate:date] ) {
            totalTimeForDay += [thisEndDate timeIntervalSinceDate:thisStartDate];
            numberOfSessions++;
        }
    }
    
    NSString *totalTimeForDayString = [FSBTextUtil stringFromNumSeconds:[NSNumber numberWithDouble:totalTimeForDay] isTruncated:YES];
    
    if (totalTimeForDay > 0 && numberOfSessions > 0) {
        //TODO: show total time of sessions recorded for this taskdate
        NSLog(@"totalTimeForDayString: %@", totalTimeForDayString);
        [dailyStatHours setText:[FSBTextUtil stringFromNumSeconds:[NSNumber numberWithDouble:totalTimeForDay] isTruncated:NO]];
        [dailyStatHours sizeToFit];
        dailyStatHours.frame = [self addPadding:20 toFrame:dailyStatHours.frame];
        
        [dailyStatSessions setText:[NSString stringWithFormat:@"%d sessions", numberOfSessions]];
        [dailyStatSessions sizeToFit];
        dailyStatSessions.frame = [self addPadding:20 toFrame:dailyStatSessions.frame];
    }
    else {
        [dailyStatHours setText:@"0 hours"];
        [dailyStatHours sizeToFit];
        dailyStatHours.frame = [self addPadding:20 toFrame:dailyStatHours.frame];
        
        [dailyStatSessions setText:@"0 sessions"];
        [dailyStatSessions sizeToFit];
        dailyStatSessions.frame = [self addPadding:20 toFrame:dailyStatSessions.frame];
    }
    
    dailyStatSessions.frame = CGRectMake(dailyStatHours.frame.origin.x +dailyStatHours.frame.size.width + 10, dailyStatSessions.frame.origin.y, dailyStatSessions.frame.size.width, dailyStatSessions.frame.size.height);
    
    float textWidth = dailyStatHours.frame.size.width + dailyStatSessions.frame.size.width + 10;
    
    dailyStatsTextBoxView.frame = CGRectMake(dailyStatsTextBoxView.center.x - (textWidth / 2), dailyStatsTextBoxView.frame.origin.y, textWidth, dailyStatsTextBoxView.frame.size.height);
    [self adjustMonthLabels];
}

-(CGRect)addPadding:(int)padding toFrame:(CGRect)frameToAdjust
{
    CGRect returnFrame = CGRectMake(frameToAdjust.origin.x, frameToAdjust.origin.y, frameToAdjust.size.width + padding, frameToAdjust.size.height);
    return returnFrame;
}

-(void)calendar:(CKCalendarView *)thisCalendar didChangeMonth:(NSDate *)date
{
    //TODO: Use predicates
    NSArray *taskSessions = [taskForCalendar.taskSession allObjects];
    NSMutableArray *datesToHightlight = [[NSMutableArray alloc] init];
    NSDate *calendarStartDate = [calendar firstDayOfMonthContainingDate:date];
    NSDate *calendarEndDate = [calendar firstDayOfNextMonthContainingDate:date];
    NSTimeInterval monthTimeInt = 0;
    int sessionCount = 0;
    for (int i = 0; i < [taskSessions count]; i++) {
        Session *thisSession = (Session *)[taskSessions objectAtIndex:i];
        NSDate *thisStartDate = thisSession.startDate;
        NSDate *thisEndDate = thisSession.endDate;
        if (([thisStartDate earlierDate:calendarStartDate] == calendarStartDate) &&
            ([thisEndDate laterDate:calendarEndDate] == calendarEndDate)
            ) {
            [datesToHightlight addObject:thisStartDate];
            monthTimeInt += [thisEndDate timeIntervalSinceDate:thisStartDate];
            sessionCount++;
        }
    }
    
    [thisCalendar highlightDatesInArray:datesToHightlight];
    
    monthStatHours.text = [FSBTextUtil stringFromNumSeconds:[NSNumber numberWithDouble:monthTimeInt] isTruncated:NO];
    if(sessionCount == 1)
        monthStatSessions.text = [NSString stringWithFormat:@"%d session", sessionCount];
    else
        monthStatSessions.text = [NSString stringWithFormat:@"%d sessions", sessionCount];
    
    NSTimeInterval secondsInMonth = [calendarEndDate timeIntervalSinceDate:calendarStartDate];
    int days = secondsInMonth / 86400;
    double timePerDay = monthTimeInt / days;
    monthStatAverage.text = [NSString stringWithFormat:@"%@ avg", [FSBTextUtil stringFromNumSeconds:[NSNumber numberWithDouble:timePerDay] isTruncated:NO]];
    [self adjustMonthLabels];
}

- (void)viewChangeInCalendar:(CKCalendarView *)thisCalendar
{
    dailyStatSubView.frame = CGRectMake(dailyStatSubView.frame.origin.x, calendar.frame.origin.y + calendar.frame.size.height + 5, dailyStatSubView.frame.size.width, dailyStatSubView.frame.size.height);
    monthStatSubView.frame = CGRectMake(monthStatSubView.frame.origin.x, dailyStatSubView.frame.origin.y + dailyStatSubView.frame.size.height + 5, monthStatSubView.frame.size.width, monthStatSubView.frame.size.height);
}

@end
