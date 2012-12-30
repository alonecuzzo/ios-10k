//
//  FSBTaskCell.h
//  tenkay
//
//  Created by Dawson Blackhouse on 12/30/12.
//  Copyright (c) 2012 Jabari Bell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSBTaskCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *taskLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskTime;

@end
