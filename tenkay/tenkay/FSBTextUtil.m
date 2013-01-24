//
//  FSBTextUtil.m
//  tenkay
//
//  Created by Jabari Bell on 1/16/13.
//  Copyright (c) 2013 Jabari Bell. All rights reserved.
//

#import "FSBTextUtil.h"

@implementation FSBTextUtil

+ (NSString *)stringFromNumSeconds:(NSNumber *)numSeconds isTruncated:(BOOL)isStringTruncated
{
    NSString *returnString;
    int roundedSeconds = floor([numSeconds doubleValue]);
    
    if(roundedSeconds == 0) {
        if (isStringTruncated == YES) {
            returnString = @"0h";
        } else {
            returnString = @"0 hours";
        }
        return returnString;
    }
    
    //seconds
    if(roundedSeconds < 60) {
        if(isStringTruncated == YES) {
            returnString = [[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", roundedSeconds], @"s", nil] componentsJoinedByString:@""];
        } else {
            if (roundedSeconds == 1) {
                returnString = [[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", roundedSeconds], @"second", nil] componentsJoinedByString:@" "];
            } else {
                returnString = [[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", roundedSeconds], @"seconds", nil] componentsJoinedByString:@" "];
            }
        }
        return returnString;
    }
    
    //minutes
    if(roundedSeconds < 3600) {
        roundedSeconds = floor(roundedSeconds / 60);
        if (isStringTruncated == YES) {
            returnString = [[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", roundedSeconds], @"m", nil] componentsJoinedByString:@""];
        } else {
            if (roundedSeconds == 1) {
                returnString = [[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", roundedSeconds], @"minute", nil] componentsJoinedByString:@" "];
            } else {
                returnString = [[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", roundedSeconds], @"minutes", nil] componentsJoinedByString:@" "];
            }
        }
        return returnString;
    }
   
    //everything else is just hours
    roundedSeconds = floor(roundedSeconds / 3600);
    if (isStringTruncated == YES) {
        returnString = [[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", roundedSeconds], @"h", nil] componentsJoinedByString:@""];
    } else {
        if (roundedSeconds == 1) {
            returnString = [[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", roundedSeconds], @"hour", nil] componentsJoinedByString:@" "];
        } else {
            returnString = [[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", roundedSeconds], @"hours", nil] componentsJoinedByString:@" "];
        }
    }
    return returnString;

}

@end
