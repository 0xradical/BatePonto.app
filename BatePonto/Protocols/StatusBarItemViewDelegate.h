//
//  StatusBarItemViewDelegate.h
//  BatePonto
//
//  Created by thiago on 6/8/14.
//  Copyright (c) 2014 redealumni. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StatusBarItemViewDelegate <NSObject>
@required
- (void)togglePanel:(id)sender;
@end
