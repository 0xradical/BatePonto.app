//
//  Punch.h
//  bate_ponto
//
//  Created by NSRails autogen on 05/30/2014.
//  Copyright (c) 2014 thiago. All rights reserved.
//

#import "NSRails.h"

@class User;

@interface Punch : NSRRemoteObject

@property (nonatomic) User *user;
@property (nonatomic) NSDate *createdAt, *updatedAt, *punchedAt;
@property (nonatomic) NSNumber *entrance;
@property (nonatomic) NSString *comment;

@end
