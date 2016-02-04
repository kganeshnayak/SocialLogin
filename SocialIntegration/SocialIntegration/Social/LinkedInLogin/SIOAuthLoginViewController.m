//
//  SIOAuthLoginViewController.m
//  SocialIntegration
//
//  Created by Ganesh Nayak on 07/09/15.
//  Copyright (c) 2015 Ganesh Nayak. All rights reserved.
//

#import "SIOAuthLoginViewController.h"
#import <Foundation/NSNotificationQueue.h>
#import "SIActivityIndicator.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OATokenManager.h"

#define API_KEY_LENGTH 12
#define SECRET_KEY_LENGTH 16

@interface SIOAuthLoginViewController ()<UIWebViewDelegate>
@property(nonatomic, strong) OAToken *requestToken;
@property(nonatomic, strong) OAToken *accessToken;
@property(nonatomic, strong) OAConsumer *consumer;
@property (strong, nonatomic) UIWebView* linkedInWebView;

@end

@implementation SIOAuthLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect viewRect = [[UIScreen mainScreen] bounds];
    _linkedInWebView = [[UIWebView alloc] init];
    _linkedInWebView.delegate = self;
    _linkedInWebView.frame = viewRect;

    [self.view addSubview:_linkedInWebView];
    [self initLinkedInApi];
    self.linkedInWebView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.linkedInWebView.layer.borderWidth = 10.0;
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *closeButtonImage = [UIImage imageNamed:@"btn_close.png"];
    closeButton.frame = CGRectMake(10.0, 0.0, 43.0, 43.0);
    [closeButton setImage:closeButtonImage forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if ([apikey length] < API_KEY_LENGTH ||
        [secretkey length] < SECRET_KEY_LENGTH) {
        UIAlertView* alert = [[UIAlertView alloc]
                initWithTitle:@"OAuth Starter Kit"
                      message:@"You must add your apikey and secretkey.  See the "
                      @"project file readme.txt"
                     delegate:nil
            cancelButtonTitle:@"OK"
            otherButtonTitles:nil];
        [alert show];

        [self profileApiCall];
    }
    [self requestTokenFromProvider];
}

- (void)closeBtnTapped
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)profileApiCall
{
    NSURL* url = [NSURL URLWithString:@"https://api.linkedin.com/v1/people/~"];
    OAMutableURLRequest* request =
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:self.consumer
                                       token:self.accessToken
                                    callback:nil
                           signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    OADataFetcher* fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(profileApiCallResult:didFinish:)
                  didFailSelector:@selector(profileApiCallResult:didFail:)];
}

- (void)profileApiCallResult:(OAServiceTicket*)ticket
                   didFinish:(NSData*)data
{
    
    NSDictionary* profile = [NSJSONSerialization JSONObjectWithData:data
                                    options:NSJSONReadingMutableContainers
                                      error:nil];
    // NSLog(@"Profile information =%@", profile);
    
    NSDictionary* siteStandardProfileRequest = profile[@"siteStandardProfileRequest"];
    NSString* url = siteStandardProfileRequest[@"url"];
    
    NSString* userId;
    NSString* string = url;
    
    NSRange range = [string rangeOfString:@"id="];
    NSString* tempUrl = [string substringFromIndex:range.location];
    NSRange range2 = [tempUrl rangeOfString:@"&"];
    
    userId = [tempUrl substringWithRange:NSMakeRange(0, range2.location)];
    userId = [userId stringByReplacingOccurrencesOfString:@"id=" withString:@""];
    
    if (userId) {
        // NSLog(@"User id is %@",userId);
        
        if ([self.delegate respondsToSelector:@selector(fetchLinkedinUserId:)])
        {
            [self.delegate fetchLinkedinUserId:userId];
        }
        [SIActivityIndicator hideActivityIndicatorInView:self.view];
        [self closeBtnTapped];
    }
}

- (void)profileApiCallResult:(OAServiceTicket*)ticket didFail:(NSData*)error
{
    NSLog(@"%@", [error description]);
    [self closeBtnTapped];
}



#pragma mark - OAcuth related -

