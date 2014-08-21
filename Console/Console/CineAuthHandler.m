//
//  CineAuthHandler.m
//  Console
//
//  Created by Jeffrey Wescott on 7/21/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "CineAuthHandler.h"
#import "CineUser.h"
#import "CineAppDelegate.h"

@implementation CineAuthHandler

- (id)init
{
    if (self = [super init]) {
        // custom initialization
    }
    
    return self;
}

- (void)signInWithEmail:(NSString *)email andPassword:(NSString *)password
{
    NSLog(@"sign in");
    NSDictionary *formData =
    @{ @"username": [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],
       @"password": [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],
       @"plan": @"free" };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"https://www.cine.io/login" parameters:formData success:^(AFHTTPRequestOperation *operation, id response) {
        CineUser *user = [[CineUser alloc] initWithAttributes:response];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SignInSuccess"
                                                            object:self
                                                            userInfo:@{ @"user" : user }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SignInFailure"
                                                            object:self
                                                            userInfo:@{ @"error" : error }];
    }];
}

- (void)signInWithUserToken:(NSString *)userToken
{
    NSDictionary *queryString = @{ @"userToken": userToken };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://www.cine.io/api/1/-/user" parameters:queryString success:^(AFHTTPRequestOperation *operation, id response) {
        CineUser *user = [[CineUser alloc] initWithAttributes:response];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SignInSuccess"
                                                            object:self
                                                            userInfo:@{ @"user" : user }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SignInFailure"
                                                            object:self
                                                            userInfo:@{ @"error" : error }];
    }];
}

- (void)updateUserName:(NSString *)name
{
    NSDictionary *formData =
    @{ @"name": [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"https://www.cine.io/api/1/-/update-account" parameters:formData success:^(AFHTTPRequestOperation *operation, id response) {
        CineUser *user = [[CineUser alloc] initWithAttributes:response];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserNameSuccess"
                                                            object:self
                                                            userInfo:@{ @"user" : user }];
        NSLog(@"user name set to %@ for %@", user.name, user.email);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserNameFailure"
                                                            object:self
                                                            userInfo:@{ @"error" : error }];
    }];
}

- (void)initiatePasswordRecoveryForEmail:(NSString *)email
{
    NSDictionary *formData = @{ @"email": [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"https://www.cine.io/api/1/-/password-change-request" parameters:formData success:^(AFHTTPRequestOperation *operation, id response) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"InitiatePasswordRecoverySuccess"
                                                            object:self
                                                          userInfo:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"InitiatePasswordRecoveryFailure"
                                                            object:self
                                                          userInfo:nil];
    }];
}

- (void)signOut
{
    // AFNetworking uses standard cookie storage, so to log out, just delete our cookies
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookies];
    for (NSHTTPCookie *cookie in cookies) {
        [cookieStorage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"SignOutSuccess"
                                                        object:self
                                                      userInfo:nil];
}


@end
