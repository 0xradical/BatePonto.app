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
@property (weak) IBOutlet NSTableView *punchesList;

- (IBAction)retrievePunches:(id)sender;

@end
