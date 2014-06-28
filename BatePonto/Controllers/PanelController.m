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

@property (nonatomic) NSMutableData *punchResponseData;

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
    NSURL *base = [NSURL URLWithString:@"http://localhost:3000"];
    NSString *appendedRoute = @"/api/punches";

    // AuthorizationSettings.plist in Supporting Files
    // Containing a KV pair "API Token" - "Value of API Token"
    NSString *authSettingsFile = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"AuthorizationSettings.plist"];

    NSDictionary *authSettings = [NSDictionary dictionaryWithContentsOfFile:authSettingsFile];
    
    NSDictionary *queryParameters = @{
      @"user_token": @"02c8957ff68e21b24ac46004a6a0790b",
      @"api_token": authSettings[@"API Token"]
    };

    
	if (queryParameters.count > 0)
	{
		NSMutableArray *params = [NSMutableArray arrayWithCapacity:queryParameters.count];
		[queryParameters enumerateKeysAndObjectsUsingBlock:
		 ^(id key, id obj, BOOL *stop)
		 {
			 //TODO
			 //Escape to be RFC 1808 compliant
			 [params addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];
		 }];
		appendedRoute = [appendedRoute stringByAppendingFormat:@"?%@",[params componentsJoinedByString:@"&"]];
	}
    
    NSURL *url = [NSURL URLWithString:appendedRoute relativeToURL:base];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
														   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
													   timeoutInterval:60.0f];
	
	[request setHTTPMethod:@"POST"];
	[request setHTTPShouldHandleCookies:NO];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSDictionary *body = @{
                           @"punch":
                               @{
                                   @"comment": [[self comment] stringValue]
                                   }
                           };
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted error:nil];
    
    if (data)
    {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    [request setHTTPBody:data];
    [request setValue:@(data.length).stringValue forHTTPHeaderField:@"Content-Length"];
    
    [NSURLConnection connectionWithRequest:request delegate:self];    

//    __unused __block id json;
//    
//    [request sendAsynchronous:^(id jsonRep, NSError *error) {
//        json = jsonRep;
//        NSString *errorMessage;
//        
//        if (error) {
//            switch ([error code]) {
//                case NSURLErrorUserCancelledAuthentication:
//                    errorMessage = @"Unauthorized";
//                    break;
//                    
//                default:
//                    errorMessage = [error localizedDescription];
//                    break;
//            }
//            [[self serverMessage] setStringValue:[NSString stringWithFormat:@"Error: %@", jsonRep]];
//        }
//        else {
//            [[self serverMessage] setStringValue:@"Punched successfully!"];
//        }
//        
//        [[self serverMessage] setHidden:NO];
//        [[self comment] setStringValue:@""];
//    }];

}

- (IBAction)comment:(id)sender
{
    [[self punchButton] performClick:nil];
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _punchResponseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_punchResponseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}

@end
