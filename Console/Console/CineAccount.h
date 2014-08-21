//
//  CineAccount.h
//  Console
//
//  Created by Jeffrey Wescott on 8/20/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CineAccount : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *masterKey;

- (id)initWithAttributes:(NSDictionary *)accountAttributes;

@end
