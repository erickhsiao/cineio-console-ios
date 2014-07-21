//
//  CineAuthHandler.h
//  Console
//
//  Created by Jeffrey Wescott on 7/21/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CineAuthHandler : NSObject

- (void)signInWithEmail:(NSString *)email andPassword:(NSString *)password;
- (void)signInWithMasterKey:(NSString *)masterKey;
- (void)updateUserName:(NSString *)name;
- (void)initiatePasswordRecoveryForEmail:(NSString *)email;
- (void)signOut;

@end
