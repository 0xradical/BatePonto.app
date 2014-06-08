//
//  PanelControllerDelegate.h
//  BatePonto
//
//  Created by thiago on 6/8/14.
//  Copyright (c) 2014 redealumni. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StatusBarItemView;

@protocol PanelControllerDelegate <NSObject>
@required
- (StatusBarItemView *)statusBarItemViewForPanelController:(id)sender;
@end
