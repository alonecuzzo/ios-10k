//
//  FSBAddTaskViewController.m
//  tenkay
//
//  Created by Jabari Bell on 12/28/12.
//  Copyright (c) 2012 Jabari Bell. All rights reserved.
//

#import "FSBAddTaskViewController.h"
#import "FSBAppDelegate.h"
#import "Task.h"
#import "FSBTasksViewController.h"

@interface FSBAddTaskViewController ()
- (IBAction)onCancel:(id)sender;
- (IBAction)onSave:(id)sender;
@end

@implementation FSBAddTaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    if(self.managedObjectContext) {
        if ([self.taskTitle.text length] > 0) {
            Task *task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
            task.title = self.taskTitle.text;
            NSError *error;
            if(![self.managedObjectContext save:&error]) {
                NSLog(@"Error Value: %@", [task valueForKey:@"title"]);
            }
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

@end
