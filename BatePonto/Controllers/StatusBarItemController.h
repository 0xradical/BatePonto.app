//
//  StatusBarItemController.h
//  BatePonto
//
//  Created by thiago on 6/6/14.
//  Copyright (c) 2014 redealumni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatusBarItemViewDelegate.h"

@class StatusBarItemView;
@class PanelController;

@interface StatusBarItemController : NSObject <NSApplicationDelegate, StatusBarItemViewDelegate>

@property (nonatomic) PanelController *panelController;
@property (nonatomic, strong) StatusBarItemView *itemView;

- (IBAction)punch:(id)sender;
- (IBAction)quit:(id)sender;

@end
