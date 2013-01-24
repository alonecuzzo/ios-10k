//
//  FSBEditView.h
//  tenkay
//
//  Created by Jabari Bell on 1/24/13.
//  Copyright (c) 2013 Jabari Bell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSBTasksViewController.h"

@interface FSBEditView : UIView <UITextFieldDelegate>

@property(nonatomic, strong) id <FSBTasksViewDelegate> delegate;

@end
