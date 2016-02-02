//
//  SIActivityIndicator.m
//  SocialIntegration
//
//  Created by Ganesh Nayak on 07/09/15.
//  Copyright (c) 2015 Ganesh Nayak. All rights reserved.
//

#import "SIActivityIndicator.h"

#define kActivityIndicatorTag 4346
#define IS_OS_7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@implementation SIActivityIndicator

+ (void)showActivityIndicatorInView:(UIView*)sourceView
{
    SIActivityIndicator *loader = (SIActivityIndicator *)[sourceView viewWithTag:kActivityIndicatorTag];
    
    if (loader == nil) {
        loader = [[SIActivityIndicator alloc] initWithFrame:CGRectMake(0.0, 0.0, 40.0, 40.0)];
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [activityIndicatorView setFrame:CGRectMake(10.0, 10.0, 20.0, 20.0)];
        loader.activityIndicator = activityIndicatorView;
        [loader addSubview:activityIndicatorView];
        loader.tag = kActivityIndicatorTag;
        loader.center = sourceView.center;
        [sourceView addSubview:loader];
        
//        CGPoint center = sourceView.center;
//        center.x = sourceView.center.x - sourceView.frame.origin.x;
//        center.y = sourceView.center.y - sourceView.frame.origin.y;
//        
//        loader.center = center;
        loader.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        loader.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
        loader.layer.cornerRadius = 3.0;
    }
    [loader.activityIndicator startAnimating];
    [sourceView bringSubviewToFront:loader];
}

+ (void)showActivityIndicatorInRightCornerInView:(UIView*)sourceView
{
    SIActivityIndicator *loader = (SIActivityIndicator *)[sourceView viewWithTag:kActivityIndicatorTag];
    
    if (loader == nil) {
        loader = [[SIActivityIndicator alloc] initWithFrame:CGRectMake(0.0, 0.0, 40.0, 40.0)];
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [activityIndicatorView setFrame:CGRectMake(10.0, 10.0, 20.0, 20.0)];
        loader.activityIndicator = activityIndicatorView;
        [loader addSubview:activityIndicatorView];
        loader.tag = kActivityIndicatorTag;
        [sourceView addSubview:loader];
        
        //        CGPoint center = sourceView.center;
        //        center.x = sourceView.center.x - sourceView.frame.origin.x;
        //        center.y = sourceView.center.y - sourceView.frame.origin.y;
        //        loader.center = center;
        CGRect loaderFrame = loader.frame;
        CGFloat loaderX = sourceView.frame.size.width - loader.frame.size.width;
        CGFloat loaderY =  (IS_OS_7_OR_LATER)?[UIApplication sharedApplication].statusBarFrame.size.height:5.0;
        loaderFrame.origin.x = loaderX;
        loaderFrame.origin.y = loaderY;
        loader.frame = loaderFrame;
        
        loader.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        loader.backgroundColor = [UIColor clearColor];
        loader.layer.cornerRadius = 3.0;
    }
    [loader.activityIndicator startAnimating];
    [sourceView bringSubviewToFront:loader];
}


+ (void)hideActivityIndicatorInView:(UIView*)sourceView
{
    [[sourceView viewWithTag:kActivityIndicatorTag] removeFromSuperview];
    if([sourceView viewWithTag:kActivityIndicatorTag] != nil)
        [SIActivityIndicator hideActivityIndicatorInView:sourceView];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [activityIndicatorView setFrame:CGRectMake(10.0, 10.0, 20.0, 20.0)];
        self.activityIndicator = activityIndicatorView;
        [self addSubview:activityIndicatorView];
        // Initialization code
    }
    return self;
}

-(id)initWithView:(UIView*)sourceView
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.center = sourceView.center;
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [activityIndicatorView setFrame:CGRectMake(10.0, 10.0, 20.0, 20.0)];
        self.activityIndicator = activityIndicatorView;
        [self addSubview:activityIndicatorView];
        [sourceView addSubview:self];
        self.hidden = YES;
    }
    return self;
}
-(void)showActivityIndicator
{
    [_activityIndicator startAnimating];
    self.hidden = NO;
    
}
-(void)hideActivityIndicator
{
    [_activityIndicator stopAnimating];
    self.hidden = YES;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


@end
