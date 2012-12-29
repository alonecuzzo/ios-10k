//
//  FSBTaksViewController.m
//  tenkay
//
//  Created by Jabari Bell on 12/28/12.
//  Copyright (c) 2012 Jabari Bell. All rights reserved.
//

#import "FSBTasksViewController.h"
#import "Task.h"
#import "Session.h"

@interface FSBTasksViewController ()

@end

@implementation FSBTasksViewController{
    NSManagedObjectContext *managedObjectContext;
    NSArray *fetchedObjects;
}

Task *currentTask;
Session *currentSession;
NSTimer *sessionTimer;
BOOL isTiming;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSError *error;
    id delegate = [[UIApplication sharedApplication] delegate];
    managedObjectContext = [delegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];

    for(NSManagedObject *task in fetchedObjects) {
        NSLog(@"Task Title: %@", [task valueForKey:@"title"]);
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"addTask"]) {
        UIViewController *addTaskView = segue.destinationViewController;
        if ([addTaskView respondsToSelector:@selector(setManagedObjectContext:)]) {
            [addTaskView setValue:managedObjectContext forKey:@"managedObjectContext"];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Repeating setup in viewDidLoad, needs to be refactored into a function later
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [fetchedObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Task *task = [fetchedObjects objectAtIndex:indexPath.row];
    cell.textLabel.text = task.title;
    
    return cell;
}

- (void)updateTimerAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:currentSession.startDate];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString = [dateFormatter stringFromDate:timerDate];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell viewWithTag:1023];
    label.text = timeString;
}

- (void)startTaskTimerAtIndexPath:(NSIndexPath *)indexPath
{
    currentTask = [fetchedObjects objectAtIndex:indexPath.row];

    currentSession = [NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:managedObjectContext];
    currentSession.startDate = [NSDate date];
    
    //need to send indexpath with selector
    //will use nsinvocation
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(updateTimerAtIndexPath:)]];
    [invocation setTarget:self];
    [invocation setSelector:@selector(updateTimerAtIndexPath:)];
    [invocation setArgument:&indexPath atIndex:2];

    sessionTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  invocation: invocation
                                                  repeats:YES];
    isTiming = true;
}

- (void)stopCurrentSession
{
    currentSession.endDate = [NSDate date];
    [sessionTimer invalidate];
    sessionTimer = nil;
    //currentTask.addTaskSessionObject( currentSession );
    isTiming = false;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //no sessions timed
    if (!isTiming) {
        [self startTaskTimerAtIndexPath:indexPath];
    }
    //current session timed but not the same as the new session
    else if (currentTask != [fetchedObjects objectAtIndex:indexPath.row]) {
        [self stopCurrentSession];
        [self startTaskTimerAtIndexPath:indexPath];
    }
    //current session same as new session
    else {
        [self stopCurrentSession];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self stopCurrentSession];
    
}

@end
