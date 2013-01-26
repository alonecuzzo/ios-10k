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
    UITextField *taskTitle;
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
        taskTitle = [[UITextField alloc] initWithFrame:CGRectMake(10.0, 10.0, 300.0, 31.0)];
        taskTitle.backgroundColor = [UIColor clearColor];
        
        UIFont *font=[UIFont fontWithName:@"GurmukhiMN-Bold" size:21];
        taskTitle.font = font;
        taskTitle.textColor = [UIColor darkGrayColor];
        taskTitle.delegate = self;
        taskTitle.keyboardType = UIKeyboardTypeDefault;
        taskTitle.returnKeyType = UIReturnKeyDefault;
        taskTitle.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
        [taskTitle addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [self addSubview:taskTitle];
    }
    return self;
}

- (void)setTask:(Task *)task
{
    currentTask = task;
    taskTitle.text = currentTask.title;
}

- (Task *)getTask
{
    return currentTask;
}

- (void)setKeyboardFirstResponder
{
    [taskTitle becomeFirstResponder];
}

- (void)textFieldFinished:(id)sender
{
    [self.delegate dismissEditView:taskTitle.text];
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
