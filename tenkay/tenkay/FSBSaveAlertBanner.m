//
//  FSBSaveAlertBanner.m
//  tenkay
//
//  Created by Jabari on 2/15/13.
//  Copyright (c) 2013 Jabari Bell. All rights reserved.
//

#import "FSBSaveAlertBanner.h"

@implementation FSBSaveAlertBanner

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"saveAlertBackground"]]];
        
    }
    return self;
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
