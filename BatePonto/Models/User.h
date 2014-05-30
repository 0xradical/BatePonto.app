//
//  User.h
//  bate_ponto
//
//  Created by NSRails autogen on 05/30/2014.
//  Copyright (c) 2014 thiago. All rights reserved.
//

#import "NSRails.h"

@class Punch;

@interface User : NSRRemoteObject

@property (nonatomic) NSMutableArray *punches;
@property (nonatomic) NSString *name, *passwordDigest, *token, *shifts, *goals;
@property (nonatomic) NSDate *createdAt, *updatedAt;
@property (nonatomic) NSNumber *admin, *hidden, *flexibleGoal;

@end
