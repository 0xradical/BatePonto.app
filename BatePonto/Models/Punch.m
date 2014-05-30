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

- (BOOL) shouldOnlySendIDKeyForNestedObjectProperty:(NSString *)property
{
    return [property isEqualToString:@"user"];
}

@end
