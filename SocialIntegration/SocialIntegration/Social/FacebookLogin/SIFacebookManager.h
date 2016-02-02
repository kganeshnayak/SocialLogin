//
//  SIFacebookManager.h
//  SocialIntegration
//
//  Created by Ganesh Nayak on 07/09/15.
//  Copyright (c) 2015 Ganesh Nayak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface SIFacebookManager : NSObject
// This is where our active session is maintained
@property(strong, readonly) FBSession *currentSession;
- (void)clearSessionInManager;
- (FBSession *)createSession;

@end
