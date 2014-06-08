//
//  PunchesController.h
//  BatePonto
//
//  Created by thiago on 6/5/14.
//  Copyright (c) 2014 redealumni. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LatestPunchesController : NSWindowController <NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *punchesList;

- (IBAction)retrieveLatestPunches:(id)sender;

@end
