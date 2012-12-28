//
//  Session.m
//  tenkay
//
//  Created by Jabari Bell on 12/28/12.
//  Copyright (c) 2012 Jabari Bell. All rights reserved.
//

#import "Session.h"


@implementation Session

@dynamic startDate;
@dynamic endDate;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    [self setStartDate:[NSDate date]];
}

@end
