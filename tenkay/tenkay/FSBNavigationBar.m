//
//  FSBNavigationBar.m
//  tenkay
//
//  Created by Jabari Bell on 1/16/13.
//  Copyright (c) 2013 Jabari Bell. All rights reserved.
//

#import "FSBNavigationBar.h"

@implementation FSBNavigationBar

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
    UIImage *navigationBarBackgroundImage = [UIImage imageNamed:@"navBackground"];
    [navigationBarBackgroundImage drawInRect: CGRectMake(0, 0, 320, 44)];
}

@end

//@implementation UINavigationBar (CustomImage)
//
////for iOS 5
//+ (Class)class {
//    return NSClassFromString(@"FSBNavigationBar");
//}
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    self.frame = CGRectMake(0, 20, 320, 44);
//}
//
//@end
