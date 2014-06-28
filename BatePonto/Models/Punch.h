//
//  Punch.h
//  bate_ponto
//
//  Created by NSRails autogen on 05/30/2014.
//  Copyright (c) 2014 thiago. All rights reserved.
//

@class User;

@interface Punch : NSObject

@property (nonatomic) User *user;
@property (nonatomic) NSDate *createdAt, *updatedAt, *punchedAt;
@property (nonatomic) NSNumber *entrance;
@property (nonatomic) NSString *comment;

@end
