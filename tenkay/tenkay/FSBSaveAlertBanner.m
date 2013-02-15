//
//  FSBSaveAlertBanner.m
//  tenkay
//
//  Created by Jabari on 2/15/13.
//  Copyright (c) 2013 Jabari Bell. All rights reserved.
//

#import "FSBSaveAlertBanner.h"

@implementation FSBSaveAlertBanner{
    UILabel *timeSavedTitle;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"saveAlertBackground"]]];
        timeSavedTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        UIFont *font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
        timeSavedTitle.font = font;
        timeSavedTitle.textColor = [UIColor colorWithRed:124.0/255.0 green:48.0/255.0 blue:46.0/255.0 alpha:1.0];
        timeSavedTitle.textAlignment = NSTextAlignmentCenter;
        timeSavedTitle.backgroundColor = [UIColor clearColor];
        timeSavedTitle.text = @"32 seconds recorded!";
        [self addSubview:timeSavedTitle];
    }
    return self;
}

- (void)setSaveText:(NSString *)saveText
{
    timeSavedTitle.text = saveText;
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
