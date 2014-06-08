//
//  PanelController.h
//  BatePonto
//
//  Created by thiago on 6/7/14.
//  Copyright (c) 2014 redealumni. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PanelControllerDelegate.h"

@interface PanelController : NSWindowController

@property (weak) IBOutlet NSTextField *comment;
@property (nonatomic) id<PanelControllerDelegate> delegate;

- (instancetype)initWithDelegate:(id<PanelControllerDelegate>)delegate;
- (void)openPanel;
- (void)closePanel;

- (IBAction)punch:(id)sender;

@end
