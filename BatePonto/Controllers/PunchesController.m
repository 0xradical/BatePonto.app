//
//  PunchesController.m
//  BatePonto
//
//  Created by thiago on 6/5/14.
//  Copyright (c) 2014 redealumni. All rights reserved.
//

#import "PunchesController.h"
#import "NSRails.h"
#import "Punch.h"

@interface PunchesController ()

@property (nonatomic) NSArray *punches;

@end

@implementation PunchesController

- (instancetype)init

{
    self = [super initWithWindowNibName:@"PunchesController"];
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

#pragma mark - Data Source Protocol

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.punches count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    Punch *punch = self.punches[row];
    
    return [punch valueForKey:[tableColumn identifier]];
}

- (IBAction)retrieveLatestPunches:(id)sender
{
    NSError *error;

    NSRRequest *request
    = [[NSRRequest GET] routeTo:@"/api/punches"];

    // AuthorizationSettings.plist in Supporting Files
    // Containing a KV pair "API Token" - "Value of API Token"
    NSString *authSettingsFile = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"AuthorizationSettings.plist"];

    NSDictionary *authSettings = [NSDictionary dictionaryWithContentsOfFile:authSettingsFile];

    request.queryParameters = @{
                                @"user_token": @"02c8957ff68e21b24ac46004a6a0790b",
                                @"api_token": authSettings[@"API Token"]
                                };

    id json = [request sendSynchronous:&error];

    self.punches = [Punch objectsWithRemoteDictionaries:json];

    NSLog(@"%@", self.punches);

    [self.punchesList reloadData];
    
}
@end
