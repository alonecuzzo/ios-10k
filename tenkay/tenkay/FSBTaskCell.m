//
//  FSBTaskCell.m
//  tenkay
//
//  Created by Dawson Blackhouse on 12/30/12.
//  Copyright (c) 2012 Jabari Bell. All rights reserved.
//

#import "FSBTaskCell.h"

@implementation FSBTaskCell {
    UIImage *addTimeIcon;
    UIButton *addTimeButton;
}

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

-(void)showNav
{
    addTimeIcon = [UIImage imageNamed:@"addTimeIcon"];
    addTimeButton = [[UIButton alloc] init];
    addTimeButton.frame = CGRectMake(10, 55, 55, 52);
    [addTimeButton setImage:addTimeIcon forState:UIControlStateNormal];
    [self.viewForBaselineLayout addSubview:addTimeButton];
}

-(void)hideNav
{
    [addTimeButton removeFromSuperview];
    addTimeButton = nil;
    addTimeIcon = nil;
}

-(void)toggleNav
{
    self.isOpen = !self.isOpen;
    if(self.isOpen) {
        [self showNav];
    } else {
        [self hideNav];
    }
}

@end
