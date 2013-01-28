//
//  FSBTaskDetailViewController.m
//  tenkay
//
//  Created by Jabari Bell and Dawson Blackhouse on 12/28/12.
//  Copyright (c) 2012 Jabari Bell and Dawson Blackhouse. All rights reserved.
//

#import "FSBAddTaskViewController.h"
#import "FSBAppDelegate.h"
#import "Session.h"
#import "Task.h"
#import "FSBTasksViewController.h"

@interface FSBAddTaskViewController ()
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@end

@implementation FSBAddTaskViewController

@synthesize managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)onCancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)onSave:(id)sender
{
    NSLog(@"***** - onSave:");
    Task *task = nil;
    if(self.managedObjectContext) {
        if ([self.taskTitle.text length] > 0) {
            task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
            task.title = self.taskTitle.text;
            
            NSError *error;
            if(![self.managedObjectContext save:&error]) {
                NSLog(@"Error Value: %@", [task valueForKey:@"title"]);
            }
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBackground"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *saveButton;
    saveButton = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 6, -5, 91, 57)];
    [saveButton setImage:[UIImage imageNamed:@"saveButton"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(onSave:) forControlEvents:UIControlEventTouchUpInside];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"Add Task"];
    navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    navItem.hidesBackButton = YES;
    UIButton *cancelButton;
    cancelButton = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 6, -5, 91, 57)];
    [cancelButton setImage:[UIImage imageNamed:@"cancelButton"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(onCancel:) forControlEvents:UIControlEventTouchUpInside];
    navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    [self.navigationBar pushNavigationItem:navItem animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
