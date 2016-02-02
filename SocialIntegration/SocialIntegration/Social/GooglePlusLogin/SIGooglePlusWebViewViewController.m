//
//  SIGooglePlusWebViewViewController.m
//  SocialIntegration
//
//  Created by Ganesh Nayak on 07/09/15.
//  Copyright (c) 2015 Ganesh Nayak. All rights reserved.
//

#import "SIGooglePlusWebViewViewController.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "SIActivityIndicator.h"

@interface SIGooglePlusWebViewViewController ()
@property (strong, nonatomic) UIWebView *googleWebView;

@end

@implementation SIGooglePlusWebViewViewController
@synthesize urlToBeLoaded;

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect viewRect = [[UIScreen mainScreen] bounds];
    _googleWebView = [[UIWebView alloc] initWithFrame:viewRect];
    _googleWebView.delegate = self;
    _googleWebView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _googleWebView.layer.borderWidth = 10.0;

    [self.view addSubview:_googleWebView];
    [SIActivityIndicator showActivityIndicatorInView:_googleWebView];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadURL:self.urlToBeLoaded];
    });
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *closeButtonImage = [UIImage imageNamed:@"btn_close.png"];
    closeButton.frame = CGRectMake(10.0, 0.0, 43.0, 43.0);
    [closeButton setImage:closeButtonImage forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
}

-(void)loadURL:(NSURL*)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.googleWebView loadRequest:request];
}

- (void)closeBtnTapped
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([[[request URL] absoluteString] containsString:@"com.Robosoft.sociallogin:/oauth2callback"]) {
        [GPPURLHandler handleURL:[request URL] sourceApplication:@"com.google.chrome.ios" annotation:nil];
        
        [SIActivityIndicator hideActivityIndicatorInView:self.view];
        // Looks like we did log in (onhand of the url), we are logged in, the Google APi handles the rest
        [self closeBtnTapped];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    [SIActivityIndicator hideActivityIndicatorInView:self.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError");
    [SIActivityIndicator hideActivityIndicatorInView:self.view];
}

@end
