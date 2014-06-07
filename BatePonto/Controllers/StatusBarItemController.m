//
//  StatusBarItemController.m
//  BatePonto
//
//  Created by thiago on 6/6/14.
//  Copyright (c) 2014 redealumni. All rights reserved.
//

#import "StatusBarItemController.h"
#import "StatusBarItemView.h"
#import "NSRails.h"

@implementation StatusBarItemController

- (void)awakeFromNib
{
    NSLog(@"StatusBarItemController awaken from nib");
    
    NSStatusItem *statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    [self setStatusItem:statusItem];

    // View setup
    CGFloat itemWidth = 22.0;//[statusItem length] is returning -1 ? why ???;
    CGFloat itemHeight = [[NSStatusBar systemStatusBar] thickness];
    NSRect itemRect = NSMakeRect(0.0, 0.0, itemWidth, itemHeight);
    StatusBarItemView *itemView = [[StatusBarItemView alloc] initWithFrame:itemRect];
    
    [itemView setController:self];
    [itemView setStatusItem:statusItem];
    [itemView setMenu:[self menu]];
    [itemView setImage:[NSImage imageNamed:@"Clock"]];
    
    // when setView: is used, the view has
    // the resposibility of drawing the
    // NSStatusItem in the Status Bar
    [[self statusItem] setView:itemView];

    // Add punchForm to menu programatically
    NSMenuItem *punchItem;

    punchItem = [[NSMenuItem alloc] initWithTitle:@"Punch!"
                                           action:NULL
                                    keyEquivalent:@""];

    [punchItem setView:[self punchForm]];
    [punchItem setTarget:self];

    [[self menu] insertItem:punchItem atIndex:0];
}

#pragma mark - IBActions

- (IBAction)punch:(id)sender
{
    NSError *error;
    
    NSRRequest *request
    = [[NSRRequest POST] routeTo:@"/api/punches"];
    
    // AuthorizationSettings.plist in Supporting Files
    // Containing a KV pair "API Token" - "Value of API Token"
    NSString *authSettingsFile = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"AuthorizationSettings.plist"];
    
    NSDictionary *authSettings = [NSDictionary dictionaryWithContentsOfFile:authSettingsFile];
    
    request.queryParameters = @{
                                @"user_token": @"02c8957ff68e21b24ac46004a6a0790b",
                                @"api_token": authSettings[@"API Token"]
                                };
    
    request.body = @{
                     @"punch":
                         @{
                             @"comment": [[self comment] stringValue]
                             }
                     };
    
    id json = [request sendSynchronous:&error];
    
    NSLog(@"%@", json);
}

- (IBAction)quit:(id)sender
{
    [NSApp terminate:nil];
}

@end
