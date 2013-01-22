//
//  FSBTaskViewController.m
//  tenkay
//
//  Created by Jabari Bell and Dawson Blackhouse on 12/28/12.
//  Copyright (c) 2012 Jabari Bell and Dawson Blackhouse. All rights reserved.
//

#import "FSBTasksViewController.h"
#import "FSBAddTaskViewController.h"
#import "FSBCalendarViewController.h"
#import "FSBTaskCell.h"
#import "Task.h"
#import "Session.h"
#import "FSBTextUtil.h"

@interface FSBTasksViewController ()
@end

@implementation FSBTasksViewController{
    NSFetchedResultsController *fetchedResultsController;
    Task *currentTask;
    Task *taskToDelete;
    Session *currentSession;
    //saving indexpath for stopCurrentSession upon gesture.
    NSIndexPath *currentIndexPath;
    NSTimer *sessionTimer;
    BOOL isTiming;
    NSInteger selectedRowNumber;
}

#define kCellHeight 64.0 
#define kCellOpenedHeight 103.0

@synthesize managedObjectContext;

- (void)performFetch
{
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        FATAL_CORE_DATA_ERROR(error);
        return;
    }
}

- (void)onAddButtonPress:(id)sender
{
    selectedRowNumber = -1;
   [self performSegueWithIdentifier:@"addTask" sender:self]; 
}

- (void)openCalendar:(Task *)task
{
    selectedRowNumber = -1;
   [self performSegueWithIdentifier:@"openCalendarView" sender:task];
}

- (void)addTime:(Task *)task
{
    selectedRowNumber = -1;
   [self performSegueWithIdentifier:@"addTime" sender:self];  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performFetch];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 41, 40)];
    [addButton setImage:[UIImage imageNamed:@"addTaskButton.png"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(onAddButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    selectedRowNumber = -1;
    
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
        FSBAddTaskViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.managedObjectContext = managedObjectContext;
    } else if ([[segue identifier] isEqualToString:@"openCalendarView"]) {
        FSBCalendarViewController *controller = (FSBCalendarViewController *)segue.destinationViewController;
        controller.managedObjectContext = managedObjectContext;
        Task *task = (Task *)sender;
        controller.taskToEdit = task;
        controller.delegate = self;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Repeating setup in viewDidLoad, needs to be refactored into a function later
    [self.tableView reloadData];
}

- (void)deleteTask:(Task *)task
{
    selectedRowNumber = -1;
    taskToDelete = task;
    NSString *destructiveTitle = @"Delete Task"; //Action Sheet Button Titles
    NSString *cancelTitle = @"Cancel";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@""
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:destructiveTitle
                                  otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if  ([buttonTitle isEqualToString:@"Delete Task"]) {
        [managedObjectContext deleteObject:taskToDelete];
        NSError *error;
        if(![self.managedObjectContext save:&error]) {
            NSLog(@"Error Value: %@", [taskToDelete valueForKey:@"title"]);
        }
    }
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
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    FSBTaskCell *taskCell = (FSBTaskCell *)cell;
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    taskCell.task = task;
    taskCell.delegate = self;
    taskCell.taskLabel.text = task.title;
    taskCell.isOpen = NO;
    [taskCell hideNav];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSTimeInterval timeInterval = [task.totalTime doubleValue];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    taskCell.taskTime.text = [dateFormatter stringFromDate:timerDate];
    
    NSString *formattedTotalTime = [FSBTextUtil formatHoursString:task.totalTime isTruncated:YES];
    taskCell.taskTime.text = formattedTotalTime;
    
    double timeInt = timeInterval;
    double tenKHours = 36000000;
    
    double prog = timeInt / tenKHours;
    
    [taskCell.taskProgress setProgress:prog];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FSBTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)updateTimerAtIndexPath:(NSIndexPath *)indexPath
{
    FSBTaskCell *taskCell = (FSBTaskCell *)[self.tableView cellForRowAtIndexPath:indexPath];

    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:currentSession.startDate];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
    NSString *timeString = [dateFormatter stringFromDate:timerDate];
    taskCell.taskTime.text = timeString;
}

- (void)startTaskTimerAtIndexPath:(NSIndexPath *)indexPath
{
    currentTask = [self.fetchedResultsController objectAtIndexPath:indexPath];
    currentIndexPath = indexPath;

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
    [currentTask addTaskSessionObject:currentSession];
    
    //dnfl: there's a way to override the addTaskSessionObject
    //      to add the current session to totalTime
    NSTimeInterval sessionInterval = [currentSession.endDate timeIntervalSinceDate:currentSession.startDate];
    NSNumber *sessionIntervalNum = [NSNumber numberWithDouble:sessionInterval];
    currentTask.totalTime = [NSNumber numberWithDouble:([currentTask.totalTime doubleValue] + [sessionIntervalNum doubleValue])];
    
    [sessionTimer invalidate];
    sessionTimer = nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
    NSTimeInterval timeInterval = [currentTask.totalTime doubleValue];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *timeString = [dateFormatter stringFromDate:timerDate];
    
    FSBTaskCell *taskCell = (FSBTaskCell *)[self.tableView cellForRowAtIndexPath:currentIndexPath];
    taskCell.taskTime.text = timeString;
    
    /*
    double timeInt = timeInterval;
    double tenKHours = 36000000;
    
    
    Progress bar moved to Phase 2
    double prog = timeInt / tenKHours;
    NSLog(@"progress: %f", prog);
    [taskCell.taskProgress setProgress:prog];
    */
    
    isTiming = false;
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        FATAL_CORE_DATA_ERROR(error);
        return;
    }
}

