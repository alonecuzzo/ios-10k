//
//  FSBTextUtil.h
//  tenkay
//
//  Created by Jabari Bell on 1/16/13.
//  Copyright (c) 2013 Jabari Bell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSBTextUtil : NSObject

+ (NSString *)stringFromNumSeconds:(NSNumber *)numSeconds isTruncated:(BOOL)isStringTruncated;

@end
