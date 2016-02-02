//
//  ViewController.m
//  SocialTest
//
//  Created by Ganesh Nayak on 03/09/15.
//  Copyright (c) 2015 Ganesh Nayak. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<SISocialProtocol>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;

    CGRect theRect = CGRectMake((self.view.frame.size.width/2)-(200/2), 100, 200, 40);
    [self addFacebookButtonAtFrame:theRect withImage:[UIImage imageNamed:@"login_button_facebook"]];
    theRect = CGRectMake((self.view.frame.size.width/2)-(200/2), 150, 200, 40);
    [self addLinkedInButtonAtFrame:theRect withImage:[UIImage imageNamed:@"login_button_linkedin"]];
     theRect = CGRectMake((self.view.frame.size.width/2)-(200/2), 200, 200, 40);
    [self addGooglePlusButtonAtFrame:theRect withImage:[UIImage imageNamed:@"login_button_google"]];
    theRect = CGRectMake((self.view.frame.size.width/2)-(200/2), 250, 200, 40);
    [self addTwitterButtonAtFrame:theRect withImage:[UIImage imageNamed:@"login_button_twitter"]];
}

- (void) didRecieveUserId:(NSString *) userId forType:(SISocialType) aType
{
    NSLog(@"userId:%@",userId);
}

@end
