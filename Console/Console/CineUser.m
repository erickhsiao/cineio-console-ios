//
//  CineUser.m
//  Console
//
//  Created by Jeffrey Wescott on 7/11/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineUser.h"

@implementation CineUser

@synthesize userId;
@synthesize email;
@synthesize name;
@synthesize firstName;
@synthesize lastName;
@synthesize plan;
@synthesize joinDate;

- (id)initWithAttributes:(NSDictionary *)userAttributes
{
    if (self = [super init]) {
        userId = [userAttributes[@"id"] copy];
        email = [userAttributes[@"email"] copy];
        name = [userAttributes[@"name"] copy];
        firstName = [userAttributes[@"firstName"] copy];
        lastName = [userAttributes[@"lastName"] copy];
        plan = [userAttributes[@"plan"] copy];
        joinDate = [userAttributes[@"createdAt"] copy];
    }
    
    return self;
}
@end
