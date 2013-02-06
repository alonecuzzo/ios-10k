//
//  FSBAddTaskCell.h
//  tenkay
//
//  Created by Jabari on 2/6/13.
//  Copyright (c) 2013 Jabari Bell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSBTasksViewController.h"

@interface FSBAddTaskCell : UITableViewCell <UITextFieldDelegate>

@property(nonatomic, strong) id <FSBTasksViewDelegate> delegate;

@end
