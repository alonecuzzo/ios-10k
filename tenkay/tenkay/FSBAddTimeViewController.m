//
//  FSBAddTimeViewController.m
//  tenkay
//
//  Created by Jabari Bell on 1/19/13.
//  Copyright (c) 2013 Jabari Bell. All rights reserved.
//

#import "FSBAddTimeViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FSBAddTimeViewController ()
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
- (IBAction)onDateSelectorPressed:(id)sender;
@end

@implementation FSBAddTimeViewController {
    UIDatePicker *datePicker;
    CABasicAnimation *datePickerAnimation;
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
    
}

- (IBAction)onDateSelectorPressed:(id)sender
{
    datePickerAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    datePickerAnimation.duration = 0.30;
    datePickerAnimation.autoreverses = NO;
    datePickerAnimation.removedOnCompletion = NO;
    datePickerAnimation.fillMode = kCAFillModeForwards;
    datePickerAnimation.fromValue = @0.0;
    datePickerAnimation.toValue = @(-235);
    [datePicker.layer addAnimation:datePickerAnimation forKey:@"animateLayer"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"addTimeNavBackgroundTeal"] forBarMetrics:UIBarMetricsDefault];
    
    // Initialization code
	datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, 325, 250)];
	datePicker.datePickerMode = UIDatePickerModeDateAndTime;
	datePicker.hidden = NO;
	datePicker.date = [NSDate date];
	[datePicker addTarget:self action:@selector(updateDateLabel:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:datePicker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
