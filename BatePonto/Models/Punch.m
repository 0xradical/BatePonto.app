//
//  Punch.m
//  bate_ponto
//
//  Created by NSRails autogen on 05/30/2014.
//  Copyright (c) 2014 thiago. All rights reserved.
//

#import "Punch.h"
#import "User.h"

@implementation Punch

- (NSString *)description
{
    return [NSString stringWithFormat:@"Punch entrance:%@ createdAt:%@ updatedAt:%@ punchedAt:%@ comment:%@", [self.entrance isEqualToNumber:[NSNumber numberWithInt:1]] ? @"YES" : @"NO",
            self.createdAt,
            self.updatedAt,
            self.punchedAt,
            self.comment];
}

@end
