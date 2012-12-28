//
//  Task.m
//  tenkay
//
//  Created by Jabari Bell on 12/28/12.
//  Copyright (c) 2012 Jabari Bell. All rights reserved.
//

#import "Task.h"


@implementation Task

@dynamic title;
@dynamic creationDate;
@dynamic index;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    [self setCreationDate:[NSDate date]];
}


@end
