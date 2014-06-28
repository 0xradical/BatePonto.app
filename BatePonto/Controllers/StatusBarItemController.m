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

@implementation StatusBarItemController

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // PanelController
    if (![self panelController]) {
        [self setPanelController:[[PanelController alloc] initWithDelegate:self]];
    }
}

- (void)awakeFromNib
{
    [self setItemView:[[StatusBarItemView alloc] initWithDelegate:self]];
}

#pragma mark - IBActions

//- (IBAction)quit:(id)sender
//{
//    [NSApp terminate:nil];
//}

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

#pragma mark - PanelControllerDelegate protocol

- (StatusBarItemView *)statusBarItemViewForPanelController:(id)sender
{
    return [self itemView];
}

@end
