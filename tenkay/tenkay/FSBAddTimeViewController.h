//
//  FSBAddTimeViewController.h
//  tenkay
//
//  Created by Jabari Bell on 1/19/13.
//  Copyright (c) 2013 Jabari Bell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSBTasksViewController.h"
#import "Task.h"

@interface FSBAddTimeViewController : UIViewController <UIPickerViewDelegate>

@property (nonatomic, strong) Task *currentTask;
@property (nonatomic, strong) id <FSBTasksViewDelegate> delegate;

@end
