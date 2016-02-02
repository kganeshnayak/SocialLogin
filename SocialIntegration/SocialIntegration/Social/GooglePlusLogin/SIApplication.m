//
//  SIApplication.m
//  SocialIntegration
//
//  Created by Ganesh Nayak on 07/09/15.
//  Copyright (c) 2015 Ganesh Nayak. All rights reserved.
//

#import "SIApplication.h"

@implementation SIApplication

- (BOOL)openURL:(NSURL*)url {
    
    // this whole class is a fix, to get google aut inside the webview
    // http://stackoverflow.com/questions/15281386/google-iphone-api-sign-in-and-share-without-leaving-app/24577040#24577040
    
    if ([[url absoluteString] hasPrefix:@"googlechrome-x-callback:"]) {
        
        return NO;
        
    } else if ([[url absoluteString] hasPrefix:@"https://accounts.google.com/o/oauth2/auth"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ApplicationOpenGoogleAuthNotification object:url];
        return NO;
        
    }
    
    return [super openURL:url];
}
@end
