//
//  PanelController.h
//  BatePonto
//
//  Created by thiago on 6/7/14.
//  Copyright (c) 2014 redealumni. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PanelControllerDelegate.h"

@class PopupView;

@interface PanelController : NSWindowController

@property (weak) IBOutlet NSTextField *comment;
@property (weak) IBOutlet NSTextField *serverMessage;
@property (weak) IBOutlet NSButton *punchButton;

@property (nonatomic) id<PanelControllerDelegate> delegate;
@property (weak) IBOutlet PopupView *popupView;

- (instancetype)initWithDelegate:(id<PanelControllerDelegate>)delegate;
- (void)openPanel;
- (void)closePanel;

- (IBAction)punch:(id)sender;
- (IBAction)comment:(id)sender;

@end
