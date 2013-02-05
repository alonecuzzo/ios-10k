//
//  FSBEditView.m
//  tenkay
//
//  Created by Jabari Bell on 1/24/13.
//  Copyright (c) 2013 Jabari Bell. All rights reserved.
//

#import "FSBEditView.h"
#import "FSBEditBackgroundView.h"
#import "FSBAppDelegate.h"
#import "Task.h"

@implementation FSBEditView {
    UITextField *taskTitleTextField;
    Task *currentTask;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        FSBAppDelegate *delegate = ((FSBAppDelegate *) [UIApplication sharedApplication].delegate);
        FSBEditBackgroundView *backgroundView = [[FSBEditBackgroundView alloc] initWithFrame:CGRectMake(0.0, 0.0, delegate.window.bounds.size.width, delegate.window.bounds.size.height)];
        backgroundView.alpha = 0.85;
        [self addSubview:backgroundView];
        taskTitleTextField = [[UITextField alloc] initWithFrame:CGRectMake(10.0, 10.0, 300.0, 31.0)];
        taskTitleTextField.backgroundColor = [UIColor clearColor];
        
        UIFont *font=[UIFont fontWithName:@"GurmukhiMN-Bold" size:21];
        taskTitleTextField.font = font;
        taskTitleTextField.textColor = [UIColor darkGrayColor];
        taskTitleTextField.delegate = self;
        taskTitleTextField.keyboardType = UIKeyboardTypeDefault;
        taskTitleTextField.returnKeyType = UIReturnKeyDone;
        taskTitleTextField.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
        [taskTitleTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [self addSubview:taskTitleTextField];
    }
    return self;
}

- (void)setTask:(Task *)task
{
    currentTask = task;
    taskTitleTextField.text = currentTask.title;
}

- (Task *)getTask
{
    return currentTask;
}

- (void)setKeyboardFirstResponder
{
    [taskTitleTextField becomeFirstResponder];
}

- (void)textFieldFinished:(id)sender
{
    [self.delegate dismissEditView:taskTitleTextField.text];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
