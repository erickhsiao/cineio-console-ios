//
//  CineUser.h
//  Console
//
//  Created by Jeffrey Wescott on 7/11/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CineUser : NSObject

//{
//    "firstName" : "Jeffrey",
//    "githubId" : 130597,
//    "name" : "Jeffrey Wescott",
//    "isSiteAdmin" : false,
//    "email" : "jeffrey.wescott@gmail.com",
//    "_accounts" : [
//                   "5386916cce74eb0a00efe401",
//                   "538f7b906345ea080070a695",
//                   "538f7b906345ea080070a695"
//                   ],
//    "createdAt" : "2014-05-29T01:42:56.288Z",
//    "masterKey" : "33d9695843a4b5f6a46843d580cbe0905144ed90e22420795c78dad30e84e436",
//    "lastName" : "Wescott",
//    "id" : "5386916cce74eb0a00efe401",
//    "accounts" : [
//                  {
//                      "masterKey" : "33d9695843a4b5f6a46843d580cbe0905144ed90e22420795c78dad30e84e436",
//                      "id" : "5386916cce74eb0a00efe401",
//                      "tempPlan" : "enterprise"
//                  },
//                  {
//                      "masterKey" : "814b34af2e6c2fc984b1d41501264406116bec2c946da98344f6ed24b5775e72",
//                      "id" : "538f7b906345ea080070a695",
//                      "tempPlan" : "test"
//                  }
//                  ]
//}

@property (nonatomic, copy, readonly) NSString *userId;
@property (nonatomic, copy, readonly) NSString *email;
@property (nonatomic, copy, readonly) NSString *userToken;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy, readonly) NSString *firstName;
@property (nonatomic, copy, readonly) NSString *lastName;
@property (nonatomic, copy, readonly) NSString *plan;
@property (nonatomic, copy, readonly) NSDate *joinDate;
@property (nonatomic, copy, readonly) NSArray *accounts;

- (id)initWithAttributes:(NSDictionary *)userAttributes;

@end
