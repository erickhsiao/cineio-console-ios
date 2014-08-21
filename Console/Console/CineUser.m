//
//  CineUser.m
//  Console
//
//  Created by Jeffrey Wescott on 7/11/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineUser.h"
#import "CineAccount.h"

@implementation CineUser

@synthesize userId;
@synthesize email;
@synthesize userToken;
@synthesize name;
@synthesize firstName;
@synthesize lastName;
@synthesize plan;
@synthesize joinDate;
@synthesize accounts;

- (id)initWithAttributes:(NSDictionary *)userAttributes
{
    if (self = [super init]) {
        userId = [userAttributes[@"id"] copy];
        email = [userAttributes[@"email"] copy];
        userToken = [userAttributes[@"userToken"] copy];
        name = [userAttributes[@"name"] copy];
        firstName = [userAttributes[@"firstName"] copy];
        lastName = [userAttributes[@"lastName"] copy];
        plan = [userAttributes[@"plan"] copy];
        joinDate = [userAttributes[@"createdAt"] copy];
        
        // set up our accounts info
        NSArray *accountDicts = [userAttributes[@"accounts"] copy];
        if ([accountDicts count] > 0) {
            accounts = [[NSMutableArray alloc] init];
            for (NSDictionary *accountAttributes in accountDicts) {
                CineAccount *account = [[CineAccount alloc] initWithAttributes:accountAttributes];
                [((NSMutableArray *)accounts) addObject:account];
            }
        }        
    }
    
    return self;
}

@end
