//
//  FSBAddTimeViewController.m
//  tenkay
//
//  Created by Jabari Bell on 1/19/13.
//  Copyright (c) 2013 Jabari Bell. All rights reserved.
//

#import "FSBAddTimeViewController.h"

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
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)updateStartDateLabel:(id)sender
{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	df.timeStyle = NSDateFormatterShortStyle;
	self.startDateLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
}

- (void)updateEndDateLabel:(id)sender
{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	df.timeStyle = NSDateFormatterShortStyle;
	self.endDateLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
