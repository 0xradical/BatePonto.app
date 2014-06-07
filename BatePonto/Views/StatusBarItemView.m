//
//  StatusBarItemView.m
//  BatePonto
//
//  Created by thiago on 6/6/14.
//  Copyright (c) 2014 redealumni. All rights reserved.
//

#import "StatusBarItemView.h"

// http://vocito.googlecode.com/svn/trunk/StatusItemView.m
// https://github.com/sstephenson/37signalsMenu/blob/master/StatusBarItemView.rb
// http://undefinedvalue.com/2009/07/07/adding-custom-view-nsstatusitem

@interface StatusBarItemView ()

@property (nonatomic) BOOL active;
@property (nonatomic) BOOL waitingForActivation;

@end

@implementation StatusBarItemView

- (id)initWithFrame:(NSRect)frame
{
    NSLog(@"Called initWithFrame for StatusBarItemView");
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setActive:NO];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidActivate:)
                                                 name:NSApplicationDidBecomeActiveNotification
                                               object:nil];
    return self;
}

#pragma mark - Drawing stuff

- (void)drawRect:(NSRect)dirtyRect
{
    NSLog(@"Drawing StatusBarItemView");
    
    [[self statusItem] drawStatusBarBackgroundInRect:[self bounds]
                                       withHighlight:[self active]];
    
    if ([self image]) {
        NSSize imageSize = [[self image] size];
        NSRect imageRect = NSMakeRect(0, 0, imageSize.width, imageSize.height);
        
        [[self image] drawInRect:NSInsetRect([self bounds], 3, 3)
                        fromRect:imageRect
                       operation:NSCompositeSourceOver
                        fraction:1.0f];
    }
    
}

- (void)setImage:(NSImage *)image
{
    _image = image;
    
    [self setNeedsDisplay:YES];
}

#pragma Custom Methods

- (void)showMenu
{
    [[self menu] setDelegate:self];
    [[self statusItem] popUpStatusItemMenu:[self menu]];
    [self setNeedsDisplay:YES];
}

- (void)applicationDidActivate:(NSNotification *)aNotification
{
    NSLog(@"Application did activate");
    if ([self waitingForActivation]) {
        NSLog(@"Showing menu!");
        [self setWaitingForActivation:NO];
        [self showMenu];
    }
}

#pragma mark - User input events

- (void)mouseDown:(NSEvent *)theEvent
{
    if ([NSApp isActive]) {
        [self showMenu];
    } else {
        [NSApp activateIgnoringOtherApps:YES];
        [self setWaitingForActivation:YES];
    }
}

#pragma mark - NSMenuDelegate protocol

- (void)menuWillOpen:(NSMenu *)menu
{
    [self setActive:YES];
    [self setNeedsDisplay:YES];
}

- (void)menuDidClose:(NSMenu *)menu
{
    [self setActive:NO];
    [[self menu] setDelegate:nil];
    [self setNeedsDisplay:YES];
}

@end
