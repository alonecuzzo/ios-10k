//
//  FSBAddTaskCell.m
//  tenkay
//
//  Created by Jabari on 2/6/13.
//  Copyright (c) 2013 Jabari Bell. All rights reserved.
//

#import "FSBAddTaskCell.h"
#import "FSBTasksViewController.h"

@interface FSBAddTaskCell()
@end

@implementation FSBAddTaskCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [self.taskNameTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)textFieldFinished:(id)sender
{
    [self.delegate onSaveNewTask:self.taskNameTextField.text];
    self.taskNameTextField.text = @"";
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.delegate hideOpenCell];
}

@end
