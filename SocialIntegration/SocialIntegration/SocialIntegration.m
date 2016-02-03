//
//  SocialIntegration.m
//  SocialIntegration
//
//  Created by Ganesh Nayak on 07/09/15.
//  Copyright (c) 2015 Ganesh Nayak. All rights reserved.
//

#import "SocialIntegration.h"
#import "SIOAuthLoginViewController.h"

#import <FacebookSDK/FacebookSDK.h>
#import "SIActivityIndicator.h"
#import "SIFacebookManager.h"
#import "FHSTwitterEngine.h"

#import <GoogleSignIn/GoogleSignIn.h>

@interface SocialIntegration()<LinkedinProtocol, GIDSignInUIDelegate>
@property (nonatomic, strong) SIFacebookManager *facebookManager;
@end

@implementation SocialIntegration

- (void) viewDidLoad
{
    [super viewDidLoad];
}

- (void) addFacebookButtonAtFrame:(CGRect) aFrame withImage:(UIImage *) image
{
    [self addImageForType:SIFacebook withFrame:aFrame withImage:image];
}

- (void) addLinkedInButtonAtFrame:(CGRect) aFrame withImage:(UIImage *) image
{
    [self addImageForType:SILinkedIn withFrame:aFrame withImage:image];
}

- (void) addGooglePlusButtonAtFrame:(CGRect) aFrame withImage:(UIImage *) image
{
    [self addImageForType:SIGooglePlus withFrame:aFrame withImage:image];
}

- (void) addTwitterButtonAtFrame:(CGRect) aFrame withImage:(UIImage *) image
{
    [self addImageForType:SITwitter withFrame:aFrame withImage:image];
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
        case SIGooglePlus:
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
        NSLog(@"Twitter Id: %@", twitterEngine.authenticatedID);

    }];
    [self presentViewController:loginController animated:YES completion:nil];
}

- (void) signInGoogle
{
    [GIDSignIn sharedInstance].clientID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"GoogleClientId"];
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
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
//    NSString *email = user.profile.email;
    if ([self.delegate respondsToSelector:@selector(didRecieveUserId:forType:)])
    {
        [self.delegate didRecieveUserId:userId forType:SIGooglePlus];
    }
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
    [self loginWithFacebook];
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

- (void) loginWithFacebook
{
    _facebookManager = [[SIFacebookManager alloc] init];
    [_facebookManager clearSessionInManager];
    
    FBSessionLoginBehavior behavior = FBSessionLoginBehaviorForcingWebView;
    FBSession *session = [_facebookManager createSession];
    
    // we pass the correct behavior here to indicate the login workflow to use
    // (Facebook Login, fallback, etc.)
    [session openWithBehavior:behavior
            completionHandler:^(FBSession* innerSession, FBSessionState status,
                                NSError* error) {
                // this handler is called back whether the login succeeds or
                // fails; in the
                // success case it will also be called back upon each state
                // transition between
                // session-open and session-close
                [SIActivityIndicator showActivityIndicatorInView:self.view];

                if (error) {
                    NSLog(@"Error Occured");
                    [_facebookManager clearSessionInManager];
                    [SIActivityIndicator hideActivityIndicatorInView:self.view];
                }
                [self updateUserSession];
            }];
}

- (void)updateUserSession
{
    // Get the current session from the userManager
    FBSession* session = _facebookManager.currentSession;
    
    if (session.isOpen) {
        // fetch profile info such as name, id, etc. for the open session
        FBRequest *me = [[FBRequest alloc] initWithSession:session graphPath:@"me"];
        
        [me startWithCompletionHandler:^(FBRequestConnection* connection,
                                         NSDictionary<FBGraphUser>* result,
                                         NSError* error) {
            [SIActivityIndicator hideActivityIndicatorInView:self.view];

            NSString *userId = result.id;
            NSLog(@"Facebook UserID: %@", userId);
            
            if ([self.delegate respondsToSelector:@selector(didRecieveUserId:forType:)])
            {
                [self.delegate didRecieveUserId:userId forType:SIFacebook];
            }
            // we interpret an error in the initial fetch as a reason to
            // fail the user switch, and leave the application without an
            // active user (similar to initial state)
            if (error) {
                NSLog(@"Couldn't switch user: %@", error.localizedDescription);
                [_facebookManager clearSessionInManager];
                return;
            }
        }];
    }
    else {
        [SIActivityIndicator hideActivityIndicatorInView:self.view];

        // in the closed case, we check to see if we picked up a cached token that
        // we
        // expect to be valid and ready for use; if so then we open the session on
        // the spot
        if (session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session
            // usable
            [session openWithCompletionHandler:^(FBSession* innerSession,
                                         FBSessionState status, NSError* error) {
                 [self updateUserSession];
             }];
        }
    }
    
    [FBRequestConnection startWithGraphPath:@"/me" parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection* connection,
                         NSDictionary<FBGraphUser>* result, NSError* error)
     {
//         NSLog(@"User Info =%@", result);
         /* handle the result */
     }];
}

- (void) fetchLinkedinUserId:(NSString *) userId
{
    if ([self.delegate respondsToSelector:@selector(didRecieveUserId:forType:)])
    {
        [self.delegate didRecieveUserId:userId forType:SILinkedIn];
    }
}

@end
