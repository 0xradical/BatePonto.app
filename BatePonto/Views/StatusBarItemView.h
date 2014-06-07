//
//  StatusBarItemView.h
//  BatePonto
//
//  Created by thiago on 6/6/14.
//  Copyright (c) 2014 redealumni. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class StatusBarItemController;

@interface StatusBarItemView : NSView <NSMenuDelegate>

@property (nonatomic, weak) StatusBarItemController *controller;
@property (nonatomic, weak) NSStatusItem *statusItem;
@property (nonatomic, weak) NSMenu *menu;
@property (nonatomic, weak) NSImage *image;

@end
