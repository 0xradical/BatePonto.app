//
//  StatusBarItemController.h
//  BatePonto
//
//  Created by thiago on 6/6/14.
//  Copyright (c) 2014 redealumni. All rights reserved.
//

#import <Foundation/Foundation.h>
@class StatusBarItemView;

@interface StatusBarItemController : NSObject <NSApplicationDelegate>

// statusItem it has to be strongly
// held by us because it is not strongly
// held by [NSStatusBar systemStatusBar]
@property (strong) NSStatusItem *statusItem;   // NSStatusItem
@property (strong) StatusBarItemView *itemView;
@property (weak) IBOutlet NSMenu *menu;      // NSMenu
@property (weak) IBOutlet NSView *punchForm; // NSMenuItem's view
@property (weak) IBOutlet NSTextField *comment;

- (IBAction)punch:(id)sender;
- (IBAction)quit:(id)sender;

@end
