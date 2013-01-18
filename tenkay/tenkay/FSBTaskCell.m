//
//  FSBTaskCell.m
//  tenkay
//
//  Created by Dawson Blackhouse on 12/30/12.
//  Copyright (c) 2012 Jabari Bell. All rights reserved.
//

#import "FSBTaskCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation FSBTaskCell {
    UIImage *addTimeIcon;
    UIImage *editTaskIcon;
    UIImage *calendarIcon;
    UIImage *trashIcon;
    
    UIButton *addTimeButton;
    UIButton *editTaskButton;
    UIButton *calendarButton;
    UIButton *trashButton;
    
    UIImageView *addTimeButtonImageView;
    UIImageView *editTaskButtonImageView;
    UIImageView *calendarButtonImageView;
    UIImageView *trashButtonImageView;
    
    CABasicAnimation *animation;
    CABasicAnimation *fadeOutAnimation;
    CABasicAnimation *translationAnimation;
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
    addTimeButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 55, 55, 52)];
    addTimeButton = [[UIButton alloc] init];
    addTimeButton.frame = CGRectMake(0, 0, 55, 52);
    [addTimeButton setImage:addTimeIcon forState:UIControlStateNormal];
    [addTimeButtonImageView addSubview:addTimeButton];
    [self.viewForBaselineLayout addSubview:addTimeButtonImageView];
    
    editTaskIcon = [UIImage imageNamed:@"editTimeIcon"];
    editTaskButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(95, 55, 55, 52)];
    editTaskButton = [[UIButton alloc] init];
    editTaskButton.frame = CGRectMake(0, 0, 55, 52);
    [editTaskButton setImage:editTaskIcon forState:UIControlStateNormal];
    [editTaskButtonImageView addSubview:editTaskButton];
    [self.viewForBaselineLayout addSubview:editTaskButtonImageView];
    
    calendarIcon = [UIImage imageNamed:@"calendarIcon"];
    calendarButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(175, 55, 55, 52)];
    calendarButton = [[UIButton alloc] init];
    calendarButton.frame = CGRectMake(0, 0, 55, 52);
    [calendarButton setImage:calendarIcon forState:UIControlStateNormal];
    [calendarButtonImageView addSubview:calendarButton];
    [self.viewForBaselineLayout addSubview:calendarButtonImageView];
    
    trashIcon = [UIImage imageNamed:@"trashIcon"];
    trashButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(261, 55, 55, 52)];
    trashButton = [[UIButton alloc] init];
    trashButton.frame = CGRectMake(0, 0, 55, 52);
    [trashButton setImage:trashIcon forState:UIControlStateNormal];
    [trashButtonImageView addSubview:trashButton];
    [self.viewForBaselineLayout addSubview:trashButtonImageView];
    
    animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = 0.4;
    //this is a hack, it should ideally listen for when the opening cell animation is done to fire off
    animation.beginTime = CACurrentMediaTime() + 0.15f;
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    animation.delegate = self;
    addTimeButtonImageView.layer.opacity = 0.0;
    [addTimeButtonImageView.layer addAnimation:animation forKey:@"animateOpacity"];

    animation.beginTime = CACurrentMediaTime() + 0.25f;
    editTaskButtonImageView.layer.opacity = 0.0;
    [editTaskButtonImageView.layer addAnimation:animation forKey:@"animateOpacity"];
    
    animation.beginTime = CACurrentMediaTime() + 0.35f;
    calendarButtonImageView.layer.opacity = 0.0;
    [calendarButtonImageView.layer addAnimation:animation forKey:@"animateOpacity"];
    
    animation.beginTime = CACurrentMediaTime() + 0.45f;
    trashButtonImageView.layer.opacity = 0.0;
    [trashButtonImageView.layer addAnimation:animation forKey:@"animateOpacity"];
    
    translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    translationAnimation.duration = 0.10;
    translationAnimation.beginTime = CACurrentMediaTime() + 0.15f;
    translationAnimation.autoreverses = NO;
    translationAnimation.removedOnCompletion = NO;
    translationAnimation.fillMode = kCAFillModeForwards;
    translationAnimation.fromValue = @15.0;
    translationAnimation.toValue = @0.0;
    
    [addTimeButtonImageView.layer addAnimation:translationAnimation forKey:@"animateLayer"];
    translationAnimation.beginTime = CACurrentMediaTime() + 0.25f;
    [editTaskButtonImageView.layer addAnimation:translationAnimation forKey:@"animateLayer"];
}

-(void)removeButtons
{
    [addTimeButtonImageView removeFromSuperview];
    [editTaskButtonImageView removeFromSuperview];
    [calendarButtonImageView removeFromSuperview];
    [trashButtonImageView removeFromSuperview];
    addTimeButtonImageView = nil;
    addTimeButton = nil;
    addTimeIcon = nil;
    editTaskButtonImageView = nil;
    editTaskButton = nil;
    editTaskIcon = nil;
    calendarButtonImageView = nil;
    calendarButton = nil;
    calendarIcon = nil;
    trashButtonImageView = nil;
    trashButton = nil;
    trashIcon = nil;
    animation = nil;
    fadeOutAnimation = nil;
}

-(void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"pow: %@", [anim valueForKey:@"id"]);
    if ([[anim valueForKey:@"id"] isEqual:@"fadeOutAnimation"]) {
        [self removeButtons];
    } else {
        addTimeButtonImageView.layer.opacity = 1.0;
        editTaskButtonImageView.layer.opacity = 1.0;
        calendarButtonImageView.layer.opacity = 1.0;
        trashButtonImageView.layer.opacity = 1.0;
    }
}

-(void)hideNav
{
    fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOutAnimation.duration = 0.10;
    [fadeOutAnimation setValue:@"fadeOutAnimation" forKey:@"id"];
    //this is a hack, it should ideally listen for when the opening cell animation is done to fire off
    fadeOutAnimation.fromValue = @1.0;
    fadeOutAnimation.toValue = @0.0;
    fadeOutAnimation.delegate = self;
    [addTimeButtonImageView.layer addAnimation:fadeOutAnimation forKey:@"animateOpacity"];
    [calendarButtonImageView.layer addAnimation:fadeOutAnimation forKey:@"animateOpacity"];
    [editTaskButtonImageView.layer addAnimation:fadeOutAnimation forKey:@"animateOpacity"];
    [trashButtonImageView.layer addAnimation:fadeOutAnimation forKey:@"animateOpacity"];
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
