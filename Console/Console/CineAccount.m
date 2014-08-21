//
//  CineAccount.m
//  Console
//
//  Created by Jeffrey Wescott on 8/20/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineAccount.h"

@implementation CineAccount

@synthesize name;
@synthesize masterKey;

- (id)initWithAttributes:(NSDictionary *)accountAttributes
{
    if (self = [super init]) {
        name = [accountAttributes[@"name"] copy];
        masterKey = [accountAttributes[@"masterKey"] copy];
    }
    
    return self;
}

@end
