//
//  FSBTextUtil.m
//  tenkay
//
//  Created by Jabari Bell on 1/16/13.
//  Copyright (c) 2013 Jabari Bell. All rights reserved.
//

#import "FSBTextUtil.h"

@implementation FSBTextUtil

+ (NSString *)formatHoursString:(NSNumber *)numSeconds isTruncated:(BOOL)isStringTruncated
{
    NSString *returnString;
    int roundedSeconds = floor([numSeconds doubleValue]);
    
    returnString = [NSString stringWithFormat:@"%d", roundedSeconds];
    returnString = [[NSArray arrayWithObjects:returnString, @"s", nil] componentsJoinedByString:@""];
    
    if(numSeconds < [NSNumber numberWithInt:60]){
        // return seconds
//        returnString = [NSString stringWithFormat:@"%@", numSeconds];
        if(isStringTruncated == YES) {
//           returnString = @"s";
        } else {
            
        }
    }
    
    return returnString;
}

@end
