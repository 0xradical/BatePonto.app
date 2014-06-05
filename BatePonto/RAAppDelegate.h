//
//  RAAppDelegate.h
//  BatePonto
//
//  Created by thiago on 5/27/14.
//  Copyright (c) 2014 redealumni. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RAAppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource>

@property (assign) IBOutlet NSWindow *window;
// statusItem it has to be strongly held by us
// because it is not strongly held by [NSStatusBar systemStatusBar]
@property NSStatusItem *statusItem;
@property (weak) IBOutlet NSMenu *menu;
@property (weak) IBOutlet NSTableView *punchesList;
@property (weak) IBOutlet NSTextField *comment;

- (IBAction)retrievePunches:(id)sender;
- (IBAction)punch:(id)sender;
- (IBAction)showWindow:(id)sender;
- (IBAction)quit:(id)sender;

@end
