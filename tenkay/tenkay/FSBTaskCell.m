//
//  FSBTaskCell.m
//  tenkay
//
//  Created by Dawson Blackhouse on 12/30/12.
//  Copyright (c) 2012 Jabari Bell and Dawson Blackhouse. All rights reserved.
//

#import "FSBTaskCell.h"
#import <QuartzCore/QuartzCore.h>

@interface FSBTaskCell()
@property (strong, nonatomic) IBOutlet UIImageView *selectedBackground;
@property (strong, nonatomic) IBOutlet UIImageView *taskSeparator;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
- (IBAction)onPlayPress:(id)sender;
@end

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
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]; if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)onTaskDelete:(id)sender{
    [self.delegate deleteTask:self.task];
}

-(void)onEditTask:(id)sender{
    [self.delegate openEditScreen:self.task];
}

-(void)onAddTime:(id)sender{
    [self.delegate openAddTimeScreen:self.task];
}

-(void)onCalendarPress:(id)sender{
    [self.delegate openCalendar:self.task];
}

- (IBAction)onPlayPress:(id)sender
{
    NSIndexPath *indexPath = [(UITableView *)self.superview indexPathForCell:self];
    [self.delegate onPlayButtonPress:self.task indexPath:indexPath];
}

- (void)showCurrentCellIsRecordingView
{
   //means current cell is recording
    [self.selectedBackground setHidden:NO];
    //lets animate it in
    animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = 0.3;
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    animation.delegate = self;
    [self.selectedBackground.layer addAnimation:animation forKey:@"animateOpacity"];
    [self.playButton setImage:[UIImage imageNamed:@"stopxButtonWhite"] forState:UIControlStateNormal];
}

- (void)showIsRecordingView
{
    //changes everything to white
    [self.taskLabel setTextColor:[UIColor whiteColor]];
    [self.taskTime setTextColor:[UIColor whiteColor]];
    [self.playButton setImage:[UIImage imageNamed:@"playButtonWhite"] forState:UIControlStateNormal];
    [self.taskSeparator setImage:[UIImage imageNamed:@"taskSeparatorWhite"]];
}

-(void)showNav
{
    addTimeIcon = [UIImage imageNamed:@"addTimeIcon"];
    addTimeButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 68, 27.5, 26)];
    addTimeButtonImageView.image = addTimeIcon;
    [self.viewForBaselineLayout addSubview:addTimeButtonImageView];
    addTimeButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 68, 27.5, 26)];
    [addTimeButton setImage:addTimeIcon forState:UIControlStateNormal];
    [addTimeButton addTarget:self action:@selector(onAddTime:) forControlEvents:UIControlEventTouchUpInside];
    
    editTaskIcon = [UIImage imageNamed:@"editTimeIcon"];
    editTaskButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(105, 68, 27.5, 26)];
    editTaskButtonImageView.image = editTaskIcon;
    [self.viewForBaselineLayout addSubview:editTaskButtonImageView];
    editTaskButton = [[UIButton alloc] initWithFrame:CGRectMake(105, 68, 27.5, 26)];
    [editTaskButton setImage:editTaskIcon forState:UIControlStateNormal];
    [editTaskButton addTarget:self action:@selector(onEditTask:) forControlEvents:UIControlEventTouchUpInside];
    
    calendarIcon = [UIImage imageNamed:@"calendarIcon"];
    calendarButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(190, 68, 27.5, 26)];
    calendarButtonImageView.image = calendarIcon;
    [self.viewForBaselineLayout addSubview:calendarButtonImageView];
    calendarButton = [[UIButton alloc] initWithFrame:CGRectMake(190, 68, 27.5, 26)];
    [calendarButton setImage:calendarIcon forState:UIControlStateNormal];
    [calendarButton addTarget:self action:@selector(onCalendarPress:) forControlEvents:UIControlEventTouchUpInside];
    
    trashIcon = [UIImage imageNamed:@"trashIcon"];
    trashButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(275, 68, 27.5, 26)];
    trashButtonImageView.image = trashIcon;
    [self.viewForBaselineLayout addSubview:trashButtonImageView];
    trashButton = [[UIButton alloc] initWithFrame:CGRectMake(275, 68, 27.5, 26)];
    [trashButton setImage:trashIcon forState:UIControlStateNormal];
    [trashButton addTarget:self action:@selector(onTaskDelete:) forControlEvents:UIControlEventTouchUpInside];
    
    animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = 0.4;
    //this is a hack, it should ideally listen for when the opening cell animation is done to fire off
    animation.beginTime = CACurrentMediaTime() + 0.15f;
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    animation.delegate = self;
    addTimeButtonImageView.layer.opacity = 0.0;
    [addTimeButtonImageView.layer addAnimation:animation forKey:@"animateOpacity"];

    animation.beginTime = CACurrentMediaTime() + 0.20f;
    editTaskButtonImageView.layer.opacity = 0.0;
    [editTaskButtonImageView.layer addAnimation:animation forKey:@"animateOpacity"];
    
    animation.beginTime = CACurrentMediaTime() + 0.25f;
    calendarButtonImageView.layer.opacity = 0.0;
    [calendarButtonImageView.layer addAnimation:animation forKey:@"animateOpacity"];
    
    animation.beginTime = CACurrentMediaTime() + 0.30f;
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
    translationAnimation.beginTime = CACurrentMediaTime() + 0.20f;
    [editTaskButtonImageView.layer addAnimation:translationAnimation forKey:@"animateLayer"];
    translationAnimation.beginTime = CACurrentMediaTime() + 0.30f;
    translationAnimation.fromValue = @10.0;
    [calendarButtonImageView.layer addAnimation:translationAnimation forKey:@"animateLayer"];
    translationAnimation.beginTime = CACurrentMediaTime() + 0.35f;
    [trashButtonImageView.layer addAnimation:translationAnimation forKey:@"animateLayer"];
    
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
    if ([[anim valueForKey:@"id"] isEqual:@"fadeOutAnimation"]) {
        [self removeButtons];
    } else {
        // once our fake buttons fade in, we set them to invisible and then swap our real buttons in!!!
        [self.viewForBaselineLayout addSubview:addTimeButton];
        [self.viewForBaselineLayout addSubview:editTaskButton];
        [self.viewForBaselineLayout addSubview:calendarButton];
        [self.viewForBaselineLayout addSubview:trashButton];
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
    
    //remove buttons
    [addTimeButton removeFromSuperview];
    [editTaskButton removeFromSuperview];
    [calendarButton removeFromSuperview];
    [trashButton removeFromSuperview];
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
