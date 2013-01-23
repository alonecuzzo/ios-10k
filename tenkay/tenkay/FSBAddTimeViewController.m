//
//  FSBAddTimeViewController.m
//  tenkay
//
//  Created by Jabari Bell on 1/19/13.
//  Copyright (c) 2013 Jabari Bell. All rights reserved.
//

#import "FSBAddTimeViewController.h"
#import "FSBTasksViewController.h"

@interface FSBAddTimeViewController ()
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *endDateLabel;

- (IBAction)onStartDateSelectorPressed:(id)sender;
- (IBAction)onEndDateSelectorPressed:(id)sender;
@end

@implementation FSBAddTimeViewController {
    UIDatePicker *datePicker;
    BOOL isDatePickerOpen;
    BOOL isStartDateLabelSelected;
    BOOL isEndDateLabelSelected;
    
    UIButton *cancelButton;
    UIButton *saveButton;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSInteger)computeTimeDifference
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	df.timeStyle = NSDateFormatterShortStyle;
    NSDate *startDate = [df dateFromString:self.startDateLabel.text];
    NSDate *endDate = [df dateFromString:self.endDateLabel.text];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:startDate toDate:endDate options:0];
    return components.hour;
}

- (void)updateStartDateLabel:(id)sender
{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	df.timeStyle = NSDateFormatterShortStyle;
	self.startDateLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
    //if the start date becomes greater than the end date, then the end date date should be the start date + hour
    if(datePicker.date > [df dateFromString:self.endDateLabel.text]) {
        if ([NSDate dateWithTimeInterval:3600 sinceDate:datePicker.date] < [NSDate date]) {
            self.endDateLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:[NSDate dateWithTimeInterval:3600 sinceDate:datePicker.date]]];
        } else {
            self.endDateLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:[NSDate date]]];
        }
    }
}

- (void)updateEndDateLabel:(id)sender
{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	df.timeStyle = NSDateFormatterShortStyle;
	self.endDateLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
    //if the end date is less than the start date, then the start date should be the end date - hour
    if(datePicker.date < [df dateFromString:self.startDateLabel.text]) {
        self.startDateLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:[NSDate dateWithTimeInterval:-3600 sinceDate:datePicker.date]]];
    }
}

- (void)removeDatePicker:(id)sender
{
    [datePicker removeFromSuperview];
}

- (void)addDatePicker
{
	[self.view addSubview:datePicker];
}

- (void)hideDatePicker {
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height, 325, 250);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [UIView setAnimationDelegate:self];
    datePicker.frame = datePickerTargetFrame;
    [UIView setAnimationDidStopSelector:@selector(removeDatePicker:)];
    [UIView commitAnimations];
}

- (void)showDatePicker {
    [self addDatePicker];
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216, 325, 250);
    [UIView beginAnimations:@"MoveIn" context:nil];
    [UIView setAnimationDelegate:self];
    datePicker.frame = datePickerTargetFrame;
    [UIView commitAnimations];
}

- (void)showDatePickerPostSwap:(id)sender {
    [self addDatePicker];
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216, 325, 250);
    [UIView beginAnimations:@"MoveIn" context:nil];
    [UIView setAnimationDelegate:self];
    datePicker.frame = datePickerTargetFrame;
    [UIView commitAnimations];
}

- (void)swapDatePicker {
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height, 325, 250);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [UIView setAnimationDelegate:self];
    datePicker.frame = datePickerTargetFrame;
    [UIView setAnimationDidStopSelector:@selector(showDatePickerPostSwap:)];
    [UIView commitAnimations];
}

- (IBAction)onStartDateSelectorPressed:(id)sender
{
    if(isDatePickerOpen && isStartDateLabelSelected) {
        isDatePickerOpen = NO;
        isStartDateLabelSelected = NO;
        [self hideDatePicker];
    } else {
        isDatePickerOpen = YES;
        isStartDateLabelSelected = YES;
        if(isEndDateLabelSelected){
            [datePicker removeTarget:self action:@selector(updateEndDateLabel:) forControlEvents:UIControlEventValueChanged];
            [self swapDatePicker];
        } else {
            [self showDatePicker];
        }
        isEndDateLabelSelected = NO;
        [datePicker addTarget:self action:@selector(updateStartDateLabel:) forControlEvents:UIControlEventValueChanged];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateStyle = NSDateFormatterMediumStyle;
        df.timeStyle = NSDateFormatterShortStyle;
        datePicker.date = [df dateFromString:self.startDateLabel.text];
        [datePicker setMinimumDate:[df dateFromString:@"Jan 1, 1970"]];
    }
}

- (IBAction)onEndDateSelectorPressed:(id)sender
{
    if(isDatePickerOpen && isEndDateLabelSelected) {
        isDatePickerOpen = NO;
        isEndDateLabelSelected = NO;
        [self hideDatePicker];
    } else {
        isDatePickerOpen = YES;
        isEndDateLabelSelected = YES;
        if(isStartDateLabelSelected){
            [datePicker removeTarget:self action:@selector(updateStartDateLabel:) forControlEvents:UIControlEventValueChanged];
            [self swapDatePicker];
        } else {
            [self showDatePicker];
        }
        isStartDateLabelSelected = NO;
        [datePicker addTarget:self action:@selector(updateEndDateLabel:) forControlEvents:UIControlEventValueChanged];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateStyle = NSDateFormatterMediumStyle;
        df.timeStyle = NSDateFormatterShortStyle;
        datePicker.date = [df dateFromString:self.endDateLabel.text];
        [datePicker setMinimumDate:[df dateFromString:self.startDateLabel.text]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"addTimeNavBackgroundTeal"] forBarMetrics:UIBarMetricsDefault];
    
    isStartDateLabelSelected = NO;
    isEndDateLabelSelected = NO;
    isDatePickerOpen = NO;
    
	datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, 325, 250)];
	datePicker.datePickerMode = UIDatePickerModeDateAndTime;
	datePicker.hidden = NO;
	datePicker.date = [NSDate date];
    [datePicker setMaximumDate:[NSDate date]];
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	df.timeStyle = NSDateFormatterShortStyle;
    NSDate *startDate = [[NSDate alloc] initWithTimeInterval:-3600 sinceDate:[NSDate date]];
	self.startDateLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:startDate]];
    self.endDateLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
    
    cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(-4, -5, 91, 57)];
    [cancelButton setImage:[UIImage imageNamed:@"addTimeCancelButton"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(onCancelPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    saveButton = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width -86, -5, 91, 57)];
    [saveButton setImage:[UIImage imageNamed:@"addTimeSaveButton"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(onSavePress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
}

- (void)onCancelPress:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)onSavePress:(id)sender
{
    NSLog(@"hours added: %i", [self computeTimeDifference]);
    NSNumber *numSecondsToAdd = @(3600 * [self computeTimeDifference]);
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    df.timeStyle = NSDateFormatterShortStyle;
    NSDate *startDate = [df dateFromString:self.startDateLabel.text];
    NSDate *endDate = [df dateFromString:self.endDateLabel.text];
    [self.taskDelegate addTimeToTask:startDate endDate:endDate numSeconds:numSecondsToAdd taskToAddTimeTo:self.currentTask];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
