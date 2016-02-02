//
//  SIFacebookManager.m
//  SocialIntegration
//
//  Created by Ganesh Nayak on 07/09/15.
//  Copyright (c) 2015 Ganesh Nayak. All rights reserved.
//

#import "SIFacebookManager.h"

@implementation SIFacebookManager

/*
* create a session object, with defaults accross the board, except that we provide a custom
* instance of FBSessionTokenCachingStrategy
*/

- (FBSession *)createSession {
  FBSession *session = [[FBSession alloc] initWithAppID:nil
                                            permissions:@[ @"public_profile" ]
                                        urlSchemeSuffix:nil
                                     tokenCacheStrategy:nil];
  _currentSession = session;
  return session;
}

/*
 * Current session is destroyed
 */

- (void)clearSessionInManager {
  //    NSLog(@"SUUserManager switching to no active user");
  _currentSession = nil;
}

@end
