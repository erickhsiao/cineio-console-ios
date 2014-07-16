//
//  CineUser.h
//  Console
//
//  Created by Jeffrey Wescott on 7/11/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CineUser : NSObject

@property (nonatomic, copy, readonly) NSString *userId;
@property (nonatomic, copy, readonly) NSString *email;
@property (nonatomic, copy, readonly) NSString *masterKey;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy, readonly) NSString *firstName;
@property (nonatomic, copy, readonly) NSString *lastName;
@property (nonatomic, copy, readonly) NSString *plan;
@property (nonatomic, copy, readonly) NSDate *joinDate;

- (id)initWithAttributes:(NSDictionary *)userAttributes;

@end
