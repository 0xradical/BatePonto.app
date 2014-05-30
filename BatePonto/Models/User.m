//
//  User.m
//  bate_ponto
//
//  Created by NSRails autogen on 05/30/2014.
//  Copyright (c) 2014 thiago. All rights reserved.
//

#import "User.h"
#import "Punch.h"

@implementation User

- (Class) nestedClassForProperty:(NSString *)property
{
    if ([property isEqualToString:@"punches"])
        return [Punch class];

    return [super nestedClassForProperty:property];
}

@end