- (void)calendarViewControllerDidGoBack:(FSBCalendarViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:task];
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            FATAL_CORE_DATA_ERROR(error);
            return;
        }
    }
}

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
//    if (!isTiming) {
//        [self startTaskTimerAtIndexPath:indexPath];
//    }
//    //current session timed but not the same as the new session
//    else if (currentTask != [self.fetchedResultsController objectAtIndexPath:indexPath]) {
//        [self stopCurrentSession];
//        [self startTaskTimerAtIndexPath:indexPath];
//    }
//    //current session same as new session
//    else {
//        [self stopCurrentSession];
//    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    FSBTaskCell *selectedCell = (FSBTaskCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    // if it's already selected
    if(selectedRowNumber == indexPath.row) {
        selectedRowNumber = -1;
    } else if(selectedRowNumber > -1 && selectedRowNumber != indexPath.row){
        //need to close currently open one!
        FSBTaskCell *currentlySelectedCell = (FSBTaskCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRowNumber inSection:0]];
        [currentlySelectedCell hideNav];
        currentlySelectedCell.isOpen = NO;
        selectedRowNumber = indexPath.row;
    } else {
        selectedRowNumber = indexPath.row;
    }
    
    [selectedCell toggleNav];
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == selectedRowNumber) {
        return kCellOpenedHeight;
    }
    return kCellHeight;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self stopCurrentSession];
    
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController == nil) {
        id delegate = [[UIApplication sharedApplication] delegate];
        managedObjectContext = [delegate managedObjectContext];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        [fetchRequest setFetchBatchSize:5];
        
        fetchedResultsController = [[NSFetchedResultsController alloc]
                                    initWithFetchRequest:fetchRequest
                                    managedObjectContext:managedObjectContext
                                    sectionNameKeyPath:nil
                                    cacheName:@"Tasks"];
        
        fetchedResultsController.delegate = self;
    }
    
    return fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"*** controllerWillChangeContent");
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            NSLog(@"*** controllerDidChangeObject - NSFetchedResultsChangeInsert");
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            NSLog(@"*** controllerDidChangeObject - NSFetchedResultsChangeDelete");
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            NSLog(@"*** controllerDidChangeObject - NSFetchedResultsChangeUpdate");
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            NSLog(@"*** controllerDidChangeObject - NSFetchedResultsChangeMove");
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            NSLog(@"*** controllerDidChangeSection - NSFetchedResultsChangeInsert");
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            NSLog(@"*** controllerDidChangeSection - NSFetchedResultsChangeDelete");
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"*** controllerDidChangeContent");
    [self.tableView endUpdates];
}


@end
