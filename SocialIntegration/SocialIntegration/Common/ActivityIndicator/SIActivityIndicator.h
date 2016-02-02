//
//  SIActivityIndicator.h
//  SocialIntegration
//
//  Created by Ganesh Nayak on 07/09/15.
//  Copyright (c) 2015 Ganesh Nayak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIActivityIndicator : UIView
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

+ (void)showActivityIndicatorInView:(UIView*)sourceView;
+ (void)hideActivityIndicatorInView:(UIView*)sourceView;
+ (void)showActivityIndicatorInRightCornerInView:(UIView*)sourceView; 


-(id)initWithView:(UIView*)sourceView;
-(void)showActivityIndicator;
-(void)hideActivityIndicator;
@end
