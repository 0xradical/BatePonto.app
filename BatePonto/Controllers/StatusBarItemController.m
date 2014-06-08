//
//  StatusBarItemController.m
//  BatePonto
//
//  Created by thiago on 6/6/14.
//  Copyright (c) 2014 redealumni. All rights reserved.
//

#import "StatusBarItemController.h"
#import "StatusBarItemView.h"
#import "PanelController.h"
#import "NSRails.h"

@implementation StatusBarItemController

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // NSRails App URL configuration
    NSRConfig *defaultConfig = [NSRConfig defaultConfig];
    [defaultConfig setAppURL:@"http://localhost:3000"];
    
    // PanelController
    if (![self panelController]) {
        [self setPanelController:[[PanelController alloc] init]];
    }
}

- (void)awakeFromNib
{
    [self setItemView:[[StatusBarItemView alloc] initWithStatusItem]];
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
    
    if (error) {
        
        NSLog(@"%@", [error description]);
    }
    else {
        NSLog(@"%@", json);   
    }
}

- (IBAction)quit:(id)sender
{
    [NSApp terminate:nil];
}

#pragma mark - StatusBarItemViewDelegate protocol

- (void)togglePanel:(id)sender
{
    [sender setHighlighted:![sender isHighlighted]];
    
    if ([sender isHighlighted]) {
        [[self panelController] openPanel];
    }
    else {
        [[self panelController] closePanel];
    }
    
}

@end
