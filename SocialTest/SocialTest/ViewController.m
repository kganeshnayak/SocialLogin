//
//  ViewController.m
//  SocialTest
//
//  Created by Ganesh Nayak on 03/09/15.
//  Copyright (c) 2015 Ganesh Nayak. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect theRect = CGRectMake((self.view.frame.size.width/2)-(200/2), 100, 200, 40);

    [self loginToService:SITwitter
   withSignInButtonImage:[UIImage imageNamed:@"login_button_twitter"]
       atCoordinateSpace:theRect withCompletionHandler:^(NSString *userId) {
           NSLog(@"Twitter Id:%@",userId);
       }];
    theRect = CGRectMake((self.view.frame.size.width/2)-(200/2), 150, 200, 40);

    [self loginToService:SIFacebook
   withSignInButtonImage:[UIImage imageNamed:@"login_button_facebook"]
       atCoordinateSpace:theRect withCompletionHandler:^(NSString *userId) {
           NSLog(@"Facebook Id:%@",userId);
       }];
    theRect = CGRectMake((self.view.frame.size.width/2)-(200/2), 200, 200, 40);

    [self loginToService:SIGoogle
   withSignInButtonImage:[UIImage imageNamed:@"login_button_google"]
       atCoordinateSpace:theRect withCompletionHandler:^(NSString *userId) {
           NSLog(@"Google Id:%@",userId);
       }];
    theRect = CGRectMake((self.view.frame.size.width/2)-(200/2), 250, 200, 40);

    [self loginToService:SILinkedIn
   withSignInButtonImage:[UIImage imageNamed:@"login_button_linkedin"]
       atCoordinateSpace:theRect withCompletionHandler:^(NSString *userId) {
           NSLog(@"LinkedIn Id:%@",userId);
       }];
}

@end
