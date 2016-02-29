//
//  SIOAuthLoginViewController.h
//  SocialIntegration
//
//  Created by Ganesh Nayak on 07/09/15.
//  Copyright (c) 2015 Ganesh Nayak. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LinkedinProtocol <NSObject>

- (void) fetchLinkedinUserId:(NSString *) userId withEmailId:(NSString *) emailId;

@end

@interface SIOAuthLoginViewController : UIViewController {
  // Theses ivars could be made into a provider class
  // Then you could pass in different providers for Twitter, LinkedIn, etc
  NSString *apikey;
  NSString *secretkey;
  NSString *requestTokenURLString;
  NSURL *requestTokenURL;
  NSString *accessTokenURLString;
  NSURL *accessTokenURL;
  NSString *userLoginURLString;
  NSURL *userLoginURL;
  NSString *linkedInCallbackURL;
}
@property(nonatomic, strong) NSDictionary *profile;
@property(nonatomic, weak) id <LinkedinProtocol> delegate;

- (void)initLinkedInApi;
- (void)requestTokenFromProvider;
- (void)allowUserToLogin;
- (void)accessTokenFromProvider;
- (IBAction)closeBtnTapped;

@end