/*
* OAuth step 1a:
* The first step in the the OAuth process to make a request for a "request
* token".
* Yes it's confusing that the work request is mentioned twice like that, but it
* is whats happening.
*/
- (void)requestTokenFromProvider
{
    [SIActivityIndicator showActivityIndicatorInView:self.linkedInWebView];

    OAMutableURLRequest* request = [[OAMutableURLRequest alloc] initWithURL:requestTokenURL
                                        consumer:self.consumer
                                           token:nil
                                        callback:linkedInCallbackURL
                               signatureProvider:nil];

    [request setHTTPMethod:@"POST"];

    // These arguments are not optional any more hence commented
    //    OARequestParameter *nameParam = [[OARequestParameter alloc]
    //    initWithName:@"scope"
    //                                                                       value:@"r_basicprofile+rw_nus"];
    //    NSArray *params = [NSArray arrayWithObjects:nameParam, nil];
    //    [request setParameters:params];
    //    OARequestParameter * scopeParameter=[OARequestParameter
    //    requestParameter:@"scope" value:@"r_fullprofile rw_nus"];
    //
    //    [request setParameters:[NSArray arrayWithObject:scopeParameter]];
    //..

    OADataFetcher* fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenResult:didFinish:)
                  didFailSelector:@selector(requestTokenResult:didFail:)];
}

/*
* OAuth step 1b:
*
* When this method is called it means we have successfully received a request
* token.
* We then show a webView that sends the user to the LinkedIn login page.
* The request token is added as a parameter to the url of the login page.
* LinkedIn reads the token on their end to know which app the user is granting
* access to.
*/

- (void)requestTokenResult:(OAServiceTicket*)ticket didFinish:(NSData*)data
{
    if (ticket.didSucceed == NO)
        return;

    NSString* responseBody = [[NSString alloc] initWithData:data
                              encoding:NSUTF8StringEncoding];
    self.requestToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
    [self allowUserToLogin];
}

- (void)requestTokenResult:(OAServiceTicket*)ticket didFail:(NSData*)error
{
    [SIActivityIndicator hideActivityIndicatorInView:self.linkedInWebView];

    NSLog(@"%@", [error description]);
}

/*
* OAuth step 2:
*
* Show the user a browser displaying the LinkedIn login page.
* They type username/password and this is how they permit us to access their
* data
* We use a UIWebView for this.
*
* Sending the token information is required, but in this one case OAuth
* requires us
* to send URL query parameters instead of putting the token in the HTTP
* Authorization
* header as we do in all other cases.
*/

- (void)allowUserToLogin
{
    NSString *userLoginURLWithToken = [NSString stringWithFormat:@"%@?oauth_token=%@", userLoginURLString, self.requestToken.key];
    userLoginURL = [NSURL URLWithString:userLoginURLWithToken];
    // As per the ticket -	WAMO-2765 - set header field - HttpOnly as true.
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:userLoginURL
                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                            timeoutInterval:180.0];
    [urlRequest setValue:@"true" forHTTPHeaderField:@"HttpOnly"];
    [self.linkedInWebView loadRequest:urlRequest];
}

#pragma mark - UIWebView Delegate Methods -
/*
* OAuth step 3:
*
* This method is called when our webView browser loads a URL, this happens 3
* times:
*
*      a) Our own [webView loadRequest] message sends the user to the LinkedIn
*      login page.
*
*      b) The user types in their username/password and presses 'OK', this will
*      submit their credentials to LinkedIn
*
*      c) LinkedIn responds to the submit request by redirecting the browser to
*      our callback URL
*         If the user approves they also add two parameters to the callback
*         URL: oauth_token and oauth_verifier.
*         If the user does not allow access the parameter user_refused is
*         returned.
*
*      Example URLs for these three load events:
*      a) https://www.linkedin.com/uas/oauth/authorize?oauth_token=<token
*          value>
*
*      b) https://www.linkedin.com/uas/oauth/authorize/submit   OR
*             https://www.linkedin.com/uas/oauth/authenticate?oauth_token=<token
*             value>&trk=uas-continue
*
*      c) hdlinked://linkedin/oauth?oauth_token=<token
*          value>&oauth_verifier=63600 OR
*          hdlinked://linkedin/oauth?user_refused
*
*
*  Note: We only need to handle case (c) to extract the oauth_verifier value
*/

