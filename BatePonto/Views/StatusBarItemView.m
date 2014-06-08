//
//  StatusBarItemView.m
//  BatePonto
//
//  Created by thiago on 6/6/14.
//  Copyright (c) 2014 redealumni. All rights reserved.
//

// Based off: https://github.com/shpakovski/Popup
// Tried to use popover, but it's still too hacky!

#import "StatusBarItemView.h"

@implementation StatusBarItemView

- (instancetype)initWithDelegate:(id<StatusBarItemViewDelegate>)delegate
{
    NSStatusItem *statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:STATUS_ITEM_VIEW_WIDTH];
    
    [statusItem setImage:[NSImage imageNamed:@"Clock"]];
    [statusItem setView:self];
    
    CGFloat itemWidth = STATUS_ITEM_ICON_WIDTH;
    CGFloat itemHeight = [[NSStatusBar systemStatusBar] thickness];
    NSRect itemRect = NSMakeRect(0.0, 0.0, itemWidth, itemHeight);
    
    self = [super initWithFrame:itemRect];
    
    if (self) {
        [self setStatusItem:statusItem];
        [self setDelegate:delegate];
    }
    
    return self;
}

#pragma mark - Drawing stuff

- (void)drawRect:(NSRect)dirtyRect
{
    [[self statusItem] drawStatusBarBackgroundInRect:dirtyRect
                                       withHighlight:[self isHighlighted]];
    
//    NSImage *icon = self.isHighlighted ? self.alternateImage : self.image;
    NSSize iconSize = [[self image] size];
    NSRect bounds = self.bounds;
    CGFloat iconX = roundf((NSWidth(bounds) - iconSize.width) / 2);
    CGFloat iconY = roundf((NSHeight(bounds) - iconSize.height) / 2);
    NSPoint iconPoint = NSMakePoint(iconX, iconY);
    
	[[self image] drawAtPoint:iconPoint
                     fromRect:NSZeroRect
                    operation:NSCompositeSourceOver
                     fraction:1.0];
}

#pragma mark - User input events

- (void)mouseDown:(NSEvent *)theEvent
{
    if ([self delegate]) {
        [[self delegate] performSelector:@selector(togglePanel:)
                              withObject:self];
    }
}

#pragma mark - Accessors

- (void)setImage:(NSImage *)image
{
    if (_image != image) {
        _image = image;
        [self setNeedsDisplay:YES];
    }
}

- (void)setHighlighted:(BOOL)isHighlighted
{
    if (_isHighlighted == isHighlighted) {
        return;
    }
    else {
        _isHighlighted = isHighlighted;
        [self setNeedsDisplay:YES];
    }
}

#pragma mark - Custom Methods

- (NSRect)globalRect
{
    return [[self window] convertRectToScreen:[self frame]];
}

@end
