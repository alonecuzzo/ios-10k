//
//  FSBEditBackgroundView.m
//  tenkay
//
//  Created by Jabari Bell on 1/24/13.
//  Copyright (c) 2013 Jabari Bell. All rights reserved.
//

#import "FSBEditBackgroundView.h"
#import "FSBAppDelegate.h"

@implementation FSBEditBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    FSBAppDelegate *delegate = ((FSBAppDelegate *) [UIApplication sharedApplication].delegate);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(context, CGRectMake(0.0, 0.0, delegate.window.bounds.size.width, delegate.window.bounds.size.height));
}


@end
