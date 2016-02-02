//
//  SIGooglePlusWebViewViewController.h
//  SocialIntegration
//
//  Created by Ganesh Nayak on 07/09/15.
//  Copyright (c) 2015 Ganesh Nayak. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GooglePlusinProtocol <NSObject>

- (void) fetchGooglePlusinUserId:(NSString *) userId;

@end

@interface SIGooglePlusWebViewViewController : UIViewController<UIWebViewDelegate>
{
    
}
@property(nonatomic, weak) id <GooglePlusinProtocol> delegate;
@property (nonatomic, strong) NSURL *urlToBeLoaded;
@end
