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
    
    UIButton *addTimeButton;
    UIButton *editTaskButton;
    
    UIImageView *addTimeButtonImageView;
    UIImageView *editTaskButtonImageView;
    
    CABasicAnimation *animation;
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
    editTaskButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(90, 55, 55, 52)];
    editTaskButton = [[UIButton alloc] init];
    editTaskButton.frame = CGRectMake(0, 0, 55, 52);
    [editTaskButton setImage:editTaskIcon forState:UIControlStateNormal];
    [editTaskButtonImageView addSubview:editTaskButton];
    [self.viewForBaselineLayout addSubview:editTaskButtonImageView];
    
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

-(void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"dan");
    addTimeButtonImageView.layer.opacity = 1.0;
    editTaskButtonImageView.layer.opacity = 1.0;
}

-(void)hideNav
{
    [addTimeButtonImageView removeFromSuperview];
    [editTaskButtonImageView removeFromSuperview];
    addTimeButtonImageView = nil;
    addTimeButton = nil;
    addTimeIcon = nil;
    editTaskButtonImageView = nil;
    editTaskButton = nil;
    editTaskIcon = nil;
    animation = nil;
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
