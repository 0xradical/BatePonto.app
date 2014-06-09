//
//  StatusBarItemView.h
//  BatePonto
//
//  Created by thiago on 6/6/14.
//  Copyright (c) 2014 redealumni. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StatusBarItemViewDelegate.h"

#define STATUS_ITEM_VIEW_WIDTH 24.0
#define STATUS_ITEM_ICON_WIDTH 22.0

@interface StatusBarItemView : NSView

@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, setter = setHighlighted:) BOOL isHighlighted;
@property (nonatomic, strong) NSImage *image;
@property (nonatomic, strong) NSImage *alternateImage;
@property (nonatomic, readonly) NSRect globalRect;
@property (nonatomic, weak) id<StatusBarItemViewDelegate> delegate;

- (instancetype)initWithDelegate:(id<StatusBarItemViewDelegate>)delegate;

@end
