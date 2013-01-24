//
//  FSBAddTimeViewController.m
//  tenkay
//
//  Created by Jabari Bell on 1/19/13.
//  Copyright (c) 2013 Jabari Bell. All rights reserved.
//

#import "FSBAddTimeViewController.h"
#import "FSBTasksViewController.h"
#import "FSBTextUtil.h"

@interface FSBAddTimeViewController ()
@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *endDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeAddedLabel;

- (IBAction)onStartDateSelectorPressed:(id)sender;
- (IBAction)onEndDateSelectorPressed:(id)sender;
@end

@implementation FSBAddTimeViewController {
    UIDatePicker *datePicker;
    BOOL isDatePickerOpen;
    BOOL isStartDateLabelSelected;
    BOOL isEndDateLabelSelected;
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
    NSDateComponents *components = [calendar components:NSSecondCalendarUnit fromDate:startDate toDate:endDate options:0];
    return components.second;
}

- (void)updateTimeAddedLabel
{
    NSInteger timeDifference = [self computeTimeDifference];
    self.timeAddedLabel.text = [FSBTextUtil stringFromNumSeconds:[NSNumber numberWithInt:timeDifference] isTruncated:NO];
}

- (void)updateStartDateLabel:(id)sender
{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	df.timeStyle = NSDateFormatterShortStyle;
	self.startDateLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
    [self updateTimeAddedLabel];
}

- (void)updateEndDateLabel:(id)sender
{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	df.timeStyle = NSDateFormatterShortStyle;
	self.endDateLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
    [self updateTimeAddedLabel];
}

- (void)removeDatePicker:(id)sender
{
    [datePicker removeFromSuperview];
}

- (void)addDatePicker
{
	[self.view addSubview:datePicker];
}

- (void)hideDatePicker
{
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height, 325, 250);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [UIView setAnimationDelegate:self];
    datePicker.frame = datePickerTargetFrame;
    [UIView setAnimationDidStopSelector:@selector(removeDatePicker:)];
    [UIView commitAnimations];
}

- (void)hideDatePickerFromBackgroundPress:(id)sender
{
    [self hideDatePicker];
}

- (void)showDatePicker
{
    [self addDatePicker];
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216, 325, 250);
    [UIView beginAnimations:@"MoveIn" context:nil];
    [UIView setAnimationDelegate:self];
    datePicker.frame = datePickerTargetFrame;
    [UIView commitAnimations];
}

- (void)showDatePickerPostSwap:(id)sender
{
    [self addDatePicker];
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216, 325, 250);
    [UIView beginAnimations:@"MoveIn" context:nil];
    [UIView setAnimationDelegate:self];
    datePicker.frame = datePickerTargetFrame;
    [UIView commitAnimations];
}

- (void)swapDatePicker
{
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
        [datePicker setMaximumDate:[df dateFromString:self.endDateLabel.text]];
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"addTimeNavBackgroundTeal"] forBarMetrics:UIBarMetricsDefault];

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
        [datePicker setMaximumDate:[NSDate date]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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
   
    UIButton *saveButton;
    saveButton = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 6, -5, 91, 57)];
    [saveButton setImage:[UIImage imageNamed:@"saveButton"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(onSavePress:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 41, 40)];
    [backButton setImage:[UIImage imageNamed:@"back-arrow"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onCancelPress:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 36)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    UIFont *font=[UIFont fontWithName:@"GurmukhiMN-Bold" size:21];
    titleLabel.font = font;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"Add Time";
    self.navigationItem.titleView = titleLabel;
    [self updateTimeAddedLabel];
    
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDatePickerFromBackgroundPress:)];
    tapGestureRecognize.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognize];
}

- (void)onCancelPress:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)onSavePress:(id)sender
{
    NSNumber *numSecondsToAdd = [NSNumber numberWithInt:[self computeTimeDifference]];
    if (numSecondsToAdd > 0) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateStyle = NSDateFormatterMediumStyle;
        df.timeStyle = NSDateFormatterShortStyle;
        NSDate *startDate = [df dateFromString:self.startDateLabel.text];
        NSDate *endDate = [df dateFromString:self.endDateLabel.text];
        [self.delegate addTimeToTask:startDate endDate:endDate numSeconds:numSecondsToAdd taskToAddTimeTo:self.currentTask];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
