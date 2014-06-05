//
//  RAAppDelegate.m
//  BatePonto
//
//  Created by thiago on 5/27/14.
//  Copyright (c) 2014 redealumni. All rights reserved.
//

#import "RAAppDelegate.h"
#import "NSRails.h"
#import "Models/Punch.h"

@interface RAAppDelegate ()

@property (nonatomic) NSArray *punches;

@end

@implementation RAAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSRConfig *defaultConfig = [NSRConfig defaultConfig];
    
    [defaultConfig setAppURL:@"http://localhost:3000"];
    
}

- (void)awakeFromNib
{
    NSLog(@"Awaken from NIB");
    
    [self setStatusItem:[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength]];
    
    [[self statusItem] setMenu:[self menu]];
    [[self statusItem] setTitle:@"Bate Ponto"];
    [[self statusItem] setHighlightMode:YES];
    [[self statusItem] setImage:[NSImage imageNamed:@"Clock"]];
}

- (IBAction)showWindow:(id)sender
{
    [NSApp activateIgnoringOtherApps:YES];
    [[self window] makeKeyAndOrderFront:nil];
}

- (IBAction)quit:(id)sender
{
    [NSApp terminate:nil];
}

- (IBAction)retrievePunches:(id)sender
{
    NSError *error;
    
    NSRRequest *request
    = [[NSRRequest GET] routeTo:@"/api/punches"];
    
    // AuthorizationSettings.plist in Supporting Files
    // Containing a KV pair "API Token" - "Value of API Token"
    NSString *authSettingsFile = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"AuthorizationSettings.plist"];
    
    NSDictionary *authSettings = [NSDictionary dictionaryWithContentsOfFile:authSettingsFile];
    
    request.queryParameters = @{
       @"user_token": @"02c8957ff68e21b24ac46004a6a0790b",
       @"api_token": authSettings[@"API Token"]
    };
    
    id json = [request sendSynchronous:&error];
    
    self.punches = [Punch objectsWithRemoteDictionaries:json];
    
    NSLog(@"%@", self.punches);
    
    [self.punchesList reloadData];
    
}

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

#pragma mark - Data Source Protocol

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.punches count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    Punch *punch = self.punches[row];
    
    return [punch valueForKey:[tableColumn identifier]];
}


@end
