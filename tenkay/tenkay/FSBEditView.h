//
//  FSBEditView.h
//  tenkay
//
//  Created by Jabari Bell on 1/24/13.
//  Copyright (c) 2013 Jabari Bell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSBTasksViewController.h"
#import "Task.h"

@interface FSBEditView : UIView <UITextFieldDelegate>

@property(nonatomic, strong) id <FSBTasksViewDelegate> delegate;

- (void)setTask:(Task *)task;
- (Task *)getTask;
- (void)setKeyboardFirstResponder;

@end
