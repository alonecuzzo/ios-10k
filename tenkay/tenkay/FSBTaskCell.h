//
//  FSBTaskCell.h
//  tenkay
//
//  Created by Dawson Blackhouse on 12/30/12.
//  Copyright (c) 2012 Jabari Bell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSBTaskCell : UITableViewCell

@property (nonatomic) BOOL isOpen;
@property (nonatomic, strong) IBOutlet UILabel *taskLabel;
@property (nonatomic, strong) IBOutlet UILabel *taskTime;
@property (strong, nonatomic) IBOutlet UIProgressView *taskProgress;

- (void)toggleNav;

@end
