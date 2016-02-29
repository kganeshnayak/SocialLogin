# SocialLogin
This project will serve as a login to iOS apps. At present you can login with Facebook, Twitter, LinkedIn and Google.


1. Drag drop the lib file to your project.

2. Drag drop include folder to your project. 

	2.1 #import "SocialIntegration.h"

	2.2 Subclass a view controller with SocialIntegration

	2.3 Add social login buttons as below:

		- (void) loginToService:(SISocialType) eType withSignInButtonImage:(UIImage *) buttonImage atCoordinateSpace:(CGRect) aRect withCompletionHandler:(CompletionHandler)inCompletionHandler;

	Note: For SignIn with Google, add GoogleService-Info.plist to your bundle also add REVERSED_CLIENT_ID (found in GoogleService-Info.plist) to URL Schemes in Target->URL Types.
 	Also note that CompletionHandler is of type completion block with NSDictionary as the parameter.
 	      		
		typedef void (^CompletionHandler)(NSDictionary* userInfo);
Use "userId" key to get user id and "email" to get email id.

3. In your project AppDelegate add these code as below:

	3.1 in method didFinishLaunchingWithOptions add
	
	    	[[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];

	3.2 add another delegate as below:

		- (void)applicationDidBecomeActive:(UIApplication *)application
		{
    			[FBSDKAppEvents activateApp];
		}

	3.3 add open url delegate for iOS 9 as below

		- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options
		{

   			if ([[url scheme] isEqualToString:@“FACEBOOK_URL_SCHEME”])
    			{
        			return [[FBSDKApplicationDelegate sharedInstance] application:app
                                                              			      openURL:url
                                                    													 		     sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                           annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    			}
    			else	// FOR GOOGLE
    			{
        			return [[GIDSignIn sharedInstance] handleURL:url
                                   	            														sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                         annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    			}
		}

	3.4 add open url delegate for OS below iOS 9 as:

		- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation 
		{

    			if ([[url scheme] isEqualToString:@"FACEBOOK_URL_SCHEME"])
    			{
        			return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    			}
    			else 	// FOR GOOGLE
    			{
       				NSDictionary *options = @{UIApplicationOpenURLOptionsSourceApplicationKey: sourceApplication,
                                  			   UIApplicationOpenURLOptionsAnnotationKey: annotation};
        			return [self application:application
                         		  	openURL:url
                         		  	options:options];
    			}
		}
	

4. Add the below keys to your main plist file in your project.

	(You can add all or only those keys required for respective social n/w used in your project)

	FacebookAppID
	FacebookDisplayName
	TwitterConsumerKey
	TwitterSecretKey
	LinkedInApiKey
	LinkedInSecretKey
	GoogleClientId
 
5. Add the following frameworks to your project.

	(You can add all or only those frameworks required for respective social n/w used in your project)

	AssetsLibrary.framework
	CoreLocation.framework
	MediaPlayer.framework
	CoreText.framework
	CoreGraphics.framework
	CoreFoundation.framework
	Foundation.framework
	Security.framework
	SystemConfiguration.framework
	MessageUI.framework
	MobileCoreServices.framework
	CoreMotion.framework
	QuartzCore.framework
	FBSDKCoreKit.framework
	FBSDKLoginKit.framework
	GoogleSignIn.bundle
	GoogleSignIn.framework
