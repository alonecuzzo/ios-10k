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
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
- (IBAction)onDateSelectorPressed:(id)sender;
@end

@implementation FSBAddTimeViewController {
    UIDatePicker *datePicker;
    BOOL datePickerOpen;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)updateDateLabel:(id)sender
{
    //Use NSDateFormatter to write out the date in a friendly format
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	df.timeStyle = NSDateFormatterShortStyle;
	self.dateLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
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

- (IBAction)onDateSelectorPressed:(id)sender
{
    if(datePickerOpen) {
        datePickerOpen = NO;
        [self hideDatePicker];
    } else {
        datePickerOpen = YES;
        [self showDatePicker];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"addTimeNavBackgroundTeal"] forBarMetrics:UIBarMetricsDefault];
    
    datePickerOpen = NO;
    // Initialization code
	datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, 325, 250)];
	datePicker.datePickerMode = UIDatePickerModeDateAndTime;
	datePicker.hidden = NO;
	datePicker.date = [NSDate date];
	[datePicker addTarget:self action:@selector(updateDateLabel:) forControlEvents:UIControlEventValueChanged];
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	df.timeStyle = NSDateFormatterShortStyle;
	self.dateLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
