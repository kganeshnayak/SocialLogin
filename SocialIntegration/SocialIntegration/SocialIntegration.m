//
//  SocialIntegration.m
//  SocialIntegration
//
//  Created by Ganesh Nayak on 07/09/15.
//  Copyright (c) 2015 Ganesh Nayak. All rights reserved.
//

#import "SocialIntegration.h"
#import "SIOAuthLoginViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "SIActivityIndicator.h"
#import "FHSTwitterEngine.h"

#import <GoogleSignIn/GoogleSignIn.h>

@interface SocialIntegration()<LinkedinProtocol, GIDSignInUIDelegate, GIDSignInDelegate>
@property (nonatomic, copy) CompletionHandler fbCompletionHandler;
@property (nonatomic, copy) CompletionHandler glCompletionHandler;
@property (nonatomic, copy) CompletionHandler liCompletionHandler;
@property (nonatomic, copy) CompletionHandler twCompletionHandler;

@end

@implementation SocialIntegration

- (void) viewDidLoad
{
    [super viewDidLoad];
}

- (void) loginToService:(SISocialType) eType withSignInButtonImage:(UIImage *) buttonImage atCoordinateSpace:(CGRect) aRect withCompletionHandler:(CompletionHandler)inCompletionHandler
{
    switch (eType) {
        case SITwitter:
            [self addImageForType:SITwitter withFrame:aRect withImage:buttonImage];
            _twCompletionHandler = inCompletionHandler;
            break;
        case SIFacebook:
            [self addImageForType:SIFacebook withFrame:aRect withImage:buttonImage];
            _fbCompletionHandler = inCompletionHandler;
            break;
        case SIGoogle:
            [self addImageForType:SIGoogle withFrame:aRect withImage:buttonImage];
            _glCompletionHandler = inCompletionHandler;
            break;
        case SILinkedIn:
            [self addImageForType:SILinkedIn withFrame:aRect withImage:buttonImage];
            _liCompletionHandler = inCompletionHandler;
            break;
        default:
            break;
    }
}

- (void) addImageForType:(SISocialType) aType withFrame:(CGRect) aFrame withImage:(UIImage *) image
{
    UIButton *socialSignInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backgroundButtonImage = image;
    socialSignInButton.frame = aFrame;
    [socialSignInButton setBackgroundImage:backgroundButtonImage forState:UIControlStateNormal];
    
    switch (aType) {
        case SIFacebook:
            [socialSignInButton addTarget:self action:@selector(signInWithFacebook) forControlEvents:UIControlEventTouchUpInside];
            break;
        case SIGoogle:
            [socialSignInButton addTarget:self action:@selector(signInGoogle) forControlEvents:UIControlEventTouchUpInside];
            break;
        case SILinkedIn:
            [socialSignInButton addTarget:self action:@selector(signInWithLinkedIn) forControlEvents:UIControlEventTouchUpInside];
            break;
        case SITwitter:
            [socialSignInButton addTarget:self action:@selector(signInTwitter) forControlEvents:UIControlEventTouchUpInside];
            break;
        default:
            break;
    }
    [self.view addSubview:socialSignInButton];
}

- (void) signInTwitter
{
    NSString *consumerKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"TwitterConsumerKey"];
    NSString *secretKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"TwitterSecretKey"];
    [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:consumerKey andSecret:secretKey];

    UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success) {
        FHSTwitterEngine *twitterEngine = [FHSTwitterEngine sharedEngine];
        _twCompletionHandler (@{@"userId":twitterEngine.authenticatedID, @"email":@""});
    }];
    [self presentViewController:loginController animated:YES completion:nil];
}

- (void) signInGoogle
{
    [GIDSignIn sharedInstance].clientID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"GoogleClientId"];
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    //the following line is optional, default value is YES anyway
    [GIDSignIn sharedInstance].allowsSignInWithWebView = YES;
    [[GIDSignIn sharedInstance] signIn];
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
//    NSString *idToken = user.authentication.idToken; // Safe to send to the server
//    NSString *name = user.profile.name;
    NSString *email = user.profile.email;
    _glCompletionHandler (@{@"userId":userId, @"email":email});
}

- (void) signInWithLinkedIn
{
    SIOAuthLoginViewController *linkedInController = [[SIOAuthLoginViewController alloc] init];
    linkedInController.view.frame = self.view.bounds;
    linkedInController.delegate = self;
    [self addChildViewController:linkedInController];
    [self.view addSubview:linkedInController.view];
    [self performBounceEffectWithView:linkedInController.view];
}

- (void) signInWithFacebook
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         
         NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
         [parameters setValue:@"id, name, email" forKey:@"fields"];

         
         
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             
             
             
             [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
              startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result1, NSError *error1)
              {
                  NSLog(@"Fetched user is:%@", result1);
              }];

             NSString *userId = [result.token userID];                  // For client-side use only!
             _fbCompletionHandler (@{@"userId":userId, @"email":@""});
         }
     }];
}

- (void) performBounceEffectWithView:(UIView *) theView
{
    theView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    [UIView animateWithDuration:0.3/1.5 animations:^{
        theView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/4 animations:^{
            theView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/4 animations:^{
                theView.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}

- (void) fetchLinkedinUserId:(NSString *) userId withEmailId:(NSString *) emailId
{
    _liCompletionHandler (@{@"userId":userId, @"email":@""});
}

@end
