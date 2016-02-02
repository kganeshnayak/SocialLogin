//
//  SocialIntegration.h
//  SocialIntegration
//
//  Created by Ganesh Nayak on 07/09/15.
//  Copyright (c) 2015 Ganesh Nayak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SISocialType) {
    SITwitter,
    SIFacebook,
    SILinkedIn,
    SIGooglePlus
};

@protocol SISocialProtocol <NSObject>

-(void) didRecieveUserId:(NSString *) userId forType:(SISocialType) aType;

@end


@interface SocialIntegration : UIViewController

- (void) addFacebookButtonAtFrame:(CGRect) aFrame withImage:(UIImage *) image;
- (void) addLinkedInButtonAtFrame:(CGRect) aFrame withImage:(UIImage *) image;
- (void) addGooglePlusButtonAtFrame:(CGRect) aFrame withImage:(UIImage *) image;
- (void) addTwitterButtonAtFrame:(CGRect) aFrame withImage:(UIImage *) image;


@property (weak, nonatomic) id <SISocialProtocol> delegate;
@end
