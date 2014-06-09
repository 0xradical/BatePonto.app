//
//  PanelController.m
//  BatePonto
//
//  Created by thiago on 6/7/14.
//  Copyright (c) 2014 redealumni. All rights reserved.
//

#import "PanelController.h"
#import "PanelControllerDelegate.h"
#import "StatusBarItemView.h"
#import "PopupView.h"
#import "NSRails.h"

#define OPEN_DURATION .15
#define CLOSE_DURATION .1
#define SEARCH_INSET 17
#define POPUP_HEIGHT 180
#define PANEL_WIDTH 280
#define MENU_ANIMATION_DURATION .1


@interface PanelController ()

@end

@implementation PanelController

- (instancetype)initWithDelegate:(id<PanelControllerDelegate>)delegate
{
    self = [super initWithWindowNibName:@"Panel"];
    
    if (self) {
        [self setDelegate:delegate];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Make a fully skinned panel
    NSPanel *panel = (NSPanel *)[self window];
    
    [panel setAcceptsMouseMovedEvents:YES];
    [panel setLevel:NSPopUpMenuWindowLevel];
    [panel setOpaque:NO];
    [panel setBackgroundColor:[NSColor clearColor]];
}

#pragma mark - NSWindowDelegate

- (void)windowWillClose:(NSNotification *)notification
{
    [self closePanel];
}

- (void)windowDidResignKey:(NSNotification *)notification;
{
    if ([[self window] isVisible])
    {
        [self closePanel];
    }
}

- (void)windowDidResize:(NSNotification *)notification
{
    NSWindow *panel = [self window];
    NSRect statusRect = [self statusRectForWindow:panel];
    NSRect panelRect = [panel frame];
    
    CGFloat statusX = roundf(NSMidX(statusRect));
    CGFloat panelX = statusX - NSMinX(panelRect);
    
    [[self popupView] setArrowX:panelX];
    
//    NSRect commentRect = [[self comment] frame];
//    
//    commentRect.size.width = NSWidth([[self popupView] bounds]) - SEARCH_INSET * 2;
//    commentRect.origin.x = SEARCH_INSET;
//    commentRect.origin.y = NSHeight([[self popupView] bounds]) - ARROW_HEIGHT - SEARCH_INSET - NSHeight(commentRect);
//    
//    if (NSIsEmptyRect(commentRect))
//    {
//        [[self comment] setHidden:YES];
//    }
//    else
//    {
//        [[self comment] setFrame:commentRect];
//        [[self comment] setHidden:NO];
//    }
}

#pragma mark - Keyboard

- (void)cancelOperation:(id)sender
{
    [self closePanel];
}


- (NSRect)statusRectForWindow:(NSWindow *)window
{
    NSRect screenRect = [[[NSScreen screens] objectAtIndex:0] frame];
    NSRect statusRect = NSZeroRect;
    
    StatusBarItemView *itemView = nil;
    
    if ([self delegate]) {
        itemView = [[self delegate] statusBarItemViewForPanelController:self];
    }
    
    if (itemView)
    {
        statusRect = [itemView globalRect];
        statusRect.origin.y = NSMinY(statusRect) - NSHeight(statusRect);
    }
    else
    {
        statusRect.size = NSMakeSize(STATUS_ITEM_VIEW_WIDTH, [[NSStatusBar systemStatusBar] thickness]);
        statusRect.origin.x = roundf((NSWidth(screenRect) - NSWidth(statusRect)) / 2);
        statusRect.origin.y = NSHeight(screenRect) - NSHeight(statusRect) * 2;
    }
    return statusRect;
}


- (void)openPanel
{
    NSWindow *panel = [self window];
    
    NSRect screenRect = [[[NSScreen screens] objectAtIndex:0] frame];
    NSRect statusRect = [self statusRectForWindow:panel];
    
    NSRect panelRect = [panel frame];
    panelRect.size.width = PANEL_WIDTH;
    panelRect.size.height = POPUP_HEIGHT;
    panelRect.origin.x = roundf(NSMidX(statusRect) - NSWidth(panelRect) / 2);
    panelRect.origin.y = NSMaxY(statusRect) - NSHeight(panelRect);
    
    if (NSMaxX(panelRect) > (NSMaxX(screenRect) - ARROW_HEIGHT))
        panelRect.origin.x -= NSMaxX(panelRect) - (NSMaxX(screenRect) - ARROW_HEIGHT);
    
    [NSApp activateIgnoringOtherApps:NO];
    [panel setAlphaValue:0];
    [panel setFrame:statusRect display:YES];
    [panel makeKeyAndOrderFront:nil];
    
    NSTimeInterval openDuration = OPEN_DURATION;
    
    NSEvent *currentEvent = [NSApp currentEvent];
    if ([currentEvent type] == NSLeftMouseDown)
    {
        NSUInteger clearFlags = ([currentEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask);
        BOOL shiftPressed = (clearFlags == NSShiftKeyMask);
        BOOL shiftOptionPressed = (clearFlags == (NSShiftKeyMask | NSAlternateKeyMask));
        if (shiftPressed || shiftOptionPressed)
        {
            openDuration *= 10;
            
            if (shiftOptionPressed)
                NSLog(@"Icon is at %@\n\tMenu is on screen %@\n\tWill be animated to %@",
                      NSStringFromRect(statusRect), NSStringFromRect(screenRect), NSStringFromRect(panelRect));
        }
    }
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:openDuration];
    [[panel animator] setFrame:panelRect display:YES];
    [[panel animator] setAlphaValue:1];
    [NSAnimationContext endGrouping];
    
    [panel performSelector:@selector(makeFirstResponder:)
                withObject:[self comment]
                afterDelay:openDuration];
}

- (void)closePanel
{
    StatusBarItemView *itemView = nil;
    
    itemView = [[self delegate] statusBarItemViewForPanelController:self];
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:CLOSE_DURATION];
    [[[self window] animator] setAlphaValue:0];
    [NSAnimationContext endGrouping];
    
    dispatch_after(dispatch_walltime(NULL, NSEC_PER_SEC * CLOSE_DURATION * 2), dispatch_get_main_queue(), ^{
        
        [self.window orderOut:nil];
    });
    
    [itemView setHighlighted:NO];
    
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
    
    if (error) {
        
        NSLog(@"%@", [error description]);
    }
    else {
        NSLog(@"%@", json);
    }
}


@end
