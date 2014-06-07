//
//  RAAppDelegate.m
//  BatePonto
//
//  Created by thiago on 5/27/14.
//  Copyright (c) 2014 redealumni. All rights reserved.
//

#import "RAAppDelegate.h"
#import "NSRails.h"
//#import "PunchesController.h"
#import "Punch.h"

@implementation RAAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSLog(@"Application did finish launching!");
    
    NSRConfig *defaultConfig = [NSRConfig defaultConfig];
    
    [defaultConfig setAppURL:@"http://localhost:3000"];
}

- (void)awakeFromNib
{
    NSLog(@"RAApp Delegate awaken from nib");    
}

#pragma mark - IBActions

//- (IBAction)showPunchesList:(id)sender
//{
//    [NSApp activateIgnoringOtherApps:YES];
//    
//    if (![self punchesController]) {
//        [self setPunchesController:[[PunchesController alloc] init]];
//    }
//    
//    [[[self punchesController] window] makeKeyAndOrderFront:nil];
//}

@end