- (BOOL)webView:(UIWebView*)webView
    shouldStartLoadWithRequest:(NSURLRequest*)request
                navigationType:(UIWebViewNavigationType)navigationType
{

    NSURL* url = request.URL;
    NSString* urlString = url.absoluteString;

    BOOL requestForCallbackURL = ([urlString rangeOfString:linkedInCallbackURL].location != NSNotFound);
    if (requestForCallbackURL) {
        BOOL userAllowedAccess = ([urlString rangeOfString:@"user_refused"].location == NSNotFound);
        if (userAllowedAccess) {
            [self.requestToken setVerifierWithUrl:url];
            [self accessTokenFromProvider];
        }
        else {
            // User refused to allow our app access
            // Notify parent and close this view
//            [[NSNotificationCenter defaultCenter]
//                postNotificationName:@"loginViewDidFinish"
//                              object:self
//                            userInfo:nil];
//
            // Dissmiss view controller
            [self profileApiCall];
        }
    }
    else {
        // Case (a) or (b), so ignore it
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    [SIActivityIndicator hideActivityIndicatorInView:self.linkedInWebView];
    CGSize contentSize = self.linkedInWebView.scrollView.contentSize;
    CGSize viewSize = self.view.bounds.size;

    float newValue = viewSize.width / contentSize.width;

    self.linkedInWebView.scrollView.minimumZoomScale = newValue;
    self.linkedInWebView.scrollView.maximumZoomScale = newValue;
    self.linkedInWebView.scrollView.zoomScale = newValue;
}

- (void)webViewDidStartLoad:(UIWebView*)webView
{
    // NSLog(@"WebView Load started");
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error
{
    NSLog(@"Error in loading the webview =%@", error);
}

/*
* OAuth step 4:
*/
- (void)accessTokenFromProvider
{
    OAMutableURLRequest* request = [[OAMutableURLRequest alloc] initWithURL:accessTokenURL
                                        consumer:self.consumer
                                           token:self.requestToken
                                        callback:nil
                               signatureProvider:nil];

    [request setHTTPMethod:@"POST"];
    OADataFetcher* fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(accessTokenResult:didFinish:)
                  didFailSelector:@selector(accessTokenResult:didFail:)];
}

- (void)accessTokenResult:(OAServiceTicket*)ticket didFinish:(NSData*)data
{
    NSString* responseBody = [[NSString alloc] initWithData:data
                              encoding:NSUTF8StringEncoding];

    BOOL problem = ([responseBody rangeOfString:@"oauth_problem"].location != NSNotFound);
    if (problem) {
        // NSLog(@"Request access token failed.");
        NSLog(@"%@", responseBody);
    }
    else {
        self.accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
    }
    [self profileApiCall];
}

- (void)accessTokenResult:(OAServiceTicket*)ticket didFail:(NSData*)data
{
}

/*
*  This api consumer data could move to a provider object
*  to allow easy switching between LinkedIn, Twitter, etc.
*/
- (void)initLinkedInApi
{
    apikey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"LinkedInApiKey"];
    secretkey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"LinkedInSecretKey"];

    self.consumer = [[OAConsumer alloc] initWithKey:apikey
                                             secret:secretkey
                                              realm:@"https://api.linkedin.com/"];

    requestTokenURLString = @"https://api.linkedin.com/uas/oauth/requestToken";
    accessTokenURLString = @"https://api.linkedin.com/uas/oauth/accessToken";
    userLoginURLString = @"https://www.linkedin.com/uas/oauth/authorize";
    linkedInCallbackURL = @"hdlinked://linkedin/oauth";

    requestTokenURL = [NSURL URLWithString:requestTokenURLString];
    accessTokenURL = [NSURL URLWithString:accessTokenURLString];
    userLoginURL = [NSURL URLWithString:userLoginURLString];
}

@end
