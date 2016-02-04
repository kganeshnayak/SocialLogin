//
//  SocialIntegration.h
//  SocialIntegration
//
//  Created by Ganesh Nayak on 07/09/15.
//  Copyright (c) 2015 Ganesh Nayak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 completionHandler returning dictionary
 */
typedef void (^CompletionHandler)(NSString* userId);


typedef NS_ENUM(NSUInteger, SISocialType) {
    SITwitter,
    SIFacebook,
    SILinkedIn,
    SIGoogle
};

@interface SocialIntegration : UIViewController

- (void) loginToService:(SISocialType) eType withSignInButtonImage:(UIImage *) buttonImage atCoordinateSpace:(CGRect) aRect withCompletionHandler:(CompletionHandler)inCompletionHandler;

@end
